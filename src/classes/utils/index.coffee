{_}   = require 'underscore'
path  = require 'path'
Util  = {}
Util.detectModule = (name)->
  _.map( _.pluck( require.main.children, 'filename' ), (p)-> path.dirname(p).split(path.sep).pop()).indexOf( name ) > -1
Util.getModulePath = (name)->
  console.log _.pluck( require.cache, 'id' )
  names = _.map( paths = _.pluck( require.cache, 'id' ), (p)-> path.dirname(p).split(path.sep).pop())
  if 0 <= (idx = names.indexOf name) then paths[idx] else null
module.exports = Util
Capabilities = require './Capabilities'
Util.getCapabilities = => 
  new Capabilities
Util.Env          = require './Env'
Util.File         = require './File'
Util.Function     = require './Function'
Util.String       = require './String'
Util.Object       = require './Object'
Util.Query        = require './Query'
