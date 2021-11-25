import * as _ from "@dashkite/joy"
import * as m from "@dashkite/masonry"
import { yaml } from "@dashkite/masonry/yaml"
import { json } from "@dashkite/masonry/json"
import { yaml as yamlFile } from "#helpers"
import YAML from "js-yaml"
import deepMerge from "deepmerge"

yamlRequire = ({ input }) ->
  value = YAML.load input
  _json = JSON.stringify value
  "module.exports = #{_json}"

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
    switch target
      when "browser"
        do m.start [
          m.glob glob, "."
          m.read
          m.tr [ yaml, json ]
          m.extension ".js"
          m.write "build/browser"
        ]
      when "node"
        do m.start [
          m.glob glob, "."
          m.read
          m.tr yamlRequire
          m.extension ".js"
          m.write "build/node"
        ]

export default (t, options) ->

  t.define "yaml", ->

    for target, builds of options.targets
      for { preset, glob } in builds
        if compile[ preset ]?
          compile[ preset ] { glob, target }
        else
          throw new Error "unknown yaml preset, [#{preset}]"

  t.after "build", "yaml"

  t.define "yaml:setup", ->

    cfg = await yamlFile.read "genie.yaml"

    cfg = deepMerge cfg,
      presets:
        yaml:
          targets:
            browser: [
              preset: "js"
              glob: "src/**/*.yaml"
            ]

    yamlFile.write "genie.yaml", cfg
