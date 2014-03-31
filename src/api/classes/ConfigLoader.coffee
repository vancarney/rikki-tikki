class RikkiTikkiAPI.ConfigLoader extends Object
  __config:null
  constructor:(_path=null)->
    _path ?= RikkiTikkiAPI.getFullPath()
    @load _path if RikkiTikkiAPI.configExists _path
  load:(_path)->
    try
      @__config = JSON.parse fs.readFileSync _path, encoding:'utf-8'
    catch e
      throw Error e
  getEnv:(env)->
    @__config?[env] || null
  toJSON:-> @__config
  toString:-> JSON.stringify @__config, null, 2 
RikkiTikkiAPI.CONFIG_FILENAME = 'rikkitikki.json'
RikkiTikkiAPI.CONFIG_PATH = 'config'
RikkiTikkiAPI.getFullPath = ->
  path.normalize "#{process.cwd()}#{path.sep}#{RikkiTikkiAPI.CONFIG_PATH}#{path.sep}#{RikkiTikkiAPI.CONFIG_FILENAME}"
RikkiTikkiAPI.configExists = (_path)->
  fs.existsSync if path?.match /\.json$/ then _path else RikkiTikkiAPI.getFullPath() 
