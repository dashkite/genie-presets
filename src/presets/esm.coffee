import FS from "fs/promises"
import * as _ from "@dashkite/joy"

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
    pkg = JSON.parse await FS.readFile "package.json", "utf8"
    _pkg = _.merge pkg, exemplar
    unless _.equal pkg, _pkg
      FS.writeFile "package.json", JSON.stringify _pkg, null, 2
