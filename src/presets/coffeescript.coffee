import Path from "path"
import * as _ from "@dashkite/joy"
import * as m from "@dashkite/masonry"
import {coffee} from "@dashkite/masonry/coffee"
import { yaml } from "#helpers"
import deepMerge from "deepmerge"

defaults =
  import:
    presets:
      coffeescript:
        targets:
          import: [
              preset: "import"
              glob: [ "src/**/*.coffee" ]
            ,
              preset: "import"
              glob: [ "test/client/**/*.coffee" ]
              options: mode: "debug"
            ,
              preset: "node"
              glob: [ "test/**/*.coffee", "!test/client/**/*.coffee" ]
          ]
  node:
    presets:
      coffeescript:
        targets:
          node: [
            preset: "node"
            glob: [ "{src,test}/**/*.coffee" ]
          ]


builders =

  node: _.flow [
    m.tr coffee target: "node"
    m.extension ".js"
    m.write "build/node"
  ]
  import: _.flow [
    m.tr coffee target: "import"
    m.extension ".js"
    m.write "build/import"
  ]

export default (t, options) ->

  t.define "coffeescript:targets:add", (name) ->
    cfg = await yaml.read "genie.yaml"
    cfg = deepMerge cfg, defaults[name]
    yaml.write "genie.yaml", cfg

  t.define "coffeescript:targets:remove", (name) ->
    cfg = await yaml.read "genie.yaml"
    if cfg.presets?.coffeescript?.targets?[name]?
      delete cfg.presets.coffeescript.targets[name]
      yaml.write "genie.yaml", cfg

  t.define "clean", m.rm "build"

  t.define "build", "clean", ->
    for target, builds of options.targets
      for { preset, glob, options } in builds
        await do m.start [
          m.glob glob, "."
          m.read
          m.tr coffee { target: preset, options... }
          m.extension ".js"
          m.write "build/#{preset}"
        ]

  t.define "dev:test", ->
    require Path.join process.cwd(), "test"

  t.define "test", "build", m.exec "node", [
    "--enable-source-maps"
    "./build/node/test/index.js"
  ]

  t.define "src:watch", m.watch "src", -> t.run "build"

  t.define "test:watch", m.watch "test", -> t.run "build"

  t.define "watch", [ "build", "src:watch&", "test:watch&" ]
