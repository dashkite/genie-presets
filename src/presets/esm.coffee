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

addIndex = (condition, path) ->
  addExport ".", condition, path

setMain = (path) ->
  pkg = await json.read "package.json"
  pkg.main = "build/node/src/index.js"
  json.write "package.json", pkg

export default (t) ->

  t.define "esm:main", (target) ->
    setMain "build/node/src/index.js"

  t.define "esm:import", ->
    addIndex "import", "./build/import/src/index.js"

  t.define "esm:node", [ "esm:main:node" ], ->
    addIndex "node", "./build/node/src/index.js"

  t.define "esm:import:glob", ->
    addExport "./*.js", "import", "./build/import/src/*.js"

  t.define "esm:node:glob", ->
    addExport "./*.js", "node", "./build/node/src/*.js"

  t.define "esm:dual", [ "esm:import", "esm:node" ]

  t.define "esm:dual:glob", [ "esm:import:glob", "esm:node:glob" ]
