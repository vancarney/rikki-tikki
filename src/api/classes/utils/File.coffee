fs    = require 'fs'
path  = require 'path'
FS  = {}
FS.name = (_path)->
  (path.basename _path).split('.').shift()
FS.writeFile = (_path, data, options, callback)->
  if typeof options == 'function'
    callback  = arguments[1]
    options   = encoding:'utf-8', flag:'w'
  fs.writeFile _path, "#{data}", options, (e)=> 
    console.error "Failed to write file '#{_path}'\nError: #{e}" if e
    callback? e
FS.readFile = (_path, options, callback)->
  if typeof options == 'function'
    callback  = arguments[1]
    options   = encoding:'utf-8', flag:'r'
  fs.readFile "#{_path}", options, (e,data)=>
    console.error "Failed to read file '#{_path}'\nError: #{e}" if e?
    callback? e, data
module.exports = FS