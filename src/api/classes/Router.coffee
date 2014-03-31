# RikkiTikkiAPI.Routes = require './Routes'
RikkiTikkiAPI.API_BASEPATH = '/api'
RikkiTikkiAPI.API_VERSION  = '1'
RikkiTikkiAPI.getAPIPath = ->
  "#{RikkiTikkiAPI.API_BASEPATH}/#{RikkiTikkiAPI.API_VERSION}"
class RikkiTikkiAPI.Router extends Object
  constructor:(@__db, @__collections, @__adapter)->
    console.log @__db
    throw Error 'adapter must be defined' if !@__adapter
    # @__parent = opts?.parent || null
    # @__parent = opts?.parent || null
    @__routes = new RikkiTikkiAPI.Routes @__db, @__adapter
  # __routes:
    # show:(req,res,callback)->
      # callback? res, status:200, results:'show'
    # update:(req,res,callback)->
      # callback? res,, status:200, results:'update'
    # create:(req,res,callback)->
      # callback? res, status:200, results:'create'
    # destroy:(req,res,callback)->
      # callback? res, status:200, results:'destroy'
    # index:(req,res,callback)->
      # callback? res, status:200, results:'index'
  initializeApp:(parent)->
  getAdapter:-> @__adapter
  intializeRoutes:->
    verbose = false
    api_path = RikkiTikkiAPI.getAPIPath()
    _.each @__collections, (name)=>
      verbose && logger.log 'debug', "#{name}:"
      # obj = require "./../routes/#{name}"
      obj = {}
      name = name.split('.').pop()
      prefix = obj.prefix || ''
      # before middleware support
      if obj.before
        path = "#{api_path}/#{name}/:#{name}_id"
        app.all path, obj.before
        verbose && logger?.log 'debug', "     ALL #{path} -> before" 
        path = "#{api_path}/#{name}/:#{name}_id/*"
        app.all path, obj.before
        verbose && logger?.log 'debug', "     ALL #{path} -> before" 
      # generate routes based on the exported methods
      for operation in ['index','show','create','update','destroy']
        # "reserved" exports
        continue if ~['name', 'prefix', 'engine', 'before'].indexOf operation
        # route exports
        switch operation
          when 'show'
            method = 'get'
            path = "#{api_path}/#{name}/:#{name}_id"
          when 'update'
            method = 'put'
            path = "#{api_path}/#{name}/:#{name}_id"
          when 'create'
            method = 'post'
            path = "#{api_path}/#{name}"
          when 'destroy'
            method = 'delete'
            path = "#{api_path}/#{name}/:#{name}_id"
          when 'index'
            method = 'get'
            path = "#{api_path}/#{if name != 'index' then name else ''}"
          else
            throw new Error "unrecognized route: #{name}.#{operation}"
        path = "#{prefix}#{path}"
        # app[method](path, @__routes[key])
        @__adapter.addRoute path, method, handler if (handler = @__routes.createRoute method, path, operation)?
        verbose && logger.log 'debug', "#{method.toUpperCase()} #{path} -> #{operation}"
      # @__parent.use app