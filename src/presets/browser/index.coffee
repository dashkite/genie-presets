import * as _ from "@dashkite/joy"
import Path from "path"
import * as m from "@dashkite/masonry"
import deepMerge from "deepmerge"
import { yaml, ref } from "#helpers"

export default (genie, options) ->

  genie.define "browser:test:setup:stubs", m.exec "cp", [
    "-R"
    ref "browser/test"
    "."
  ]

  genie.define "browser:test:setup:configuration", ->
    cfg = await yaml.read "genie.yaml"
    cfg = deepMerge cfg,
      presets:
        browser:
          logging: false
          fallback: "./build/browser/test/client/index.html"
        pug:
          targets:
            test: [
              preset: "render"
              glob: "test/client/index.pug"
              document: true
              options:
                "import-map":
                  "@dashkite/amen": "latest"
                  "@dashkite/assert": "latest"
            ]
    yaml.write "genie.yaml", cfg

  genie.define "browser:test:setup:install", m.exec "npm", [
    "i"
    "-D"
    "@dashkite/amen@latest"
    "@dashkite/amen-console@latest"
    "@dashkite/assert@latest"
    "@dashkite/mimic@latest"
    "@dashkite/katana@latest"
  ]

  genie.define "browser:test:setup", [
    "browser:test:setup:stubs"
    "browser:test:setup:configuration"
    "browser:test:setup:install"
  ]
