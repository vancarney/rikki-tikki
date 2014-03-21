RikkiTikkiAPI.API_BASEPATH = '/api'
RikkiTikkiAPI.API_VERSION  = '1'
RikkiTikkiAPI.getAPIPath = ->
  "#{RikkiTikkiAPI.API_BASEPATH}/#{RikkiTikkiAPI.API_VERSION}/"
class RikkiTikkiAPI.Router extends Object
  constructor:(opts)->
    @__parent = opts?.parent || null
    # @__parent = opts?.parent || null
  initializeApp:(parent)->
  intializeRoutes:->
    fs.readdirSync("#{__dirname}/../routes").forEach (name)->
      verbose && logger.log 'debug', "#{name}:"
      obj = require "./../routes/#{name}"
      name = obj.name || name
      prefix = obj.prefix || ''
      # before middleware support
      if obj.before
        path = "#{name}/:#{name}_id"
        app.all path, obj.before
        verbose && logger?.log 'debug', "     ALL #{path} -> before" 
        path = "#{name}/:#{name}_id/*"
        app.all path, obj.before
        verbose && logger?.log 'debug', "     ALL #{path} -> before" 
      # generate routes based on the exported methods
      for key of obj
        # "reserved" exports
        continue if ~['name', 'prefix', 'engine', 'before'].indexOf key
        # route exports
        switch key
          when 'show'
            method = 'get'
            path = "/#{name}/:#{name}_id"
          when 'list'
            method = 'get'
            path = "/#{name}s"
          when 'edit'
            method = 'get'
            path = "/#{name}/:#{name}_id/edit"
          when 'update'
            method = 'put'
            path = "/#{name}/:#{name}_id"
          when 'create'
            method = 'post'
            path = "/#{name}"
          when 'destroy'
            method = 'delete'
            path = "/#{name}/:#{name}_id"
          when 'index'
            method = 'get'
            path = "/#{if name != 'index' then name else ''}"
          else
            throw new Error "unrecognized route: #{name}.#{key}"
        path = prefix + path
        app[method](path, obj[key])
        verbose && logger.log 'debug', "#{method.toUpperCase()} #{path} -> #{key}"
      parent.use app