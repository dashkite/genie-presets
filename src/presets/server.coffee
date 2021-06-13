import Path from "path"
import * as _ from "@dashkite/joy"
import express from "express"
import morgan from "morgan"

defaults =
  port: 0 # pick one
  directory: "build"
  static: {}
  fallback: "build/index.html"

export default (genie, options) ->

  options = _.merge defaults, options

  genie.define "server:site", (port) ->
    app = express()
    app.use morgan "dev"
    app.use express.static options.directory, options.static
    server = app.listen port: port ? options.port
    {port} = server.address()
    console.log "server:site:", "listening on port #{port}"

  genie.define "server:app", (port) ->
    app = express()
    app.use morgan "dev"
    if options.esm?
      app.get "*.js", express.static options.esm.directory,
        { options.esm.static..., redirect: false }
    app.use express.static options.directory, options.static
    app.get /^[^\.]+$/,
      (request, response) -> response.sendFile Path.resolve options.fallback
    server = app.listen port: port ? options.port
    {port} = server.address()
    console.log "server:app:", "listening on port #{port}"
