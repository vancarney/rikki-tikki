ArrayCollection = require 'js-arraycollection'
RikkiTikkiAPI   = module.parent.exports
class ModuleManager extends RikkiTikkiAPI.base_classes.Singleton
  constructor:->
    ModuleManager.__super__.constructor.call @
    modules = new ArrayCollection []
    # .on 'open', =>
      # console.log 'open'
    @registerModule = (name,clazz)=>
      modules.addItem {name:name, _class:clazz, instance:(inst = new clazz)}
      inst.api = RikkiTikkiAPI
      inst.onRegister()
    @removeModule = (name)=>
      for k,o of modules.__list
        if o.name is name
          modules.removeItemAt k
          return o
      null
    @retrieveModule = (name)->
      for k,o of modules.__list
        return o if o.name is name
module.exports = ModuleManager