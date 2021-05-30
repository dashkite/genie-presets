import Path from "path"
import express from "express"
import files from "express-static"
import morgan from "morgan"
import * as m from "@dashkite/mimic"
import { yaml } from "#helpers"

export default (f) -> ->

  app = express()

  cfg = await yaml.read "genie.yaml"
  if cfg.presets?.browser?.logging == true
    app.use morgan "dev"

  server = app
    .get "/", (request, response) ->
      response.sendFile Path.resolve "build/node/test/index.html"
    .use files "."
    .listen()

  {port} = server.address()

  browser = await m.connect()
  await f {server, port, browser}

  await m.disconnect browser
  server.close()
