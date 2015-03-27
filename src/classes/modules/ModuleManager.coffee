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
      # modules.removeItemAt _.find
module.exports = ModuleManager