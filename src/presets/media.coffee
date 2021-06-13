import FS from "fs/promises"
import * as _ from "@dashkite/joy"
import * as m from "@dashkite/masonry"
import svgstore from "svgstore"
import SVGO from "svgo"
import deepMerge from "deepmerge"
import { yaml } from "#helpers"

export default (t, options) ->

  options.glob ?= "{src,test}/**/*.{jpg,gif,png,pdf,ico,svg,webp}"
  options.target ?= "build/browser"

  t.define "media", m.start [
    m.glob options.glob, "."
    m.read
    m.copy options.target
  ]

  t.after "build", "media"

  t.define "media:sprites", ->
    store = svgstore()
    await do m.start [
      m.glob options.sprites.glob, "."
      m.read
      m.transform ({source, input}) ->
        {data} = SVGO.optimize input, multipass: true, path: source.path
        store.add source.name, data
    ]
    FS.writeFile options.sprites.target, store.toString()

  t.define "media:sprites:setup", ->
    cfg = await yaml.read "genie.yaml"

    cfg = deepMerge cfg,
      presets:
        media:
          sprites:
            glob: "src/media/images/sprites/*.svg"
            target: "src/media/images/sprites.svg"

    yaml.write "genie.yaml", cfg
