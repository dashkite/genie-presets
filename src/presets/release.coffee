import * as _ from "@dashkite/joy"
import * as m from "@dashkite/masonry"

export default (t) ->

  t.define "release:version", ->
    if process.env.version?
      version = _.words process.env.version
      m.exec "npm", [ "version", version... ]
    else
      console.error "release:",
        "please specify the version environment variable."
      process.exit 1

  t.define "release:publish", ->
    m.exec "npm", [ "publish", "--access", "public" ]

  t.define "release:push", ->
    m.exec "git", [ "push", "--follow-tags" ]

  t.define "release",
    [
      "test"
      "release:version"
      "release:publish"
      "release:push"
    ]
