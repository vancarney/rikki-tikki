{_}   = require 'underscore'
path  = require 'path'
Util  = module.parent.exports
class Capabilities extends Object
  __modules: []
  __loaded_modules: []
  constructor:->
    for name in ['mongoose','mongodb'] 
      @__modules.push name if _.map( _.pluck( require.cache, 'filename' ), (p)-> path.dirname(p).split(path.sep).pop()).indexOf( "#{name}" ) > -1
      @__loaded_modules.push name if Util.detectModule name
  detectedModules: ->
    @__modules
  loadedModules: ->
    @__loaded_modules
  mongooseSupported: ->
    0 <= @detectedModules().indexOf( 'mongoose' )
  mongooseLoaded: ->
    0 <= @loadedModules().indexOf 'mongoose'
  nativeSupported: ->
    0 <= @detectedModules().indexOf 'mongodb'
  nativeLoaded: ->
    0 <= @loadedModules().indexOf 'mongodb'
  expressSupported: ->
    0 <= @detectedModules().indexOf 'express'
  expressLoaded: ->
    0 <= @loadedModules().indexOf 'express'
  hapiSupported: ->
    0 <= @detectedModules().indexOf 'hapi'
  hapiLoaded: ->
    0 <= @loadedModules().indexOf 'hapi'
module.exports = new Capabilities
# capabilities = new Capabilities
# exports.detectedModules   = capabilities.detectedModules
# exports.loadedModules     = capabilities.loadedModules
# exports.mongooseSupported = capabilities.mongooseSupported
# exports.mongooseLoaded    = capabilities.mongooseLoaded
# exports.nativeSupported   = capabilities.nativeSupported
# exports.nativeLoaded      = capabilities.nativeLoaded
# exports.expressSupported  = capabilities.expressSupported
# exports.expressLoaded     = capabilities.expressLoaded
# exports.hapiSupported     = capabilities.hapiSupported
# exports.hapiLoaded        = capabilities.hapiLoaded