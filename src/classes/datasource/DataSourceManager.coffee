{_}         = require 'lodash'
Singleton   = require '../base_class/Singleton'
APIOptions  = require '../config/APIOptions'
class DSManager extends Singleton
  __ds:{}
  ##> getDataSource
  # retrieves DataSource if defined
  getDataSource:(name)->
    name = APIOptions.get 'default_datasource' unless name? or 0 <= _.keys(@__ds).indexOf name
    @__ds[name] || null
  ##> getDSNames
  # retrieves names of all configured DS entries
  getDSNames:->
    _.keys @__ds
  ##> initialize
  # initializer for DataSources
  initialize: (callback)->
    throw 'callback required as arguments[0]' if typeof arguments[0] != 'function'
    ApiHero = require '../..'
    datasources = ApiHero.getApp().datasources
    names = _.uniq _.compact _.map _.keys(datasources), (key) -> key.toLowerCase()
    done = _.after names.length, =>
      callback null, 'ok'
    for dsName in names
      if datasources[dsName].settings?.connector.hasOwnProperty 'mailer'
        done()
        continue
      if datasources[dsName].connector != 'memory' and typeof datasources[dsName].settings?.connector.match != 'function'
        done()
        continue
      if datasources[dsName].settings?.connector.match ///^loopback\-component\-storage///
        done()
        continue
      unless (ds = @__ds[dsName])?
        DataSource  = require './DataSource'
        ds = @__ds[dsName] = new DataSource(datasources[dsName].name, datasources[dsName])
        return callback "unable to allocate datasource #{dsName}" unless ds?
      if ds.connected or ds.connecting
        process.nextTick done
      ds.connect (e, db) =>
        return callback e if e?
        done()
    @
module.exports = DSManager