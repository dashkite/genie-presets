import Path from "path"
import FS from "fs/promises"
import YAML from "js-yaml"
import * as _ from "@dashkite/joy"
import * as m from "@dashkite/masonry"

export default (t) ->

  t.define "retype:configure", ->

    if key = process.env.RETYPE_LICENSE_KEY?

      console.error "Reading package.json ..."
      pkg = JSON.parse await FS.readFile "package.json", "utf8"
      name = Path.basename process.cwd()
      title = _.capitalize name
      version = pkg.version
      link = _.replace /issues$/, "", pkg.bugs.url

      console.error "Using: "
      console.error "  name: ", name
      console.error "  title: ", title
      console.error "  version: ", version
      console.error "  github: ", link

      config = YAML.load await FS.readFile "#{__dirname}/config.yaml", "utf8"
      config.base = name
      config.branding.title = title
      config.branding.label = version
      config.links[0].link = link

      console.error "Writing config to retype.json..."
      await FS.writeFile "retype.json",
        JSON.stringify config, null, 2

      console.error "Writing config with license key to retype.local.json..."
      config.license = process.env.RETYPE_LICENSE_KEY
      await FS.writeFile "retype.local.json",
        JSON.stringify config, null, 2

      console.error "Updating .gitignore file..."
      ignored = _.split "\n", await FS.readFile ".gitignore", "utf8"
      update = false
      if ! ("retype.local.json" in ignored)
        ignored.push "retype.local.json"
        update = true
      if ! (".retype" in ignored)
        ignored.push ".retype"
        update = true
      if update
        await FS.writeFile ".gitignore", _.join "\n", ignored

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
    FS.writeFile "docs/reference/index.yaml",
      YAML.dump
        expanded: true
        icon: "book"

  t.define "site:build", [ "docs:build", "site:reference:page" ], ->
    FS.copyFile "./README.md", "docs/index.md"

  t.define "site:watch", ->
    t.run "site:build"
    # TODO add lookup check to genie API
    try t.run "docs:watch"
    m.exec "retype", [ "watch", "retype.local.json" ]
