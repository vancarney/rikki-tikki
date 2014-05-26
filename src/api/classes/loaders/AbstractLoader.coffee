{_}           = require 'underscore'
fs            = require 'fs'
path          = require 'path'
RikkiTikkiAPI = module.parent.exports
Util          = RikkiTikkiAPI.Util
class AbstractLoader extends Object
  __data:null
  constructor:(@__path)->
    @load() if @__path?
  pathExists: (_path)->
    if _path?.match /\.(json|js)+$/ then fs.existsSync _path else false
  load:(callback)->
    throw "No load path defined" if !@__path
    throw "path '#{@__path}' does not exist" if !@pathExists @__path
    try
      @__data = require @__path
    catch e
      console.error "could load file '#{@__path}"
    callback? e || null, @__data
  set:(data)->
    @__data = data
  save:(callback)->
    if @__path? 
      fs.writeFile @__path, "#{@toString true}", (e)=> 
        console.error "Failed to save file #{#{RikkiTikkiAPI.SCHEMA_PATH}/#{name}.js}'\nError: #{e}" if e
        callback? e || null
    else
      callback? "path was not defined"
  destroy:(callback)->
    if @__path? and @pathExists @__path
      fs.unlink @__path, (e) => callback? e
    else
      callback? "file '#{name}' does not exist"
  create:(@__path, data, callback)->
    if typeof data == 'function'
      callback = data
      data = null
    if @__path? and !@pathExists @__path
      @save callback
    else
      throw "file '#{name}' already exists"
  replacer:null
  toJSON:->
    JSON.parse @toString()
  toString:(readable)->
    JSON.stringify @__data, @replacer, if readable then 2 else undefined
module.exports = AbstractLoader