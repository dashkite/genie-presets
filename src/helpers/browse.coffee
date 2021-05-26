import Path from "path"
import express from "express"
import files from "express-static"
import * as m from "@dashkite/mimic"

export default (f) -> ->

  server = express()
    .get "/", (request, response) ->
      response.sendFile Path.resolve "build/node/test/index.html"
    .use files "."
    .listen()

  {port} = server.address()

  browser = await m.connect()
  await f {server, port, browser}

  await m.disconnect browser
  server.close()
