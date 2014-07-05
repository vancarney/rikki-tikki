#### SchemaLoader
#> Loads a Schema File
#> requires: underscore
{_}           = require 'underscore'
#> requires: path
path          = require 'path'
# derives objects from module parent
RikkiTikkiAPI = module.parent.exports.RikkiTikkiAPI || module.parent.exports
module.exports.RikkiTikkiAPI = RikkiTikkiAPI
Util          = RikkiTikkiAPI.Util
# defines `SchemaLoader` as sub-class of `AbstractLoader`
class SchemaLoader extends RikkiTikkiAPI.base_classes.AbstractLoader
  # holder for Schema Data
  __data:{}
  constructor:(@name)->
    _path = null
    _path = SchemaLoader.createPath( @name ) if @name
    # invokes `AbstractLoader` with path if passed
    try
      SchemaLoader.__super__.constructor.call @, _path
    catch e
      @emit.apply @, ['error',e]
  # set(tree, opts, callback)
  #> adds 'tree' to loaded schema data
  set:(tree, opts, callback)->
    # tests if opts is callback
    if typeof opts == 'function'
      # defines callback from arguments
      callback = arguments[1]
      # defines opts with empty object
      opts = {}
    # applies tree to `__data`
    _.extend @__data, tree #if typeof tree == 'string' then (o={})[tree] = opts else tree
    # invokes `save` with callback
    @save callback
  # unset(attr, callback)
  #> removes 'attr' from loaded schema data
  unset:(attr, callback)->
    #  applies `delete` to __data
    delete @__data[attr] if @__data.hasOwnProperty attr
    # invokes `save` with callback
    @save callback
  # load(path, callback)
  #> loads Schema 
  load:(_path, callback)->
    # tests if path is callback
    if typeof _path == 'function'
      # defines callback from arguments
      callback = arguments[0]
      # defines path as null
      _path = null
    else
      # defines __path from path param if __path null
      @__path ?= _path
    # tests if __path exists
    if @pathExists @__path
      # invoke load on `super`
      SchemaLoader.__super__.load.call @, (e) =>
        return callback? e if e?
        callback? null, @__data
    else
      # defines __data with empty object
      @__data = {}
      # invokes callback if defined
      callback? null, @__data
  # create(name, tree={}, callback)
  #> creates new Schema and associated files
  create:(@name, tree={}, callback)->
    if @name
      _path = SchemaLoader.createPath @name
    else
      return callback? "Name is required", null
    # converts tree to wrapped schema
    model = RikkiTikkiAPI.model @name, new RikkiTikkiAPI.Schema tree
    # defines data from API schema
    @__data = model.toAPISchema().toSource()
    # attemps to create new Schema file
     # "#{RikkiTikkiAPI.getOptions().schema_path}#{path.sep}#{name}.js"
    SchemaLoader.__super__.create.call @, _path, (e,s)=>
      # invokes callback if defined
      callback? (if e? then "Could not create Schema #{_path}\r\t#{e}" else null),s
  # renameSchema(name, newName, callback)
  #> renames Schema file on filesystem
  rename:(newName, callback)->
    # invokes rename on __super__
    SchemaLoader.__super__.rename.call @, SchemaLoader.createPath(@name = newName), (e,s)=>
      # invokes callback if defined
      callback? (if e? then "Could not rename Schema #{@name}\r\t#{e}" else null),s
  # create(callback)
  #> destroys Schema and associated files 
  destroy:(callback)->
    # tests for destructiveness
    if !RikkiTikkiAPI.getOptions().destructive
      # attempts to rename file instead of deleting it. FileName.js becomes _FileName.js
      @rename "_#{@name}", (e,s) =>
        # invokes callback if present
        callback? (if e? then "Schema.destroy failed\r\t#{e}" else null),s
    # attempts to delete Schema file when APIOptions.destructive tests `true`
    else
      # invokes `destroy` on `super`
      SchemaLoader.__super__.destroy.call @, (e,s)=>
        # invokes callback if defined
        callback? (if e? then "Schema.destroy failed\r\t#{e}" else null),s
SchemaLoader.createPath = (name)->
  "#{RikkiTikkiAPI.getOptions().schema_path}#{path.sep}#{name}.js" 
# declares exports
module.exports.RikkiTikkiAPI = RikkiTikkiAPI
module.exports = SchemaLoader