{_}         = require 'lodash'
Singleton   = require '../base_class/Singleton'
APIOptions  = require '../config/APIOptions'
DataSource  = require './DataSource'
class DSManager extends Singleton
  __ds:{}
  constructor:->
  getDataSource:(name)->
    name = APIOptions.get 'default_datasource' unless name? or 0 <= _.keys(@__ds).indexOf name
    @__ds[name] || null
  getDSNames:->
    _.keys @__ds
  initialize:(callback)->
    return throw 'callback required as arguments[0]' unless typeof arguments[0] is 'function'
    ApiHero       = require '../..'
    {datasources} = ApiHero.getApp()
    names       = _.uniq _.compact _.map (_.keys datasources), (key)-> key.toLowerCase()
    done        = _.after names.length, => callback null, 'ok'
    for dsName in names
      ds = @__ds[dsName] = new DataSource datasources[dsName].name, {} unless (ds = @__ds[dsName])?
      return callback "unable to allocate datasource #{dsName}" unless ds?
      process.nextTick done if ds.connected || ds.connecting
      ds.connect (e,db)=>
        return callback e if e?
        done()
module.exports = DSManager