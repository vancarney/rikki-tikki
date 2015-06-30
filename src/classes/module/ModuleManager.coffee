{_} = require 'lodash'
fs = require 'fs'
path = require 'path'
{EventEmitter} = require 'events'
class ModuleManager extends EventEmitter
  constructor:(@app)->
    @load (e,ok)=>
      if e?
        console.log e
        process.exit 1
      @emit 'modules-loaded', @__modules
  getModules:->
    @__modules
  saveModules:->
    # no yet imoplements -- should make this work like a singleton manager in base_class
  load:(callback)->
    throw 'callback required' unless callback and typeof callback is 'function'
    try
      pkg = require "#{process.cwd()}#{path.sep}package.json"
    catch e
      return callback e

    return callback 'unable to obtain package' unless pkg?.hasOwnProperty 'dependencies'
    
    @__modules = _.compact _.uniq _.map _.keys( pkg.dependencies ), (name)=>
      if (name.match /^apihero+\-+module+\-[a-z0-9\-_]+$/)? then name else null
    # creates done callback
    done = _.after @__modules.length, => callback.apply @, arguments
    # loops on module dependancies
    _.each @__modules, (m)=>
      try
        module = require "#{m}"
      catch e
        done "unable to load module '#{m}'"
      return done 'module malformed. Is exports defined?' if module is {}
      return done 'module malformed. Is exports.init defined?' unless typeof module.init is 'function'
      try
        module.init @app
      catch e
        return done e
      done null, @__modules
module.exports = ModuleManager