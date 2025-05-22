const fs = require("fs");

const config = JSON.parse(fs.readFileSync("config.json"));

for (const data of config) {
    console.log(`${data.input} -> data/${data.output}`);
    const input = fs.readFileSync(data.input).toString();
    let lines = input.split("\n").slice(data.lines_to_remove);
    lines.unshift(data.header);
    const output = lines.join("\n");

    fs.writeFileSync("data/" + data.output, output);
}
