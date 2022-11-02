import * as M from "@dashkite/masonry"
import fetch from "node-fetch"

export default (t, { source, target }) ->

  t.define "docs:diagrams:generate", M.start [
    M.glob "*", source
    M.read
    M.tr ({ source, input }) ->
      type = source.extension[1..]
      response = await fetch "https://kroki.io/#{type}/svg",
        method: "post"
        body: input
      response.text()
    M.extension ".svg"
    M.write target
  ]

