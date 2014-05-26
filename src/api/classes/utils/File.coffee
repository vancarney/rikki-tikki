fs    = require 'fs'
path  = require 'path'
File  = {}
File.name = (_path)->
  (path.basename _path).split('.').shift()
File.writeFile = (path, data, options, callback)->
  if typeof options == 'function'
    calback = options
    options = encoding:'utf-8'
  fs.writeFile path, "#{data}", options, (e)=> 
    console.error "Failed to write file '#{path}'\nError: #{e}" if e
    callback? e
File.readFile = (path, options, callback)->
  if typeof options == 'function'
    calback = options
    options = encoding:'utf-8'
  fs.readFile path, options, (e)=> 
    console.error "Failed to read file '#{path}'\nError: #{e}" if e
    callback? e
module.exports = File