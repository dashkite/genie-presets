import * as _ from "@dashkite/joy"
import * as m from "@dashkite/masonry"
import { yaml } from "@dashkite/masonry/yaml"
import { Files as P } from "@dashkite/genie-files"

export default (t, options) ->

  t.on "build", m.start [
    P.targets options.targets
    m.read
    m.tr yaml
    m.extension ".${ build.preset }"
    m.write "build/${ build.target }"
  ]

  t.define "yaml:setup", ->

    cfg = await yamlFile.read "genie.yaml"

    cfg = deepMerge cfg,
      presets:
        yaml:
          targets:
            browser: [
              preset: "js"
              glob: "src/**/*.yaml"
            ]

    yamlFile.write "genie.yaml", cfg
