import * as _ from "@dashkite/joy"
import * as m from "@dashkite/masonry"

export default (t) ->

  t.define "release:version", (version) ->
    [ version, tag ] = _.split "-", version
    switch version
      when "alpha", "beta"
        do m.exec "npm", [ "version", "prerelease", "--preid", version ]
      when "major", "minor", "patch"
        unless tag?
          do m.exec "npm", [ "version", version  ]
        else
          do m.exec "npm", [ "version", "pre#{version}", "--preid", tag ]
      else
        console.error "please specify the version, ex: `release:version:patch`."
        process.exit 1

  t.define "release:publish", m.exec "npm", [ "publish", "--access", "public" ]

  t.define "release:push", m.exec "git", [ "push", "--follow-tags" ]

  t.define "release", "test", (version) ->
    t.run [
      "release:version:#{version}"
      "release:publish"
      "release:push"
    ]
