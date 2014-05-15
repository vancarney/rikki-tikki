class RikkiTikki.SchemaLoader extends RikkiTikki.Object
  constructor:(opts={})->
    delete opts.schema if opts.schema?
    @schema =
      '__meta__':  Object
      '__schemas__':  Object
    SchemaLoader.__super__.constructor.call @, undefined, opts 
  url:->
    "#{RikkiTikki.getAPIUrl()}/__schema__"
  fetch:(opts={})->
    params =
      success:(m,r,o)=>
        _.each keys = _.keys( schemas = @get('__schemas__') || {}), (v,k)=> 
          RikkiTikki.createSchema v, schemas[v] 
          opts.success?() if k == _.keys(keys).length - 1 
      error:(m,r,o)=>
        opts.error? m, r, o
    SchemaLoader.__super__.fetch.call @, params
  save:->
  destroy:->
    
  