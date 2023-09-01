import * as m from "@dashkite/masonry"
import { Files as P } from "@dashkite/genie-files"
import { pug } from "@dashkite/masonry/pug"


export default ( t, options ) ->

  t.on "build", "pug"
  
  t.define "pug", m.start [
    P.targets options.targets
    m.read
    m.tr pug
    m.extension ".${ build.preset }"
    m.write "build/${ build.target }"
  ]
