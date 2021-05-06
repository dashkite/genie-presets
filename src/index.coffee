import coffeescript from "./presets/coffeescript"
import release from "./presets/release"
import writeme from "./presets/writeme"
import retype from "./presets/retype"

presets = {
  coffeescript
  release
  writeme
  retype
}

export default (tasks, name, options = {}) -> presets[name] tasks, options
