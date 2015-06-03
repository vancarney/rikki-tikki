#### ClientLoader
#> Loads the Client Library to pass to Requesting Browser Client
#> requires: lodash
{_}               = require 'lodash'
{AbstractLoader}  = require '../base_class'
Util              = require '../utils'
# defines `SchemaLoader` as sub-class of `AbstractLoader`
class ClientLoader extends AbstractLoader
  # holder for Schema Data
  __data:{}
  constructor:->
    _path = (Util.Module.getModulePath 'rikki-tikki-client').replace /index\.js/, 'lib/rikki-tikki-client.js'
    # invokes `AbstractLoader` with path if passed
    ClientLoader.__super__.constructor.call @, _path
  load:(callback)->
    try
      Util.File.readFile @__path, 'utf8', (e, data) =>
        callback? e, @__data = data
    catch e
      callback? "could not load file '#{@__path}\n#{e}", null
  save:(callback)->
    callback? new Error 'Save is not allowed', null
module.exports = ClientLoader