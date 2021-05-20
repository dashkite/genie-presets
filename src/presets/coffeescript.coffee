import Path from "path"
import * as _ from "@dashkite/joy"
import * as m from "@dashkite/masonry"
import {coffee} from "@dashkite/masonry/coffee"
import { yaml } from "#helpers"

targets =

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

mktargets = _.tee (cfg) ->
  cfg.presets ?= {}
  cfg.presets.coffeescript ?= {}
  cfg.presets.coffeescript.targets ?= []

export default (t, options) ->

  t.define "coffeescript:target:add", (name) ->
    cfg = await yaml.read "genie.yaml"
    if !(name in (mktargets cfg).presets.coffeescript.targets)
      cfg.presets.coffeescript.targets.push name
      yaml.write "genie.yaml", cfg

  t.define "coffeescript:target:remove", (name) ->
    cfg = await yaml.read "genie.yaml"
    if (name in (mktargets cfg).presets.coffeescript.targets)
      _.remove name, cfg.presets.coffeescript.targets
      yaml.write "genie.yaml", cfg

  t.define "clean", m.rm "build"

  if !options?.targets?
    console.warn "genie-presets: coffeescript: no targets defined"
  else
    fx = (targets[target] for target in options.targets)

    t.define "build", "clean", m.start [
      m.glob [ "{src,test}/**/*.coffee" ], "."
      m.read
      fx...
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
