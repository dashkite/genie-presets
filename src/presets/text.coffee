import * as _ from "@dashkite/joy"
import * as m from "@dashkite/masonry"
import { yaml } from "@dashkite/masonry/yaml"
import { json } from "@dashkite/masonry/json"
import { yaml as yamlFile } from "#helpers"
import deepMerge from "deepmerge"

escape = ( text ) -> text.replaceAll "`", "\`"

text = ({ input }) ->
  """
  var text = `#{escape input}`;
  """

append = ( text ) -> ({ input }) ->
  """
  #{input}

  #{text}
  """

compile =
  
  js: ({glob, target}) ->
    switch target
      when "browser"
        do m.start [
          m.glob glob, "."
          m.read
          m.tr [ text, append "export default text;" ]
          m.extension ".js"
          m.write "build/browser"
        ]
      when "node"
        do m.start [
          m.glob glob, "."
          m.read
          m.tr [ text, append "module.exports = text;" ]
          m.extension ".js"
          m.write "build/node"
        ]

export default (t, options) ->

  t.define "text", ->

    for target, builds of options.targets
      for { preset, glob } in builds
        if compile[ preset ]?
          compile[ preset ] { glob, target }
        else
          throw new Error "unknown text preset, [#{preset}]"

  t.after "build", "text"

  t.define "text:setup", ->

    cfg = await yamlFile.read "genie.yaml"

    cfg = deepMerge cfg,
      presets:
        text:
          targets:
            browser: [
              preset: "js"
              glob: "src/**/*.yaml"
            ]
            node: [
              preset: "js"
              glob: "src/**/*.yaml"
            ]

    yamlFile.write "genie.yaml", cfg
