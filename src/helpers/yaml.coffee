import FS from "node:fs/promises"
import Path from "node:path"
import * as _ from "@dashkite/joy"
import YAML from "js-yaml"

cache = {}

read = (path) ->
  _.clone cache[path] ?= await do ->
    try
      YAML.load await FS.readFile path, "utf8"
    catch
      {}


write = (path, updated) ->
  unless _.equal cache[path], updated
    cache[path] = updated
    await FS.mkdir ( Path.dirname path ), recursive: true
    FS.writeFile path, YAML.dump updated

yaml = { read, write }

export { yaml }
