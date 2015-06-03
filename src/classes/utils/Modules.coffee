{_} = require 'lodash'
path = require 'path'
module.exports.detectModule = (name)->
  _.map( _.pluck( (require.main || {}).children, 'filename' ), (p)-> path.dirname(p).split(path.sep).pop()).indexOf( name ) > -1
module.exports.getModulePath = (name)->
  names = _.map( paths = _.pluck( (require.cache || {}), 'id' ), (p)-> path.dirname(p).split(path.sep).pop())
  if 0 <= (idx = names.indexOf name) then paths[idx] else null