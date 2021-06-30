import Path from "path"
import * as _ from "@dashkite/joy"
import express from "express"
import morgan from "morgan"

defaults =
  port: 0 # pick one
  directory: "build"
  static: {}
  fallback: "build/index.html"

_directories = (options) ->
  if options.directory?
    [ options.directory ]
  else if options.directories?
    options.directories
  else
    []

mount = (app, options) ->
  for directory in _directories options
    console.log "mounting static directory [#{directory}]"
    app.use express.static directory, options.static

mountjs = (app, options) ->
  for directory in _directories options
    console.log "mounting static JS directory [#{directory}]"
    app.get "*.js", express.static directory,
      { options.static..., redirect: false }

export default (genie, options) ->

  options = _.merge defaults, options

  genie.define "server:site", (port) ->
    app = express()
    app.use morgan "dev"
    mount app, options
    server = app.listen port: port ? options.port, ->
      {port} = server.address()
      console.log "server:site:", "listening on port #{port}"

  genie.define "server:app", (port) ->
    app = express()
    app.use morgan "dev"
    mountjs app, options.esm
    mount app, options
    app.get /^[^\.]+$/,
      (request, response) -> response.sendFile Path.resolve options.fallback
    server = app.listen port: port ? options.port, ->
      {port} = server.address()
      console.log "server:app:", "listening on port #{port}"
