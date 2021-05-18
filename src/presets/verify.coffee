import FS from "fs/promises"
import * as _ from "@dashkite/joy"
import * as m from "@dashkite/masonry"
import { json } from "#helpers"

legacy = [
  "panda-garden"
  "@pandastrike/garden"
  "@panda-parchment"
  "panda-river"
  "panda-builder"
  "panda-9000"
]
export default (t) ->

  t.define "verify:audit", ->
    m.exec "npm", [ "audit" ]

  t.define "verify:dependencies:no-legacy", ->
    {dependencies, devDependencies} = await json.read "package.json"
    result = _.intersection legacy, _.keys {dependencies..., devDependencies...}
    if _.isEmpty result
      console.log "no legacy dependencies found"
    else
      console.log "legacy dependencies found"
      console.log result

  t.define "verify:dependencies:no-local", ->
    {dependencies, devDependencies} = await json.read "package.json"
    for name, description of {dependencies..., devDependencies...}
      if _.startsWith "file:", description
        console.error "local dependency:", name, description

  t.define "verify:dependencies", [
      "verify:dependencies:no-local"
      "verify:dependencies:no-legacy"
    ], ->
      m.exec "ncu", [ "--packageFile", "package.json" ]

  t.define "verify:license", ->
    {license} = await json.read "package.json"
    if !license?
      console.error "No `license` field in package.json"

    if !(await FS.stat "LICENSE.md").isFile()
      console.error "No LICENSE file found"

  t.define "verify", [
    "verify:audit"
    "verify:dependencies"
    "verify:license"
  ]
