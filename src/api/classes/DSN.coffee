#### sparse.Collection
# > Establshes Mongo DB with Mongoose
class RikkiTikkiAPI.DSN extends Object
  __dsn:null
  constructor:(dsn)->
    @setDSN (if dsn instanceof String then @parseDSNString dsn else dsn) if dsn
  parseDSNString:(string)->
    # this regex is used only to `grep`, so it is expected to match illegal charachters
    if (dsnParams = string.match ///^
      (mongodb\:\/\/)?                           # protocol
      (.+:?.?@)?                                 # username:password@
      ([a-z0-9\.]+)+                             # hostname
      (:[a-zA-Z0-9]{4,5})?                       # :port
      \,?([a-zA-Z0-9\.\,:]*)?                    # replica hosts,
      (\/\w+)?                                   # /database name
      \??([a-zA-Z0-9\_=&\.]*)?                   # options string
      $///) != null       
      return protoDSN = 
        protocol: if dsnParams[1] then dsnParams[1].split(':').shift() else null
        username: if dsnParams[2] then (pass = dsnParams[2].replace('@','').split ':').shift() else null
        password: if pass and pass.length then "#{pass}" else null
        host:     dsnParams[3] || null
        port:     if dsnParams[4] then parseInt dsnParams[4].split(':').pop() else null
        replicas: if dsnParams[5] then _.map dsnParams[5].split(','), (v,k)-> host:(port=v.split ':').shift(), port:parseInt port.shift() else null
        database: if dsnParams[6] then dsnParams[6].split('/').pop() else null
        options:  if dsnParams[7] then new RikkiTikkiAPI.DSNOptions dsnParams[7] else null
    null
  setOptions:(options)->
    @__dsn ?= {}
    # @__dsn.options = new RikkiTikkiAPI.DSNOptions options
  getOptions:->
    @__dsn?.options || null
  setDSN:(dsn)->
    dsn = @parseDSNString dsn if RikkiTikkiAPI.Util.isOfType dsn, String
    # dsn.options = new RikkiTikkiAPI.DSNOptions dsn.options if dsn?.options and !RikkiTikkiAPI.Util.isOfType dsn.options, RikkiTikkiAPI.DSNOptions
    try
      @__dsn = dsn if @validate dsn
    catch e
      throw Error e
  getDSN:->
    @__dsn || null
  validate:(dsn)->
    errors = []
    oTypes =
      protocol:
        type:String
        required:false
        restrict:/^mongodb+$/
      username:
        type:String
        required:false
      password:
        type:String
        required:false
      host:
        type:String
        required:true
        restrict:///^
        (([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])|
        (([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\-]*[A-Za-z0-9])
        $///
      port:
        type:Number
        required:false
        restrict:/^[0-9]{4,5}$/
      replicas:
        type:Array
        required:false
      database:
        type:String
        required:false
      options:
        type:RikkiTikkiAPI.DSNOptions
        required:false
    _.each oTypes, (value,key)=>
      if dsn[key]?
        if !RikkiTikkiAPI.Util.isOfType dsn[key], value.type
          throw Error "#{key} was expected to be #{RikkiTikkiAPI.Util.getFunctionName value.type}. Type was '#{typeof dsn[key]}'"
        if value.restrict and !dsn[key].toString().match value.restrict
          throw Error "#{key} was malformed"
      else if value.required
        throw Error "#{key} was required but not defined"
    if options
      try
        options = new DSNOptions options
      catch e
        throw Error e
    return true
  toJSON:->
    @__dsn
  toDSN:->
    userPass = "#{@__dsn.username || ''}#{if @__dsn.username and @__dsn.password then ':'+@__dsn.password else ''}"
    "#{@__dsn.protocol || 'mongodb'}://#{userPass}#{if userPass.length then '@' else ''}#{@__dsn.host}:#{@__dsn.port || '27017'}/#{@__dsn.database || ''}#{if @__dsn.options then '?'+@__dsn.options else ''}"
  toString:->
    @toDSN()