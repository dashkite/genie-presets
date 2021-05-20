import execa from "execa"
import * as _ from "@dashkite/joy"

isClean = ->
  try
    await execa.command "git diff-index --quiet HEAD"
    true
  catch
    console.error "working directory has changes"
    false
