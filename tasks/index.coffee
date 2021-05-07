import "coffeescript/register"
import * as t from "@dashkite/genie"
import preset from "../src"

t.define "build", ->
preset t, "release"
