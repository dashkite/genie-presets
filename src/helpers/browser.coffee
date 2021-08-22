import Path from "path"
import express from "express"
import files from "express-static"
import morgan from "morgan"
import * as m from "@dashkite/mimic"
import { yaml } from "#helpers"

# TODO remove code duplication
# this code is duplicated from the server preset
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

export default (f) -> ->

  cfg = await yaml.read "genie.yaml"
  options = cfg.presets?.browser ? {}

  app = express()

  if options.logging == true
    app.use morgan "dev"

  mountjs app, options.esm
  # mount app, options
  
  app.use express.static (options.directory ? "."), (options.static ? {})

  if options.fallback?
    app.get "*",
      (request, response) -> response.sendFile Path.resolve options.fallback

  server = app.listen port: port ? options.port
  {port} = server.address()

  browser = await m.connect()
  await f {server, port, browser}

  await m.disconnect browser
  server.close()
