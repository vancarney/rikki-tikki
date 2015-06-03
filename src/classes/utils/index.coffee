{_}   = require 'lodash'
path  = require 'path'
Util  = {}
Util.Env          = require './Env'
Util.File         = require './File'
Util.Function     = require 'fun-utils'
Util.Module       = require './Modules'
Util.String       = require './String'
Util.Object       = require './Object'

Capabilities = require './Capabilities'
Util.getCapabilities = => 
  new Capabilities

module.exports = Util
