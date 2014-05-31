fs    = require 'fs'
path  = require 'path'
File  = {}
File.name = (_path)->
  (path.basename _path).split('.').shift()
File.writeFile = (path, data, options, callback)->
  if typeof options == 'function'
    callback  = arguments[1]
    options   = encoding:'utf-8', flag:'r'
  fs.writeFile path, "#{data}", options, (e)=> 
    console.error "Failed to write file '#{path}'\nError: #{e}" if e
    callback? e
File.readFile = (path, options, callback)->
  if typeof options == 'function'
    callback  = arguments[1]
    options   = encoding:'utf-8', flag:'r'
  fs.readFile path, options, (e,data)=>
    console.error "Failed to read file '#{path}'\nError: #{e}" if e
    callback? e, data
module.exports = File