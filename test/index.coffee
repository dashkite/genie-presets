import assert from "assert"
import {print, test} from "amen"
import * as _ from "@dashkite/joy"
import preset from "../src"

do ->

  print await test "Genie Presets", [
    test "builds and exports a function", ->
      assert.equal true, _.isFunction preset
  ]
