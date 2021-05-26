import * as _ from "@dashkite/joy"
import * as m from "@dashkite/masonry"
import { pug } from "@dashkite/masonry/pug"
import { atlas } from "@dashkite/masonry/atlas"

export default (t, options) ->

  t.define "pug", m.start [
    m.glob "{src,test}/**/*.pug", "."
    m.read
    m.tr pug.render
    m.extension ".html"
    m.write "build/node"
  ]

  t.define "pug:with-import-map", m.start [
    m.glob "{src,test}/**/*.pug", "."
    m.read
    m.tr [ pug.render, atlas "." ]
    m.extension ".html"
    m.write "build/node"
  ]
