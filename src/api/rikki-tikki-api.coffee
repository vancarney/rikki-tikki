# Includes Backbone & Underscore if the environment is NodeJS
_             = require('underscore')._
Backbone      = require 'backbone'
EventEmitter  = require('events').EventEmitter
global.fs     = require 'fs'
global.path   = require 'path'
ArrayCollection = require('js-arraycollection').ArrayCollection
if !exports.RikkiTikki
  #### global.RikkiTikki
  # > Defines the `RikkiTikki` namespace in the 'global' environment
  RikkiTikkiAPI = exports.RikkiTikkiAPI = class RikkiTikkiAPI extends EventEmitter
    constructor:(dsn=null)->
      if dsn != false
        @connect if dsn? then dsn else (new RikkiTikkiAPI.ConfigLoader).toJSON()
    connect:(dsn,opts)-> 
      dsn = (new ConfigLoader dsn).toJSON() if dsn? and dsn instanceof String and dsn.match /\.json$/
      @__db = new RikkiTikkiAPI.Connection
      @__db.on 'open', ()=>
        @collectionMon = new RikkiTikkiAPI.CollectionMonitor @__db.getMongoDB()
        opts?.open?()
      @__db.on 'close', ()=> opts?.close?()
      @__db.on 'connect', ()=> opts?.connect?()
      @__db.on 'error', ()=> opts?.error?()
      @__db.connect dsn
    disconnect:(callback)->
      @__db.close callback
    registerApp:(@__parent)->
      @router = new RikkiTikkiAPI.Router @__parent, @collectionMon
    
