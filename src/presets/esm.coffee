import FS from "fs/promises"
import * as _ from "@dashkite/joy"
import { json } from "#helpers"

exemplar =
  "main": "build/node/src/index.js",
  "exports": {
    ".": {
      "import": "./build/import/src/index.js",
      "node": "./build/node/src/index.js"
    },
    "./*": {
      "import": "./build/import/src/*.js",
      "node": "./build/node/src/*.js"
    }
  },
  "files": [
    "build/import/src",
    "build/node/src"
  ]

export default (t) ->

  t.define "esm:dual", ->
    pkg = await json.read "package.json"
    json.write "package.json", _.assign pkg, exemplar
