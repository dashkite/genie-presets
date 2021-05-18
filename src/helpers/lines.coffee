import FS from "fs/promises"
import sort from "sort-package-json"
import * as _ from "@dashkite/joy"

cache = {}

read = (path) -> cache[path] ?= _.split "\n", await FS.readFile path, "utf8"

write = (path, updated) ->
  unless _.equal cache[path], updated
    FS.writeFile path, _.join "\n", updated

lines = { read, write }

export { lines }
