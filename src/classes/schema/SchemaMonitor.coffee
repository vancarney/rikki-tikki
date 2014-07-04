{_}               = require 'underscore'
fs            = require 'fs'
path          = require 'path'
RikkiTikkiAPI = module.parent.exports.RikkiTikkiAPI
Util          = RikkiTikkiAPI.Util
class SchemaMonitor extends RikkiTikkiAPI.base_classes.AbstractMonitor
  __exclude:[/^(_+.*|\.+\.?)$/]
  # constructor:->
    # SchemaMonitor.__super__.constructor.call @
  refresh:(callback)->
    ex = []
    RikkiTikkiAPI.getSchemaManager().listSchemas (e, names)=>
      list = _.compact _.map names, (v)=>
        if !fs.existsSync _path = "#{RikkiTikkiAPI.getOptions().get 'schema_path'}#{path.sep}#{v}.js"
          @__collection.removeItemAt @getNames().indexOf v 
          return null
        if (!@filter v) and (stats = fs.statSync _path)? 
          {name:v, updated:new Date(stats.mtime).getTime()}
      if list.length > 0
        _.each list, (value)=>
          if 0 <= (idx = @getNames().indexOf value.name)
            ex.push value
            @__collection.setItemAt( value, idx ) if (@__collection.getItemAt( idx ).updated != value.updated)
        @__collection.addAll list if (list = _.difference list, ex).length
      callback? e, list
  startPolling:->
    @__iVal ?= fs.watch "#{RikkiTikkiAPI.getOptions().get 'schema_path'}", (event, filename) =>
      try
        RikkiTikkiAPI.getSchemaManager().load()
      catch e
        console.log e
      finally
        @refresh()
  stopPolling:->
    if @__iVal
      @__iVal.close()
      @__iVal = null
module.exports = SchemaMonitor