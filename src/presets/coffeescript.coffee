import Path from "path"
import * as _ from "@dashkite/joy"
import * as m from "@dashkite/masonry"
import {coffee} from "@dashkite/masonry/coffee"

export default (t) ->

  t.define "clean", -> # m.rm "build"

  t.define "build", "clean", m.start [
    m.glob [ "{src,test}/**/*.coffee" ], "."
    m.read
    _.flow [
      m.tr coffee target: "node"
      m.extension ".js"
      m.write "build/node"
    ]
    _.flow [
      m.tr coffee target: "import"
      m.extension ".js"
      m.write "build/import"
    ]
  ]

  t.define "node:test", [ "build" ], ->
    m.exec "node", [
      "--enable-source-maps"
      "./build/node/test/index.js"
    ]

  t.define "test", [ "clean" ], ->
    require Path.join process.cwd(), "test"

  t.define "test:watch", ->
    t.run "build"
    m.watch "test", -> t.run "node:test"

  t.define "watch", ->
    t.run "build"
    m.watch "src", -> t.run "build"
