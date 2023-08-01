import { Router } from "express";
import { app, clients, wiki } from "..";
import fs from "fs";
import { ConvertToLuaReadable, downloadImage, getCroppedImage } from "../imageHandler";
import { v4 as uuidv4 } from 'uuid';


const router = Router();

router.get("/statistics/heartbeat", async (req, res) => {
    const { id, timestamp } = req.query;

    if (!id) {
        return res.status(400).json({
            error: "You must provide an id"
        });
    }

    if (!timestamp) {
        return res.status(400).json({
            error: "You must provide a timestamp"
        });
    }

    if (!clients.has(id as string)) {
        return res.status(400).json({
            error: "Invalid id"
        });
    }

    clients.set(id as string, 60);

    res.json({
        success: true,
        type: "heartbeat",
        message: "Heartbeat received",
        ping: Date.now() - parseInt(timestamp as string)
    });
});

router.get("/statistics/count", async (req, res) => {
    res.status(200).json({
        type: "count",
        count: clients.size
    });
});

router.get("/statistics/connection", async (req, res) => {
    if (!req.query.timestamp) {
        return res.status(400).json({
            error: "You must provide a timestamp"
        });
    }

    const uuid = uuidv4();

    // Give the client 70  seconds to send a heartbeat
    // 10 more seconds than the default heartbeat interval
    // to account for network latency and other factors
    clients.set(uuid, 70);

    return res.json({
        type: "connection",
        success: true,
        message: "Connection successful",
        ping: Date.now() - parseInt(req.query.timestamp as string),
        uuid: uuid
    });
});

router.get("/search", async (req, res) => {
    const { query } = req.query;

    if (!query) {
        return res.status(400).json({
            error: "You must provide a query"
        });
    }

    const results = await wiki.search(query as string);

    res.json({
        type: "search",
        results: results
    });
});

router.get("/page", async (req, res) => {
    const { query } = req.query;

    if (!query) {
        return res.status(400).json({
            error: "You must provide a query"
        });
    }

    try {
        console.log("Getting page " + query);
        const page = await wiki.page(query as string);

        const links = await page.links();
        let content = await page.content();

        // Now loop through every value in the content array and replace the links
        // If the value has a items property, we need to loop through that too
        // And if that has a items property, we need to loop through that too
        // And so on and so forth
        // This is a recursive function
        const replaceLinks = (content: any) => {
            for (const key in content) {
                if (key == "items") {
                    for (const item of content[key]) {
                        replaceLinks(item);
                    }
                } else {
                    if (typeof content[key] == "string") {
                        for (const link of links) {
                            content[key] = content[key].replace(link, `<a href="./${link}">${link}</a>`);
                        }
                    } else {
                        replaceLinks(content[key]);
                    }
                }
            }
        }

        replaceLinks(content);

        let images = await page.images();

        // SVGs cause issues with the image handler so we need to remove them
        const blacklistedExtensions = [".svg", ".gif", ".ogg", ".mp4", ".mp3"];
        images = images.filter((image: string) => {
            for (const extension of blacklistedExtensions) {
                if (image.endsWith(extension)) {
                    return false;
                }
            }

            return true;
        });

        res.json({
            type: "page",
            page: page,
            images: images,
            mainImage: await page.mainImage(),
            summary: await page.summary(),
            content: content,
        });
    } catch (error: any) {
        res.status(500).json({
            error: error.message || error
        });
    }

});

router.get("/image/crop", async (req, res) => {
    // This is a duplicate of /page/image/crop but its for URLs instead of page names
    const { url, width, height, x, y } = req.query;

    if (!url) {
        return res.status(400).json({
            error: "You must provide a url"
        });
    }

    if (!width) {
        return res.status(400).json({
            error: "You must provide a width"
        });
    }

    if (!height) {
        return res.status(400).json({
            error: "You must provide a height"
        });
    }

    if (!x) {
        return res.status(400).json({
            error: "You must provide an x"
        });
    }

    if (!y) {
        return res.status(400).json({
            error: "You must provide a y"
        });
    }

    try {
        const imageStream = await getCroppedImage({
            url: url as string,
            downloadSize: {
                width: parseInt(req.query.downloadWidth as string) || 128,
                height: parseInt(req.query.downloadHeight as string) || 100
            },
            width: parseInt(width as string),
            height: parseInt(height as string),
            x: parseInt(x as string),
            y: parseInt(y as string)
        });

        const shouldStream = req.query.stream == "true" || req.query.stream == "1";
        if (shouldStream) {
            res.setHeader("Content-Type", "image/png");
            res.setHeader("Content-Length", fs.statSync(imageStream.path).size);
            imageStream.stream.pipe(res);
        } else {
            res.json({
                type: "image",
                image: ConvertToLuaReadable(imageStream.path)
            });
        }
    } catch (error: any) {
        res.status(500).json({
            error: error.message || error
        });
    }
});

router.get("/image", async (req, res) => {
    const { url } = req.query;

    if (!url) {
        return res.status(400).json({
            error: "You must provide a url"
        });
    }

    const size = {
        width: parseInt(req.query.width as string) || 128,
        height: parseInt(req.query.height as string) || 72
    }

    try {
        const imageStream = await downloadImage(url as string, size);

        const shouldStream = req.query.stream == "true" || req.query.stream == "1";
        if (shouldStream) {
            res.setHeader("Content-Type", "image/png");
            res.setHeader("Content-Length", fs.statSync(imageStream.path).size);
            imageStream.stream.pipe(res);
        } else {
            res.setHeader("Content-Type", "image/ppm");
            // res.setHeader("Content-Length", fs.statSync(imageStream.path).size);
            res.send(ConvertToLuaReadable(imageStream.path));
            // res.json({
            //     type: "image",
            //     image: ConvertToLuaReadable(imageStream.path)
            // });
        }
    } catch (error: any) {
        console.log(error);
        res.status(500).json({
            error: error.message || error
        });
    }
});

router.get("/page/random", async (req, res) => {
    const randomPage = await wiki.random();
    if (randomPage.length == 0) {
        return res.status(500).json({
            error: "No random page found"
        });
    }

    const page = await wiki.page(randomPage[0]);

    res.json({
        type: "random",
        page: page
    });
});

router.get("/source", (req, res) => {
    res.json({
        type: "source",
        source: process.env.SOURCE || "No source provided",
    });
});

router.get("/page/front", async (req, res) => {
    // WikiJS does not have a front page function, so we have to do it manually
    // by calling /feed/featured/yyyy/mm/dd

    let { year, month, day } = req.query;

    if (!year) {
        return res.status(400).json({
            error: "You must provide a year"
        });
    }

    if (!month) {
        return res.status(400).json({
            error: "You must provide a month"
        });
    }

    if (!day) {
        return res.status(400).json({
            error: "You must provide a day"
        });
    }
    // The date needs to be 0-padded
    if (parseInt(month as string) < 10) {
        month = `0${month}`
    }

    if (parseInt(day as string) < 10) {
        day = `0${day}`
    }

    // We have to use fetch because WikiJS does not have a feed function
    try {
        const response = await fetch(`https://en.wikipedia.org/api/rest_v1/feed/featured/${year}/${month}/${day}`, {
            headers: {
                'User-Agent': process.env.USER_AGENT || "WikiJS Bot v1.0"
            }
        });
        const data = await response.json();

        res.json({
            type: "front",
            page: data
        });
    } catch (error: any) {
        res.status(500).json({
            error: error.message || error
        });
    }
});

export default router;