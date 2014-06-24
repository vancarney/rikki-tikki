#### ClientLoader
#> Loads the Rikki-Tikki Client Library to pass to Requesting Browser Client
#> requires: underscore
{_}           = require 'underscore'
# derives objects from module parent
RikkiTikkiAPI = module.parent.exports.RikkiTikkiAPI ||  module.parent.exports
Util          = RikkiTikkiAPI.Util
      
# defines `SchemaLoader` as sub-class of `AbstractLoader`
class ClientLoader extends RikkiTikkiAPI.base_classes.AbstractLoader
  # holder for Schema Data
  __data:{}
  constructor:->
    _path = (Util.getModulePath 'rikki-tikki-client').replace /index\.js/, 'lib/rikki-tikki-client.js'
    # invokes `AbstractLoader` with path if passed
    ClientLoader.__super__.constructor.call @, _path
  load:(callback)->
    try
      Util.File.readFile @__path, 'utf-8', (e, data) =>
        callback? e, @__data = data
    catch e
      callback? "could not load file '#{@__path}\n#{e}", null
  save:(callback)->
    callback? new Error 'Save is not allowed', null
module.exports = ClientLoader