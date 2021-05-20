import Path from "path"
import FS from "fs/promises"
import YAML from "js-yaml"
import * as _ from "@dashkite/joy"
import * as m from "@dashkite/masonry"
import { json, yaml, lines } from "#helpers"

export default (t) ->

  t.define "retype:configure", ->

    if key = process.env.RETYPE_LICENSE_KEY?

      console.error "Reading package.json ..."
      {version, bugs} = await json.read "package.json"
      name = Path.basename process.cwd()
      title = _.capitalize name
      link = _.replace /issues$/, "", bugs.url

      console.error "Using: "
      console.error "  name: ", name
      console.error "  title: ", title
      console.error "  version: ", version
      console.error "  github: ", link

      config = await yaml.read "#{__dirname}/config.yaml"
      config.base = name
      config.branding.title = title
      config.branding.label = version
      config.links[0].link = link

      console.error "Writing config to retype.json..."
      await json.write "retype.json", config

      console.error "Writing config with license key to retype.local.json..."
      config.license = process.env.RETYPE_LICENSE_KEY
      await json.write "retype.local.json", config

      console.error "Updating .gitignore file..."
      ignored = new Set await lines.read ".gitignore"
      ignored.add "retype.local.json"
      ignored.add ".retype"
      lines.write ".gitignore", Array.from ignored

      console.error "Setting up GitHub workflow..."
      await FS.mkdir ".github/workflows", recursive: true
      await FS.copyFile "#{__dirname}/github/workflows/retype.yml",
        ".github/workflows/retype.yml"
      console.error "GitHub workflow configured: remember to add
        RETYPE_LICENSE_KEY to your repository secrets."

      console.error "Retype configuration complete"
    else

      console.error "Please specify the RETYPE_LICENSE_KEY environment variable"

  t.define "site:reference:page", ->
    await FS.mkdir "docs/reference", recursive: true
    yaml.write "docs/reference/index.yaml",
      expanded: true
      icon: "book"

  t.define "site:build", [ "docs:build", "site:reference:page" ], ->
    FS.copyFile "./README.md", "docs/index.md"

  t.define "site:watch", ->
    t.run "site:build"
    # TODO add lookup check to genie API
    try t.run "docs:watch"
    do m.exec "retype", [ "watch", "retype.local.json" ]
