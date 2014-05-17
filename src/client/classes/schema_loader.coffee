class RikkiTikki.SchemaLoader extends RikkiTikki.Object
  constructor:(opts={})->
    delete opts.schema if opts.schema?
    @schema =
      '__meta__':  Object
      '__schemas__':  Object
    SchemaLoader.__super__.constructor.call @, undefined, opts 
  url:->
    "#{RikkiTikki.getAPIUrl()}/__schema__"
  get:(attr)->
    # Bypass RikkiTikki.Object's `get` function
    SchemaLoader.__super__.constructor.__super__.get.call @, attr
  fetch:(opts={})->
    params =
      # handles an XHR success event
      success:(m,r,o)=>
        # traverses the `__schemas__` param on `success`
        _.each keys = _.keys( schemas = @get('__schemas__') || {} ), (v,k)=>
          # creates a new Schema
          RikkiTikki.createSchema v, schemas[v]
          # invokes a success callback if defined when all schemas have been created
          opts.success?() if k == _.keys(keys).length - 1
      # handles an XHR Error event
      error:(m,r,o)=>
        opts.error? m, r, o
    # invokes super's fetch with our response handlers set in the options hash
    SchemaLoader.__super__.fetch.call @, _.extend _.clone(opts), params
  # overrides super's parse method
  parse:(response, opts)->
    # invokes revive on the responseText (JSON string)
    SchemaLoader.__super__.parse.call @, JSON.parse( opts.xhr.responseText, SchemaLoader.reviver ), opts
  save:->
  destroy:->
RikkiTikki.SchemaLoader.reviver = (key,value)->
  # removes reserved element names from schema params
  return undefined if 0 <= _.keys( RikkiTikki.Schema.reserved ).indexOf key
  # attempts to convert string to `Function` or `Object` and returns value
  if typeof value == 'string' and (fun = RikkiTikki.Function.fromString value)? then fun else value