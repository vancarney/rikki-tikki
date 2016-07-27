{_} = require 'lodash'
fs = require 'fs'
path = require 'path'
{EventEmitter} = require 'events'
class ModuleManager extends EventEmitter
  __modules:{}
  constructor:(@app, @options={})->
    @app.ApiHero.proxyEvent 'ahero-modules-loaded', @
  listModules:->
    _.keys @__modules
  getModule: (name)->
    if @__modules.hasOwnProperty name then @__modules[name] else null
  saveModules:(callback)->
    package_path = path.join "#{app_root}", 'package.json'
    try
      pkg = require package_path
    catch e
      return callback e
    config = if pkg.hasOwnProperty 'apihero' then pkg.apihero else apihero: modules: {}
    config = if config.hasOwnProperty 'modules' then pkg.apihero.modules else apihero: modules: {}
    _.each (_.difference @listModules(), _.keys config), (name)=>
      console.log "getting: #{name}"
      mod = {}
      mod[name] = @getModuleOptions name
      _.extend pkg, apihero: modules: mod
    fs.writeFile package_path, (JSON.stringify pkg, null, 2), callback
  getModuleOptions:(name)->
    if @options.modules.hasOwnProperty name then @options.modules[name] else null
  load:(callback)->
    throw 'callback required' unless callback and typeof callback is 'function'
    @__modules = {}
    try
      pkg = require path.join app_root || process.cwd(), 'package.json'
    catch e
      return callback e
    return callback 'unable to obtain package' unless pkg?.hasOwnProperty 'dependencies'
    _modules = _.compact _.uniq _.map _.keys( pkg.dependencies ), (name)=>
      if (name.match /^.*\/?apihero\-module\-[a-z0-9\-_]+$/)? then name else null
    return callback null,[] unless _modules.length
    init = _.after _modules.length, =>
      @emit 'ahero-modules-loaded', @app.ApiHero.loadedModules = _modules
    # creates done callback
    done = _.after _modules.length, =>
      args = arguments
      @saveModules =>
        callback.apply @, args 
    # loops on module dependancies
    _.each _modules, (moduleName)=>
      try
        module = require "#{moduleName}"
      catch e
        console.log e
        return done "unable to load module '#{moduleName}'"
      return done "module '#{moduleName}' is malformed. Is exports defined?" if typeof module is {}
      return done "module '#{moduleName}' is malformed. Is exports.init defined?" unless typeof module.init is 'function'
      ((moduleName, module)=>
        try
          module.init @app, @getModuleOptions( moduleName ), (e)=>
            @__modules[moduleName] = module
            delete @__modules[moduleName].init if @__modules[moduleName].init?
            done.apply @, if e? then [e] else [null]
            init()
        catch e
          console.log e
          return done e
      ) moduleName, module
    done() unless _modules.length > 0
module.exports = ModuleManager