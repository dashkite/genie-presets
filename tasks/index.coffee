import "coffeescript/register"
import * as t from "@dashkite/genie"
import preset from "../src"

preset t, "*"

t.define "build", ->
