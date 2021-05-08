import coffeescript from "./presets/coffeescript"
import release from "./presets/release"
import writeme from "./presets/writeme"
import retype from "./presets/retype"
import esm from "./presets/esm"
import license from "./presets/license"
import verify from "./presets/verify"

presets = {
  coffeescript
  release
  writeme
  retype
  esm
  license
  verify
}

export default (tasks, name) ->
  if name == "*"
    for name, f of presets
      f tasks
  else
    presets[name] tasks
