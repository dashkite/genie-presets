import Path from "path"
import * as _ from "@dashkite/joy"
import * as m from "@dashkite/masonry"
import {coffee} from "@dashkite/masonry/coffee"
import { yaml } from "#helpers"
import deepMerge from "deepmerge"

_builds =
  browser: [
      preset: "browser"
      glob: [ "src/**/*.coffee" ]
    ,
      preset: "browser"
      glob: [ "test/client/**/*.coffee" ]
      options: mode: "debug"
    ,
      preset: "node"
      glob: [ "test/**/*.coffee", "!test/client/**/*.coffee" ]
  ]

  node: [
    preset: "node"
    glob: [ "{src,test}/**/*.coffee" ]
  ]

# backward compatibility
_builds.import = _builds.browser

_defaults =
  browser: presets: coffeescript: targets: browser: _builds.browser
  node: presets: coffeescript: targets: node: _builds.node

export default (t, options) ->

  t.define "coffeescript:targets:add", (name) ->
    if _defaults[name]?
      cfg = await yaml.read "genie.yaml"
      cfg = deepMerge cfg, _defaults[name]
      yaml.write "genie.yaml", cfg
    else
      throw new Error "uknown target: [#{name}]"

  t.define "coffeescript:targets:remove", (name) ->
    cfg = await yaml.read "genie.yaml"
    if cfg.presets?.coffeescript?.targets?[name]?
      delete cfg.presets.coffeescript.targets[name]
      yaml.write "genie.yaml", cfg

  t.define "clean", m.rm "build"

  t.define "build", "clean", ->
    if _.isArray options.targets
      targets = {}
      for target in options.targets
        targets[target] = _builds[target]
    else
      targets = options.targets

    for target, builds of targets
      for { preset, glob, options } in builds
        await do m.start [
          m.glob glob, "."
          m.read
          m.tr coffee[preset] options ? {}
          m.extension ".js"
          m.write "build/#{preset}"
        ]

  t.define "dev:test", ->
    require Path.join process.cwd(), "test"

  t.define "test", "build", m.exec "node", [
    "--enable-source-maps"
    "--trace-warnings"
    "--unhandled-rejections=strict"
    "./build/node/test/index.js"
  ]

  t.define "src:watch", m.watch "src", -> t.run "build"

  t.define "test:watch", m.watch "test", -> t.run "build"

  t.define "watch", [ "build", "src:watch&", "test:watch&" ]
