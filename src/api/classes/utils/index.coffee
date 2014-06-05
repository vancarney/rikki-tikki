{_}   = require 'underscore'
path  = require 'path'
Util  = {}
Util.detectModule = (name)->
  _.map( _.pluck( require.main.children, 'filename' ), (p)-> path.dirname(p).split(path.sep).pop()).indexOf( "#{name}" ) > -1
module.exports = Util
Util.Capabilities = require './Capabilities'
Util.Env          = require './Env'
Util.File         = require './File'
Util.Function     = require './Function'
Util.String       = require './String'
Util.Object       = require './Object'
Util.Query        = require './Query'
