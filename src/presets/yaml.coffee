import * as _ from "@dashkite/joy"
import * as m from "@dashkite/masonry"
import { yaml } from "@dashkite/masonry/yaml"
import { text } from "@dashkite/masonry/text"
import { yaml as yamlFile } from "#helpers"
import deepMerge from "deepmerge"

compile =
  json: ({glob, target}) ->
    do m.start [
      m.glob glob, "."
      m.read
      m.tr yaml
      m.extension ".json"
      m.write "build/#{target}"
    ]
  js: ({glob, target}) ->
    do m.start [
      m.glob glob, "."
      m.read
      m.tr [ yaml, text ]
      m.extension ".js"
      m.write "build/#{target}"
    ]

export default (t, options) ->

  t.define "stylus", ->

    for target, builds of options.targets
      for { preset, glob } in builds
        if compile[ preset ]?
          compile[ preset ] { glob, target }
        else
          throw new Error "unknown yaml preset, [#{preset}]"

  t.after "build", "stylus"

  t.define "stylus:setup", ->

    cfg = await yamlFile.read "genie.yaml"

    cfg = deepMerge cfg,
      presets:
        stylus:
          targets:
            browser: [
              preset: "js"
              glob: "src/**/*.yaml"
            ]

    yamlFile.write "genie.yaml", cfg
