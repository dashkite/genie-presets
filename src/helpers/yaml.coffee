import FS from "fs/promises"
import * as _ from "@dashkite/joy"
import YAML from "js-yaml"

cache = {}

read = (path) ->
  _.clone cache[path] ?= YAML.load await FS.readFile path, "utf8"


write = (path, updated) ->
  unless _.equal cache[path], updated
    cache[path] = updated
    FS.writeFile path, YAML.dump updated

yaml = { read, write }

export { yaml }
