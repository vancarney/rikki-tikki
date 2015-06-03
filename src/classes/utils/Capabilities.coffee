{_}   = require 'lodash'
path  = require 'path'
class Capabilities extends Object
  __modules: []
  __loaded_modules: []
  constructor:->
    for name in ['mongoose','mongodb','rikki-tikki-client'] 
      @__modules = _.union @__modules, name if _.map( _.pluck( require.cache, 'filename' ), (p)-> path.dirname(p).split(path.sep).pop()).indexOf( "#{name}" ) > -1
      @__loaded_modules.push name if Util.detectModule name
  detectedModules: ->
    @__modules
  loadedModules: ->
    @__loaded_modules
  clientSupported: ->
    0 <= @detectedModules().indexOf( 'rikki-tikki-client' )
  clientLoaded: ->
    0 <= @loadedModules().indexOf 'rikki-tikki-client'
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
module.exports = Capabilities
Util = require './Modules'
