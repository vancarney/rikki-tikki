{_}           = require 'lodash'
fs            = require 'fs'
path          = require 'path'
Util          = require '../utils'
{EventEmitter}  = require 'events'
class AbstractLoader extends EventEmitter
  # @__data:{}
  replacer:null
  constructor:(@__path)->
    if 'AbstractLoader' is Util.Function.getConstructorName @ 
      throw 'AbstractAdapter can not be directly instatiated\nhint: use a subclass instead.'
    if @__path?
      @load (e,s)=>
        # wraps emit in 3ms timeout to allow constructor to return first
        setTimeout (=>
          # emits either a success or error triggered by e being not null
          @emit.apply @, if e? then ['error', e] else ['success', s]
        ), 3
  pathExists: (_path)->
    if _path?.match /\.(json|js)+$/ then fs.existsSync _path else false
  load:(_path, callback)->
    if typeof _path == 'function'
      callback = arguments[0]
      _path = undefined
    else if _path?
      @__path = _path
    return callback? 'No load path defined' if !@__path
    if !(@pathExists @__path)
      callback? "path '#{@__path}' does not exist or is of incorrect type"
      return 
    try
      if @__path.match /\.js+$/
        @__data = require @__path.replace /\.js$/, ''
        callback? null, @__data
      else
        Util.File.readFile @__path, (e, data) =>
          return callback? e, null if e?
          try
            d = JSON.parse data
          catch e
            return callback? 'data was not JSON string', null
          callback? e, @__data = d
    catch e
      callback? "could not load file '#{@__path}\n#{e}", null
  get:(attr)-> 
    @__data[attr]
  set:(attr, value)->
    @__data[attr] = value
  save:(callback)->
    return callback? "path was not defined" unless @__path?
    Util.File.writeFile @__path, @toString(true), null, callback
  rename:(newPath, callback)->
    if @__path? and @pathExists @__path
      fs.rename @__path, newPath, (e,s)=>
        @__path = newPath
        callback? e, s
    else
      callback? "file '#{@__path}' does not exist", null
  destroy:(callback)->
    if @__path? and @pathExists @__path
      fs.unlink @__path, (e,s) =>
        callback?.apply @, arguments
    else
      callback? "file '#{@__path}' does not exist"
  create:(@__path, data=null, callback)->
    if typeof data is 'function'
      callback = arguments[1]
      data = null
    @__data = if typeof data is 'string' then JSON.parse data else (if data? then data else {})
    return callback? "file '#{@__path}' already exists", null unless @__path? and !@pathExists @__path
    @save callback
  valueOf:-> 
    @__data
  toJSON:->
    JSON.parse @toString()
  toString:(readable=false)->
    return @__data if typeof @__data is 'string'
    JSON.stringify @__data, @replacer, if readable then 2 else undefined
module.exports = AbstractLoader