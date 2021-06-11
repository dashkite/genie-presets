import * as _ from "@dashkite/joy"
import * as m from "@dashkite/masonry"
import svgstore from "svgstore"
import SVGO from "svgo"
import deepMerge from "deepmerge"
import { yaml } from "#helpers"


export default (t, options) ->

  t.define "sprites", ->
    store = svgstore()
    svgo = new SVGO multipass: true
    await do m.start [
      m.glob options.glob, source
      m.read
      m.transform ({source, input}) ->
        {data} = await svgo.optimize input, path: source.path
        store.add source.name, data
    ]
    FS.writeFile options.target, store.toString()

  t.define "sprites:setup", ->
    cfg = await yaml.read "genie.yaml"

    cfg = deepMerge cfg,
      presets:
        sprites:
          glob: "src/media/images/sprites/*.svg"
          target: "src/media/images/sprites.svg"

    yaml.write "genie.yaml", cfg
