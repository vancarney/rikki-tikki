{_}           = require 'underscore'
fs            = require 'fs'
path          = require 'path'
RikkiTikkiAPI = module.parent.exports.RikkiTikkiAPI || module.parent.exports
module.exports.RikkiTikkiAPI = RikkiTikkiAPI
SchemaTree    = require './SchemaTree'
class SchemaTreeManager extends Object
  constructor:->
    @__trees  = {}
    @__path = "#{RikkiTikkiAPI.getOptions().config_path}/schema_trees"
    (@load = =>
      try
        # attempt to get stats on the file
        stat = fs.statSync @__path
      catch e
        throw new Error e
        return false
      if stat?.isDirectory()
        # walk this directory
        for file in fs.readdirSync @__path
          @__trees[file.split('.').shift()] = new SchemaTree "#{fs.realpathSync @__path}#{path.sep}#{file}"
    )()
  createTree:(name, data={}, callback)->
    if !@__trees[name]
      (@__trees[name] = new SchemaTree).create "#{@__path}#{path.sep}#{name}.json", data, callback
    else
      callback? new Error "SchemaTree '#{name}' already exists"
  destroyTree:(name, callback)->
    tree.destroy callback if (tree = @__trees[name])?
  getTree:(name, callback)->  
    callback? null, if (tree = @__trees[name])? then tree else null
  listTrees:(callback)->
    callback? null, _.keys @__trees  
  saveTree:(name, callback)->
    tree.save callback if (tree = @__trees[name])?
  saveAll:(callback)->
    eOut = []
    _.each @__trees, (v,k)-> 
      v.save (e)=> eOut.push e if e
   callback? if eOut.length  then eOut else null
SchemaTreeManager.getInstance = ->
  @__instance ?= new SchemaTreeManager()
module.exports = SchemaTreeManager