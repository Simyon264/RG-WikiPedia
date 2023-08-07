import fs from "fs";
import { gm } from ".";
import axios from 'axios';
import path from "path";
import { getFromCache, saveToCache } from "./cache";
import { PNG } from "pngjs";

async function downloadImage(url: string, size: {
    width: number,
    height: number
} = {
        width: 128,
        height: 100
    }, skipCache: boolean = false): Promise<{
        stream: fs.ReadStream,
        path: string,
        isCached?: boolean
    }> {
    return new Promise(async (resolve, reject) => {
        if (!fs.existsSync("./cache")) {
            fs.mkdirSync("./cache");
        }

        if (!skipCache) {
            console.log("Checking cache...");
            const cachedImage = getFromCache({
                url: url,
                height: size.height,
                width: size.width
            })
            if (cachedImage) {
                console.log("Using cached image");
                return resolve({
                    stream: fs.createReadStream(cachedImage),
                    path: cachedImage,
                    isCached: true
                });
            }
        }

        const result = await axios({
            url,
            method: 'GET',
            responseType: 'stream'
        });

        const extension = result.headers['content-type'].split("/")[1];
        const filepath = path.resolve(`./cache/${Date.now()}${Math.random().toString(36).substring(2, 15)}${Math.random().toString(36).substring(2, 15)}.${extension}`);

        result.data.pipe(fs.createWriteStream(filepath))
            .on('error', reject)
            .once('close', () => {
                try {
                    gm(fs.createReadStream(filepath)).resize(size.width, size.height).write(filepath + ".png", (err) => {
                        if (err) {
                            reject(err);
                        }

                        saveToCache({
                            url: url,
                            height: size.height,
                            width: size.width,
                        }, filepath + ".png", 1000 * 60 * 20);
                        console.log("Cached image");

                        // Resolve with read stream
                        resolve({
                            path: filepath + ".png",
                            stream: fs.createReadStream(filepath + ".png", {
                                highWaterMark: 1024 * 1024,
                            }),
                            isCached: false
                        });
                    });
                } catch (error) {
                    console.log(error);
                    reject(error);
                }
            });
    });
}

async function getCroppedImage(cropOptions: {
    skipCache?: boolean,
    url: string,
    downloadSize: {
        height: number,
        width: number
    },
    width: number,
    height: number,
    x: number,
    y: number
}): Promise<{
    stream: fs.ReadStream,
    path: string,
    isCached?: boolean
}> {
    return new Promise(async (resolve, reject) => {

        if (cropOptions.width > cropOptions.downloadSize.width || cropOptions.height > cropOptions.downloadSize.height) {
            return reject("Crop size cannot be larger than download size");
        }

        if (cropOptions.x < 0 || cropOptions.y < 0) {
            return reject("Crop position cannot be negative");
        }

        // if (cropOptions.x + cropOptions.width > cropOptions.downloadSize.width || cropOptions.y + cropOptions.height > cropOptions.downloadSize.height) {
        //     return reject("Crop position cannot be larger than download size");
        // }

        if (cropOptions.height == 0 || cropOptions.width == 0) {
            return reject("Crop size cannot be 0");
        }

        const image = await downloadImage(cropOptions.url, {
            height: cropOptions.downloadSize.height,
            width: cropOptions.downloadSize.width
        })

        const cachedImage = getFromCache({
            url: cropOptions.url,
            height: cropOptions.downloadSize.height,
            width: cropOptions.downloadSize.width,
            cropHeight: cropOptions.height,
            cropWidth: cropOptions.width,
            x: cropOptions.x,
            y: cropOptions.y,
        })

        if (cachedImage) {
            console.log("Using cached image");
            return resolve({
                stream: fs.createReadStream(cachedImage),
                path: cachedImage,
                isCached: true
            });
        }

        const filepath = path.resolve(`./cache/${Date.now()}${Math.random().toString(36).substring(2, 15)}${Math.random().toString(36).substring(2, 15)}`);

        try {
            gm(image.stream).crop(cropOptions.width, cropOptions.height, cropOptions.x, cropOptions.y).scale(128, 72).write(filepath + ".png", (err) => {
                if (err) {
                    reject(err);
                }

                saveToCache({
                    url: cropOptions.url,
                    height: cropOptions.downloadSize.height,
                    width: cropOptions.downloadSize.width,
                    cropHeight: cropOptions.height,
                    cropWidth: cropOptions.width,
                    x: cropOptions.x,
                    y: cropOptions.y,
                }, filepath + ".png");
                console.log("Cached image for 5 minutes");

                // Resolve with read stream
                resolve({
                    path: filepath + ".png",
                    stream: fs.createReadStream(filepath + ".png", {
                        highWaterMark: 1024 * 1024,
                    }),
                    isCached: false
                });
            })
        } catch (error) {
            console.log(error);
            reject(error);
        }
    });
}

function ConvertToLuaReadable(imagePath: string, skipCache: boolean = false) {
    // This will convert the png image to a .ppm P3 image.
    // Why? cause I'm too lazy to write a P6 parser and too lazy to write a lua P6 parser.
    // Why too lazy? Cause the limitations of RG make shit hard and:
    // Lua sucks ass. Fuck Lua

    if (!skipCache) {
        const cachedImage = getFromCache({
            path: imagePath,
            format: "lua"
        })

        if (cachedImage) {
            return fs.readFileSync(cachedImage, "utf-8")
        }
    }

    const data = PNG.sync.read(fs.readFileSync(imagePath))

    let lines = `P3\n${data.width} ${data.height}\n255\n`
    for (let y = 0; y < data.height; y++) {
        let row = ""
        for (var x = 0; x < data.width; x++) {
            var idx = (data.width * y + x) << 2;
            const r = data.data[idx]
            const g = data.data[idx + 1]
            const b = data.data[idx + 2]
            const a = data.data[idx + 3]

            row += `${r} ${g} ${b} ${a} `
        }
        lines += `${row}\n`
    }

    if (!skipCache) {
        fs.writeFileSync(imagePath + ".ppm", lines)

        saveToCache({
            path: imagePath,
            format: "lua"
        }, imagePath + ".ppm");
        console.log("Cached image for 5 minutes");
    }
    return lines
}

export {
    downloadImage,
    getCroppedImage,
    ConvertToLuaReadable
}