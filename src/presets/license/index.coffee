import FS from "fs/promises"
import * as _ from "@dashkite/joy"
import { json, ref } from "#helpers"

export default (t) ->

  t.define "license:ethical", ->
    await FS.copyFile (ref "ethical.md"), "LICENSE.md"
    json.write "package.json",
      _.merge (await json.read "package.json"),
        license: "SEE LICENSE IN LICENSE.md"
