fs = require 'fs'
RikkiTikkiAPI = module.parent.exports
class ConfigLoader extends Object
  __config:null
  constructor:(_path=null)->
    _path ?= module.parent.exports.getFullPath()
    @load _path if module.parent.exports.configExists _path
  load:(_path)->
    try
      @__config = JSON.parse fs.readFileSync _path, encoding:'utf-8'
    catch e
      throw Error e
  getEnv:(env)->
    @__config?[env] || null
  toJSON:-> @__config
  toString:-> JSON.stringify @__config, null, 2 
module.exports = ConfigLoader
