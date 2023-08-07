import express from "express";
import WikiJS from "wikijs";
import fs from "fs";
import gm from "gm";
import dotenv from "dotenv";
dotenv.config();

gm.subClass({
    appPath: String.raw`C:\Program Files\GraphicsMagick-1.3.40-Q16\gm.exe`
})

import get from "./Routes/get";
import { appendToLog } from "./usage";

console.log("Clearing cache...")
if (!fs.existsSync("./cache")) {
    fs.mkdirSync("./cache");
} else {
    fs.rmSync("./cache", {
        recursive: true
    });
    fs.mkdirSync("./cache");
}

console.log("Cache cleared!")

const clients = new Map<string, number>();

const wiki = WikiJS({
    apiUrl: process.env.WIKI_API_URL || "https://en.wikipedia.org/w/api.php",
    headers: {
        'User-Agent': process.env.USER_AGENT || "WikiJS Bot v1.0"
    }
})

const app = express();
const port = process.env.PORT || 7000;

app.listen(port, () => {
    console.log(`Server running on port ${port}`);
    appendToLog(`Server running on port ${port}`, "Server");
});

app.use(express.json());
app.disable("x-powered-by");
app.use(express.urlencoded({
    extended: true
}));
app.use((req: express.Request, res: express.Response, next: express.NextFunction) => {
    console.log(`${req.method} ${req.url} ${req.headers["user-agent"]}`);
    console.log(req.query)
    appendToLog(`${req.method} ${req.url} ${req.headers["user-agent"]}\n${req.query}`, "Request");
    next();
});

app.use(get)

setInterval(() => {
    for (const [id, uses] of clients) {
        if (uses <= 0) {
            console.log(`Client ${id} has timed out`)
            appendToLog(`Client ${id} has timed out`, "Client");
            clients.delete(id);
        } else {
            clients.set(id, uses - 1);
        }
    }
}, 1000);

// Client logging every 5 minutes
setInterval(() => {
    appendToLog(`There are ${clients.size} clients connected`);
}, 1000 * 60 * 5)

process.on("uncaughtException", (err) => {
    console.error(err);
    appendToLog(err.message, "Error");
});

process.on("unhandledRejection", (err: Error) => {
    console.error(err);
    appendToLog(err.message, "Error");
});

export {
    wiki,
    app,
    gm,
    clients
}