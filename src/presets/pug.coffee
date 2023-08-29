import Path from "node:path"
import * as _ from "@dashkite/joy"
import * as m from "@dashkite/masonry"
import { pug } from "@dashkite/masonry/pug"
# import { atlas } from "@dashkite/masonry/atlas"
import { yaml } from "#helpers"
import deepMerge from "deepmerge"
import * as cheerio from "cheerio"

addEnvironment = ( env ) ->
  ({input}) ->
    $ = cheerio.load input
    $ "head"
      .append """
        <script>
          window.process = { env: #{JSON.stringify env} }
        </script>
      """
    $.html()

renderDocument = ({glob, target, entries, map, env}) ->
  { atlas } = await import( "@dashkite/masonry/atlas" )
  await _.sleep 1000
  do m.start [
    m.glob glob, "."
    m.read
    m.tr [
      pug.render
      atlas entries, map
      addEnvironment env
    ]
    m.extension ".html"
    m.write "build/#{target}"
  ]

renderFragment = ({glob, target}) ->
  do m.start [
    m.glob glob, "."
    m.read
    m.tr pug.render
    m.extension ".html"
    m.write "build/#{target}"
  ]

compileFragment = ({glob, target}) ->
  do m.start [
    m.glob glob, "."
    m.read
    m.tr pug[ target ].compile
    m.extension ".js"
    m.write "build/#{target}"
  ]

export default (t, _options) ->

  t.define "pug", ->
    # feels like we should be able to flatten this with flow/map
    Promise.all do ->
      for target, builds of _options.targets
        Promise.all do ->
          for { preset, glob, entries, map, document } in builds
            # target = options?.target ? "browser"
            switch preset
              when "render"
                if document == true
                  env = ( t.get "sky" )?.env ? {}
                  renderDocument { glob, target, entries, map, env }
                else
                  renderFragment { glob, target }
              when "compile"
                compileFragment { glob, target }

  t.after "build", "pug"

  t.define "pug:setup", ->
  
    cfg = await yaml.read "genie.yaml"

    cfg = deepMerge cfg,
      presets:
        server:
          logging: false
          fallback: "./build/browser/src/index.html"
        pug:
          targets:
            app: [
              preset: "render"
              glob: "src/index.pug"
              document: true
            ,
              preset: "compile"
              glob: [
                "src/**/*.pug"
                "!src/index.pug"
              ]
            ]

    yaml.write "genie.yaml", cfg
