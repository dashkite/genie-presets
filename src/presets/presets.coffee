import FS from "fs/promises"
import * as _ from "@dashkite/joy"
import * as m from "@dashkite/masonry"
import { yaml } from "#helpers"

export default (t) ->

  t.define "presets:add", (name) ->
    cfg = await yaml.read "genie.yaml"
    if !cfg.presets[name]?
      cfg.presets[name] = null
      yaml.write "genie.yaml", cfg

  t.define "presets:remove", (name) ->
    cfg = await yaml.read "genie.yaml"
    delete cfg.presets[name]
    yaml.write "genie.yaml", cfg
