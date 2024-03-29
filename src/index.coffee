import coffeescript from "./presets/coffeescript"
import release from "./presets/release"
import writeme from "./presets/writeme"
import retype from "./presets/retype"
import esm from "./presets/esm"
import license from "./presets/license"
import verify from "./presets/verify"
import update from "./presets/update"
import server from "./presets/server"
import browser from "./presets/browser"
import text from "./presets/text"
import pug from "./presets/pug"
import stylus from "./presets/stylus"
import media from "./presets/media"
import _presets from "./presets/presets"
import yaml from "./presets/yaml"
import schema from "./presets/schema"
import kroki from "./presets/kroki"

presets = {
  coffeescript
  release
  writeme
  retype
  esm
  license
  verify
  update
  server
  browser
  text
  pug
  stylus
  media
  yaml
  schema
  kroki
}

export default (tasks, name, options) ->
  _presets tasks
  if name?
    presets[name] tasks, options
  else
    if (tasks.get "presets")?
      for name, options of tasks.get "presets"
        presets[name]? tasks, options
