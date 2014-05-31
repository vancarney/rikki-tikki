{_}         = require 'underscore'
RikkiTikkiAPI = module.parent.exports.RikkiTikkiAPI
class AdapterManager extends RikkiTikkiAPI.base_classes.Singleton
  __adapters:{}
  registerAdapter: (name, adapterClass)->
    @__adapters[name] = adapter:adapterClass
  listAdapters:->
    _.keys @__adapters
  getAdapter:(name)->
    if @__adapters[name]? then @__adapters[name].adapter else null
  createAdapter:(name, options)->
    if typeof name == 'string'
      return new adapter( options ) if (adapter = @getAdapter name)?
    else if RikkiTikki.Util.isOfType name, RikkiTikkiAPI.base_classes.AbstractAdapter
      return new name options
  unregisterAdapter: (name)->
    delete @__adapters[name]
AdapterManager.getInstance = ->
  @__instance ?= new AdapterManager()
module.exports = AdapterManager