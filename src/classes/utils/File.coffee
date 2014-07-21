fs    = require 'fs'
path  = require 'path'
FS  = {}
FS.name = (_path)->
  (path.basename _path).split('.').shift()
FS.writeFile = (_path, data, options, callback)->
  if typeof options == 'function'
    callback  = arguments[2]
    options   = encoding:'utf8', flag:'w'
  fs.writeFile _path, data, options, (e)=> 
    console.error "Failed to write file '#{_path}'\nError: #{e}" if e
    callback? e
FS.readFile = (_path, options, callback)->
  if typeof options == 'function'
    callback  = arguments[1]
    options   = encoding:'utf8', flag:'r'
  fs.readFile "#{_path}", options, (e,data)=>
    console.error "Failed to read file '#{_path}'\nError: #{e}" if e?
    callback? e, data
FS.ensureDirExists = (path)->
  unless fs.existsSync path
    try
      fs.mkdirSync path
    catch e
      console.error """
      required path '#{path}' does not exist and rikki-tikki could not create it for you.
      hint: either create the directory manually change permissions on the parent directory.
      """
      process.exit  1
module.exports = FS