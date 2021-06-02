import Path from "path"
import FS from "fs/promises"
import * as _ from "@dashkite/joy"
import { json } from "#helpers"
import rake from "rake-js"
import chalk from "chalk"


export default (t) ->

  t.define "keywords", ->
    readme = await FS.readFile "README.md", "utf8"
    keywords = rake readme
    pkg = await json.read "package.json"
    pkg.keywords = Array.from _.unique _.cat (pkg.keywords ? []), keywords
    await json.write "package.json", pkg
    console.error "Keywords added to package.json"
    console.error chalk.yellow "Warning: you should probably edit them."
