{_}         = require 'lodash'
async       = require 'async'
Singleton   = require '../base_class/Singleton'
class DSManager extends Singleton
  defaultDataSource:'db'
  __ds:{}
  constructor:->
    for name in @getDSNames()
      @__ds[name] = @getDataSource name
    @
  getDataSource:(name)->
    Fleek = require '../..'
    ds = null
    name = @defaultDataSource unless 0 <= @getDSNames().indexOf name
    unless (ds = @__ds[name])?
      ds = @__ds[name] = new DataSource name, source if (source = Fleek.getApp().datasources[name])?
    ds || null
  getDSNames:->
    Fleek = require '../..'
    throw 'could not retrieve datasources' unless typeof (datasources = Fleek.getApp().datasources) is 'object'
    _.uniq _.compact _.map (_.keys datasources), (key)-> key.toLowerCase()
  initialize:(callback)->
    return throw 'callback required as arguments[0]' unless typeof arguments[0] is 'function'
    async.forEachOf @__ds, ((ds, k, cB)=> ds.connect cB), (e)=>
      callback.apply @, if e? then [e] else [null,true]
module.exports = DSManager
DataSource  = require './DataSource'
Fleek       = null # require '../..'