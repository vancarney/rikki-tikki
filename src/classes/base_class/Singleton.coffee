{EventEmitter}  = require 'events'
class Singleton extends EventEmitter
  'use strict'
  @getInstance: ->
    @__instance ?= new @
module.exports = Singleton