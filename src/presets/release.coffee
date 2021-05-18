import * as _ from "@dashkite/joy"
import * as m from "@dashkite/masonry"

export default (t) ->

  t.define "release:version", (version, prerelease) ->
    if version?
      if prerelease?
        m.exec "npm", [ "version", "pre#{version}", "--preid", prerelease  ]
      else
        m.exec "npm", [ "version", version  ]
    else
      console.error "release:",
        "please specify the version, ex: `release:version:patch`."
      process.exit 1

  t.define "release:publish", ->
    m.exec "npm", [ "publish", "--access", "public" ]

  t.define "release:push", ->
    m.exec "git", [ "push", "--follow-tags" ]

  t.define "release", "test", (version, prerelease) ->
    t.run [
      if version?
        if prerelease?
          "release:version:#{version}:#{prerelease}"
        else
          "release:version:#{version}"
      else
        "release:version"
      "release:publish"
      "release:push"
    ]
