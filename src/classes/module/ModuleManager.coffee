{_} = require 'lodash'
fs = require 'fs'
path = require 'path'
{EventEmitter} = require 'events'
class ModuleManager extends EventEmitter
  constructor:(@app, @options={})->
    @app.ApiHero.proxyEvent 'ahero-modules-loaded', @
  getModules:->
    @__modules
  saveModules:->
    # no yet imoplements -- should make this work like a singleton manager in base_class
  getModuleOptions:(name)->
    return null unless (opts = @options.moduleOptions)?
    return opts[moduleName] if opts.hasOwnProperty name
    name = name.replace /^apihero\-module\-+/, ''
    if opts.hasOwnProperty name then opts[moduleName] else null
  load:(callback)->
    throw 'callback required' unless callback and typeof callback is 'function'
    try
      pkg = require path.join app_root || process.cwd(), 'package.json'
    catch e
      return callback e

    return callback 'unable to obtain package' unless pkg?.hasOwnProperty 'dependencies'

    @__modules = _.compact _.uniq _.map _.keys( pkg.dependencies ), (name)=>
      if (name.match /^apihero\-module\-[a-z0-9\-_]+$/)? then name else null
    return callback null,[] unless @.__modules.length
    init = _.after @__modules.length, =>
      console.log 'init callback executing'
      @app.ApiHero.loadedModules = @__modules
      @emit 'ahero-modules-loaded', @__modules
    # creates done callback
    done = _.after @__modules.length, => callback.apply @, arguments
    # loops on module dependancies
    _.each @__modules, (moduleName)=>
      # moduleName = path.basename m
      try
        console.log "requiring module #{moduleName}"
        module = require "#{moduleName}"
      catch e
        done "unable to load module '#{moduleName}'"
      return done "module '#{moduleName}' is malformed. Is exports defined?" if module is {}
      return done  "module '#{moduleName}' is malformed. Is exports.init defined?" unless typeof module.init is 'function'
      try
        module.init @app, @getModuleOptions( moduleName ), (e)=>
          console.log 'module init callback'
          done.apply @, if e? then [e] else [null]
      catch e
        return done e
      init()
    done() unless @__modules.length > 0
module.exports = ModuleManager