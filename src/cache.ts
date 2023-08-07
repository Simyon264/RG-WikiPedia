import fs from "fs";
import { appendToLog } from "./usage";

const imageCache = new Map<string, string>();

function saveToCache(item: any, path: string, deleteAfter: number = 1000 * 60 * 5) {
    imageCache.set(JSON.stringify(item), path);

    setTimeout(() => {
        imageCache.delete(JSON.stringify(item));
        fs.unlinkSync(path);
        console.log("Deleted image from cache");
        appendToLog("Deleted image from cache", "Cache");
    }, deleteAfter);
}

function getFromCache(item: any) {
    const cachedImage = imageCache.get(JSON.stringify(item));
    if (cachedImage) {
        if (fs.existsSync(cachedImage)) {
            appendToLog("Served image from cache", "Cache");
            return cachedImage;
        } else {
            appendToLog("Invalid cache entry, deleting", "Cache");
            imageCache.delete(JSON.stringify(item));
        }
    }
    return null;
}

export {
    saveToCache,
    getFromCache
}
