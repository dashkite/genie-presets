import coffeescript from "./presets/coffeescript"
import writeme from "./presets/writeme"
import retype from "./presets/retype"

presets = {
  coffeescript
  writeme
  retype
}

export default (tasks, name, options = {}) -> presets[name] tasks, options
