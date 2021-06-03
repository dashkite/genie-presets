import Path from "path"
import * as _ from "@dashkite/joy"
import { json } from "#helpers"

addExport = (glob, condition, path) ->
  pkg = await json.read "package.json"
  pkg.exports ?= {}
  pkg.exports[ glob ] ?= {}
  pkg.exports[ glob ][ condition ] ?= path
  pkg.files ?= []
  unless (Path.dirname path) in pkg.files
    # we have to skip the ./ b/c that confuses npm
    pkg.files.push Path.dirname path[2..]
  json.write "package.json", pkg

set = (key, path) ->
  pkg = await json.read "package.json"
  pkg[key] = path
  json.write "package.json", pkg

export default (t) ->

  t.define "esm:set", (key, target) ->
    set key, "build/#{target}/src/index.js"

  t.define "esm:index", (condition) ->
    addExport ".", condition, "./build/#{condition}/src/index.js"

  t.define "esm:glob", (condition) ->
    addExport ".*", condition, "./build/#{condition}/src/*.js"

  t.define "esm:reset", (condition) ->
    pkg = await json.read "package.json"
    delete pkg.main
    delete pkg.module
    delete pkg.browser
    delete pkg["main:coffee"]
    delete pkg.exports
    delete pkg.files
    json.write "package.json", pkg

  t.after "esm:index:node", "esm:set:main:node"
