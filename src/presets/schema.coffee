import * as M from "@dashkite/masonry"
import YAML from "js-yaml"
import Ajv from "ajv/dist/2020"

export default (t, { glob, auto }) ->

  ajv = new Ajv allowUnionTypes: true

  t.define "schema:validate", M.start [
    M.glob glob, "."
    M.read
    M.tr ({ input }) -> ajv.compile YAML.load input
  ]

  if !auto? || auto
    t.before "build", "schema:validate"


