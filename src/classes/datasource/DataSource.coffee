{_}               = require 'lodash'
{EventEmitter}    = require 'events'
{DataSource}      = require 'loopback-datasource-juggler'
{BuiltIns}        = require '../types'
APIOptions        = require '../config/APIOptions'

class DataSourceWrapper extends DataSource
  constructor:(NameOrDS, options)->
    DataSourceWrapper.__super__.constructor.call @, NameOrDS, options
    _.extend @, EventEmitter
    @canBuildModelFromInstance = => 
      typeof @buildModelFromInstance is 'function'
    @isRelational = ->
      @connector.relational || false
    @isNoSQL = ->
      @connector.nosql || (@name.match /^(mongodb|Memory)+$/)? || false
  isApiHeroEnabled:->
    @hasOwnProperty 'ApiHero'
  getCollection:(name,callback)->
    throw 'callback required' unless typeof arguments[arguments.length - 1] is 'function'
    return callback "APIHero enabled DataSource for '#{@name}' required" unless @isApiHeroEnabled()
    @ApiHero.getCollection.apply @, arguments
  # lists data models loaded into LoopBack
  listModels:->
    l = _.filter @models, (model, name)=>
      (0 > BuiltIns.indexOf name) and (model != undefined) and (model.getDataSource()?.settings.name == @sourceName)
    _.compact _.map l, (m)-> m.definition.name
  # lists actual collections/tables on Data Source
  listCollections:(callback)->
    throw 'callback required' unless typeof arguments[arguments.length - 1] is 'function'
    if @hasOwnProperty 'ApiHero'
      @ApiHero.listCollections (e,cols)=>
        callback null, _.compact _.map cols, (v)=>
          return v unless (ex = @ApiHero.exclude) and ex.length
          return v unless v.match new RegExp "^(#{ex.join '|'})$"
    else
      process.nextTick => callback null, _.keys @models
  # creates a Collection on ApiHero Enabled DataSource
  createCollection:(name, json, opts, callback)->
    _cB = arguments[arguments.length - 1]
    throw 'callback required' unless typeof _cB is 'function'
    # passes error message to callback if ApiHero not enabled
    return callback "APIHero enabled DataSource for '#{@name}' required" unless @isApiHeroEnabled()
    arguments[arguments.length - 1] = (e,ref)=>
      _args = arguments
      CollectionMonitor.getInstance().refresh =>
        _cB.apply @, _args
    # invokes createCollection with supplied arguments
    @ApiHero.createCollection.apply @ApiHero, arguments
  dropCollection:(name, callback)->
    _cB = arguments[arguments.length - 1]
    throw 'callback required' unless typeof _cB is 'function'
    # passes error message to callback if ApiHero not enabled
    return _cB "APIHero enabled DataSource for '#{@name}' required" unless @isApiHeroEnabled()
    arguments[arguments.length - 1] = (e,ref)=>
      (cm = CollectionMonitor.getInstance()).refresh (e,list)=>
        return _cB e if e?
        if 0 <= _.pluck( cm.getCollection(), 'name').indexOf @name
          return _cB "collection '#{@name}' not dropped" if col?
        _cB null, true
    @ApiHero.dropCollection.apply @ApiHero, arguments
  removeCollection:->
    @dropCollection.apply @, arguments
  renameCollection:(name, newName, opts, callback)->
    _cB = arguments[arguments.length - 1]
    throw 'callback required' unless typeof _cB is 'function'
    return callback "new name is required" unless newName? and typeof newName is 'string'
    arguments[arguments.length - 1] = (e,ref)=>
      _args = arguments
      CollectionMonitor.getInstance().refresh =>
        _cB.apply @, _args
    @ApiHero.renameCollection.apply @ApiHero, arguments
  buildModel:(name, json, opts, callback)->
    throw 'callback required' unless typeof arguments[arguments.length - 1] is 'function'
    # passes error message to callback if ApiHero not enabled
    return callback "APIHero enabled DataSource for '#{@name}' required" unless @isApiHeroEnabled()
    return callback "buildModel not supported for '#{@name}'" unless @buildModelFromInstance
    # throw "cannot create collections on SQL connection" unless @canBuildModelFromInstance()
    throw 'could not create model' unless typeof (o = @buildModelFromInstance.apply @, _.initial arguments) is 'function'
    callback null, o
    # CollectionMonitor.getInstance().refresh =>
      # callback.apply @, arguments
  deriveSchema:(nameOrCollection,callback)->
    @ApiHero.deriveSchema.apply @ApiHero, arguments
DataSourceWrapper.getDataSource = (name)=>
  DataSourceManager = require './DataSourceManager'
  DataSourceManager.getInstance().getDataSource name
module.exports = DataSourceWrapper
CollectionMonitor = require '../collections/CollectionMonitor'
CollectionManager = require '../collections/CollectionManager'