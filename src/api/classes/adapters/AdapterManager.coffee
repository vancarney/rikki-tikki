{_}         = require 'underscore'
RikkiTikkiAPI = module.parent.exports.RikkiTikkiAPI
class AdapterManager extends RikkiTikkiAPI.base_classes.Singleton
  __adapters:{}
  registerAdapter: (name, adapterClass)->
    @__adapters[name] = adapterClass
  listAdapters:->
    _.keys @__adapters
  getAdapterClass:(name)->
    @__adapters[name]
  unregisterAdapter: (name)->
    delete @__adapters[name]
AdapterManager.getInstance = ->
  @__instance ?= new AdapterManager()
module.exports = AdapterManager