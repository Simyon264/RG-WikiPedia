import fs from 'fs';

const filePath = process.env.LOG_FILE || "./usage.log";

function appendToLog(message: string, origin?: string) {
    fs.appendFileSync(filePath, `${new Date().toISOString()} [${origin ? origin : ""}] - ${message}\n`);

    // If the log file is larger than 1MB, delete the first 100 lines
    if (fs.statSync(filePath).size > 1000000) {
        const lines = fs.readFileSync(filePath, "utf-8").split("\n");
        lines.splice(0, 100);
        fs.writeFileSync(filePath, lines.join("\n"));
    }
}

export {
    appendToLog
}