ArrayCollection = require 'js-arraycollection'
RikkiTikkiAPI   = module.parent.exports.RikkiTikkiAPI
class ModuleManager extends RikkiTikkiAPI.base_classes.Singleton
  constructor:->
    ModuleManager.__super__.constructor.call @
    modules = new ArrayCollection []
    .on 'open', =>
      console.log 'open'
    # @addModule = (name,clazz)=>
      # modules.addItem {name:name, _class:clazz}
    # @removeModule = (name)=>
      # modules.removeItemAt
