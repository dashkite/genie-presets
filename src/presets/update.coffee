import FS from "fs/promises"
import * as _ from "@dashkite/joy"
import execa from "execa"
import * as m from "@dashkite/masonry"
import { json } from "#helpers"

export default (t) ->

  t.define "update:dependencies:local", ->
    {dependencies, devDependencies} = await json.read "package.json"
    for name, description of dependencies
      if _.startsWith "file:", description
        await do m.exec "npm", _.words "i #{name}@latest"
    for name, description of devDependencies
      if _.startsWith "file:", description
        await do m.exec "npm", _.words "i -D #{name}@latest"

  t.define "update:dependencies:audit", m.exec "npm", _.words "audit fix"

  t.define "update:dependencies:ncu", ->
    await do m.exec "ncu", _.words "-u --packageFile package.json"
    do m.exec "npm", [ "i" ]

  t.define "update:dependencies", [
    "update:dependencies:local"
    "update:dependencies:audit"
    "update:dependencies:ncu"
    "update:dependencies:commit"
  ]

  t.define "update:dependencies:commit", ->
    await do m.exec "git", _.words "add package.json package-lock.json"
    await do m.exec "git", [ "commit", "-m", "update dependencies" ]

  t.define "update", [
    "update:dependencies"
  ]
