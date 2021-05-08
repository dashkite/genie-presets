import FS from "fs/promises"
import * as _ from "@dashkite/joy"

export default (t) ->

  t.define "license:ethical", ->
    license = await FS.copyFile "#{__dirname}/ethical.md", "LICENSE.md"
    pkg = JSON.parse await FS.readFile "package.json", "utf8"
    _pkg = _.merge pkg, license: "SEE LICENSE IN LICENSE.md"
    unless _.equal pkg, _pkg
      FS.writeFile "package.json", JSON.stringify _pkg, null, 2
