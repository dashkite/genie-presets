import Path from "path"
import express from "express"
import files from "express-static"
import morgan from "morgan"
import * as m from "@dashkite/mimic"
import { yaml } from "#helpers"

export default (f) -> ->

  cfg = await yaml.read "genie.yaml"
  options = cfg.presets?.browser ? {}

  app = express()

  if options.logging == true
    app.use morgan "dev"

  app.use express.static options.directory, options.static
  app.get "*",
    (request, response) -> response.sendFile Path.resolve options.fallback
  server = app.listen port: port ? options.port
  {port} = server.address()

  browser = await m.connect()
  await f {server, port, browser}

  await m.disconnect browser
  server.close()
