import coffeescript from "./presets/coffeescript"
import release from "./presets/release"
import writeme from "./presets/writeme"
import retype from "./presets/retype"
import esm from "./presets/esm"
import license from "./presets/license"
import verify from "./presets/verify"
import server from "./presets/server"
import _presets from "./presets/presets"

presets = {
  coffeescript
  release
  writeme
  retype
  esm
  license
  verify
  server
}

export default (tasks, name, options) ->
  _presets tasks
  if name?
    presets[name] tasks, options
  else
    if (tasks.get "presets")?
      for name, options of tasks.get "presets"
        presets[name]? tasks, options
