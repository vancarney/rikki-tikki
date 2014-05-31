fs   = require 'fs'
path = require 'path'
RikkiTikkiAPI = module.parent.exports
class ConfigLoader extends RikkiTikkiAPI.base_classes.AbstractLoader
  constructor:(@__options)->
    ConfigLoader.__super__.constructor.call @
  load:(callback)->
    @__path = path.normalize "#{@__options.get 'config_path'}#{path.sep}#{@__options.get 'config_filename'}"
    if fs.existsSync @__path
      ConfigLoader.__super__.load.call @, (e, data)=>
        @__data = JSON.parse data if data
        callback? e, data
    else
      callback? new Error "Could not find config file at '#{@__path}'"
  getEnvironment:(env)->
    @__data?[env] || null
module.exports = ConfigLoader