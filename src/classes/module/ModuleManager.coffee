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
      @emit 'modules-loaded'
  load:(callback)->
    throw 'callback required' unless callback and typeof callback is 'function'
    pkg_path = "#{process.cwd()}#{path.sep}package.json"
    fs.exists pkg_path, (e,ok)=>
      return callback null, false unless ok
      return callback 'unable to obtain package' unless (pkg = require pkg_path) and pkg.hasOwnProperty 'dependencies'
      
      modules = _.compact _.uniq _.map _.keys( pkg.dependencies ), (npm)=>
        if (m = npm.match /^apihero+\-+module+\-([a-z0-9\-_])$/)? then m[1] else null
      done = _.after modules.length, => callback null, true
      _.each modules, (module)=>
        try
          module = require "#{m[1]}"
        catch e
          callback "unable to load module #{module}"
        return callback 'module malformed. Is exports defined?' unless module is {}
        return callback 'module malformed. Is exports.init defined?' unless typeof module.init is 'function'
        try
          module.init @app
        catch e
          return callback e
        done()
module.exports = ModuleManager