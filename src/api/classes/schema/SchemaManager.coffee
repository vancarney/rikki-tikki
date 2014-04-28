{_}           = require 'underscore'
fs            = require 'fs'
path          = require 'path'
class SchemaLoader extends Object
  createSchema:(name, tree:{})->
  alterSchema:(name, tree:{})->
  fetchSchema:(name)->
  renderSchema:->
  saveSchema:->
  