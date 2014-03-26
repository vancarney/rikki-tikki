RikkiTikkiAPI.API_BASEPATH = '/api'
RikkiTikkiAPI.API_VERSION  = '1'
RikkiTikkiAPI.getAPIPath = ->
  "#{RikkiTikkiAPI.API_BASEPATH}/#{RikkiTikkiAPI.API_VERSION}"
class RikkiTikkiAPI.Router extends Object
  constructor:(@__parent, @__collections, @__adapter)->
    throw Error 'adapter must be defined' if !@__adapter
    # @__parent = opts?.parent || null
    # @__parent = opts?.parent || null
  __routes:
    list:(req,res,next)->
      console.log 'list'
    show:(req,res,next)->
      console.log 'show'
    edit:(req,res,next)->
      console.log 'edit'
    update:(req,res,next)->
      console.log 'update'
    create:(req,res,next)->
      console.log 'create'
    destroy:(req,res,next)->
      console.log 'destroy'
    index:(req,res,next)->
      console.log 'index'
  initializeApp:(parent)->
  getAdapter:-> @__adapter
  intializeRoutes:()->
    api_path = RikkiTikkiAPI.getAPIPath()
    _.each @__collections, (name)->
      verbose && logger.log 'debug', "#{name}:"
      # obj = require "./../routes/#{name}"
      obj = {}
      name = name.split('.').pop()
      # prefix = obj.prefix || ''
      # before middleware support
      if obj.before
        path = "#{api_path}/#{name}/:#{name}_id"
        app.all path, obj.before
        verbose && logger?.log 'debug', "     ALL #{path} -> before" 
        path = "#{api_path}/#{name}/:#{name}_id/*"
        app.all path, obj.before
        verbose && logger?.log 'debug', "     ALL #{path} -> before" 
      # generate routes based on the exported methods
      for key of @__routes
        # "reserved" exports
        continue if ~['name', 'prefix', 'engine', 'before'].indexOf key
        # route exports
        switch key
          when 'show'
            method = 'get'
            path = "#{api_path}/#{name}/:#{name}_id"
          when 'list'
            method = 'get'
            path = "#{api_path}/#{name}s"
          when 'edit'
            method = 'get'
            path = "#{api_path}/#{name}/:#{name}_id/edit"
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
            throw new Error "unrecognized route: #{name}.#{key}"
        path = "#{prefix}#{path}"
        # app[method](path, @__routes[key])
        @__adapter.addRoute path. method, @__routes[key]
        verbose && logger.log 'debug', "#{method.toUpperCase()} #{path} -> #{key}"
      parent.use app