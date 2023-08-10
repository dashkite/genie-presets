import assert from "@dashkite/assert"
import {print, test} from "@dashkite/amen"
import * as _ from "@dashkite/joy"
# TODO /index must be explicit
import preset from "../src/index"

do ->

  print await test "Genie Presets", [
    test "builds and exports a function", ->
      assert.equal true, _.isFunction preset
  ]
