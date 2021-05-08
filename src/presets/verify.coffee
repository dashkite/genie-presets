import FS from "fs/promises"
import * as _ from "@dashkite/joy"
import * as m from "@dashkite/masonry"

export default (t) ->

  t.define "verify:audit", ->
    m.exec "npm", [ "audit" ]

  t.define "verify:dependencies", ->
    m.exec "ncu", [ "--packageFile", "package.json" ]

  t.define "verify:license", ->
    pkg = JSON.parse await FS.readFile "package.json", "utf8"
    if !pkg.license
      console.error "No `license` field in package.json"
    license = await FS.stat "LICENSE.md"
    if !license.isFile()
      console.error "No LICENSE file found"

  t.define "verify", [ "verify:audit", "verify:dependencies", "verify:license" ]
