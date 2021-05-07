import FS from "fs/promises"
import * as _ from "@dashkite/joy"
import * as m from "@dashkite/masonry"
import * as writeme from "@dashkite/writeme"
import YAML from "js-yaml"

isFile = (path) ->
  try
    (await FS.stat path).isFile()
  catch
    false

index = undefined

export default (t) ->

  t.define "docs:clean", ->
    await FS.rm "docs/reference", recursive: true, force: true
    index = YAML.load await FS.readFile "#{__dirname}/index.yaml", "utf8"
    if await isFile "docs/references.yaml"
      Object.assign index,
        YAML.load await FS.readFile "docs/references.yaml", "utf8"

  t.define "docs:index", m.start [
    m.glob [ "**/*.yaml" ], "./specs"
    m.read
    m.tr ({source, input}) ->
      data = YAML.load input
      index[data.name] = "/reference/#{source.directory}/#{source.name}.md"
  ]

  t.define "docs:build", [ "docs:clean", "docs:index" ], m.start [
    m.glob [ "**/*.yaml" ], "./specs"
    m.read
    _.flow [
      m.tr ({input}) -> writeme.compile (YAML.load input), index
      m.extension ".md"
      m.write "docs/reference"
    ]
  ]

  t.define "docs:watch", ->
    m.watch "specs", -> t.run "docs:build"
