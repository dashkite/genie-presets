import FS from "fs/promises"
import sort from "sort-package-json"
import * as _ from "@dashkite/joy"

cache = {}

read = (path) -> cache[path] ?= JSON.parse await FS.readFile path, "utf8"

write = (path, updated) ->
  if _.endsWth "package.json", path
    updated = sort updated
  unless _.equal cache[path], updated
    FS.writeFile path, JSON.stringify updated, null, 2

json = { read, write }

export { json }
