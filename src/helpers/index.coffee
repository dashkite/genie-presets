export * from "./json"
export * from "./yaml"
export * from "./lines"

ref = (path) ->
  "#{__dirname}/../../../../ref/#{path}"

export { ref }
