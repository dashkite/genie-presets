import FS from "fs/promises"
import * as _ from "@dashkite/joy"
import execa from "execa"
import * as m from "@dashkite/masonry"
import { json } from "#helpers"

export default (t) ->

  t.define "update:dependencies:audit", m.exec "npm audit fix"

  t.define "update:dependencies:ncu",
    m.exec "ncu", [ "-u", "--packageFile", "package.json" ]

  t.define "update:dependencies", [
    "update:dependencies:audit"
    "update:dependencies:ncu"
    "update:dependencies:commit"
  ]
  
  t.define "update:dependencies:commit", ->
    await execa.command "git add package.json package-lock.json"
    await execa "git", [ "commit", "-m", "update dependencies" ]

  t.define "update", [
    "update:dependencies"
  ]
