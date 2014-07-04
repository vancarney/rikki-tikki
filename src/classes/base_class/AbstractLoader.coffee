{_}           = require 'underscore'
fs            = require 'fs'
path          = require 'path'
{EventEmitter}  = require 'events'
RikkiTikkiAPI = module.parent.exports.RikkiTikkiAPI || module.parent.exports
module.exports.RikkiTikkiAPI = RikkiTikkiAPI
Util          = RikkiTikkiAPI.Util
class AbstractLoader extends EventEmitter
  __data:null
  constructor:(@__path)->
    _super =  arguments.callee.caller.__super__
    if typeof _super == 'undefined' or RikkiTikkiAPI.Util.Function.getFunctionName _super.constructor != 'AbstractLoader'
      return throw "AbstractAdapter can not be directly instatiated\nhint: use a subclass instead."
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
            callback? 'data was not JSON string', null
          callback? e, @__data = d
    catch e
      callback? "could not load file '#{@__path}\n#{e}", null
  get:(attr)-> 
    @__data[attr]
  set:(attr, value)->
    @__data[attr] = value
  save:(callback)->
    if @__path? 
      Util.File.writeFile @__path, @toString(true), null, callback
    else
      callback? "path was not defined"
  rename:(newPath, callback)->
    if @__path? and @pathExists @__path
      fs.rename @__path, newPath, (e,s)=>
        @__path = newPath
        callback? e,s
    else
      callback? "file '#{@__path}' does not exist", null
  destroy:(callback)->
    if @__path? and @pathExists @__path
      fs.unlink @__path, (e,s) =>
        callback?.apply @, arguments
    else
      callback? "file '#{@__path}' does not exist"
  create:(@__path, data, callback)->
    if typeof data == 'function'
      callback = data
      data = null
    if @__path? and !@pathExists @__path
      @save callback
    else
      throw "file '#{@__path}' already exists"
  replacer:null
  valueOf:-> 
    @__data
  toJSON:->
    JSON.parse @toString()
  toString:(readable=false)->
    return @__data if typeof @__data == 'string'
    JSON.stringify @__data, @replacer, if readable then 2 else undefined
module.exports = AbstractLoader