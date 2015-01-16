RikkiTikkiAPI = module.parent.exports.RikkiTikkiAPI || module.parent.exports
class AdapterManager extends RikkiTikkiAPI.base_classes.Singleton
  __adapters:{}
  registerAdapter: (name, adapterClass)->
    @__adapters[name] = adapter:adapterClass
  listAdapters:->
    Object.keys @__adapters
  getAdapter:(name)->
    if @__adapters[name]? then @__adapters[name].adapter else null
  createAdapter:(name, options)->
    if typeof name == 'string'
      return throw "Adapter '#{name}' was not defined" unless (adapter = @getAdapter name)?
      return new adapter options
    else if RikkiTikki.Util.Object.isOfType name, RikkiTikkiAPI.base_classes.AbstractAdapter
      return new name options
  unregisterAdapter: (name)->
    delete @__adapters[name]
module.exports = AdapterManager