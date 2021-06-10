import * as _ from "@dashkite/joy"
import * as m from "@dashkite/masonry"
import { stylus } from "@dashkite/masonry/stylus"
import { text } from "@dashkite/masonry/text"
import { yaml } from "#helpers"
import deepMerge from "deepmerge"

compile =
  css: ({glob, target}) ->
    do m.start [
      m.glob glob, "."
      m.read
      m.tr stylus
      m.extension ".css"
      m.write "build/#{target}"
    ]
  js: ({glob, target}) ->
    do m.start [
      m.glob glob, "."
      m.read
      m.tr [ stylus, text ]
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
          throw new Error "unknown stylus preset, [#{preset}]"

  t.after "build", "stylus"

  t.define "stylus:setup", ->

    cfg = await yaml.read "genie.yaml"

    cfg = deepMerge cfg,
      presets:
        stylus:
          targets:
            browser: [
              preset: "css"
              glob: "src/index.styl"
            ,
              preset: "js"
              glob: [
                "src/**/*.styl"
                "!src/index.styl"
              ]
            ]

    yaml.write "genie.yaml", cfg
