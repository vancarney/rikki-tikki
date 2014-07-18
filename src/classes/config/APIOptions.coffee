{_} = require 'underscore'
path = require 'path'
RikkiTikkiAPI = module.parent.exports
#### APIOptions
class APIOptions extends Object
  constructor:(params={})-> 
    # invokes `Hash` with extended API Option Defaults
    return new RikkiTikkiAPI.base_classes.Hash o = _.extend( (
      api_basepath : RikkiTikkiAPI.API_BASEPATH
      api_version : RikkiTikkiAPI.API_VERSION
      api_namespace : RikkiTikkiAPI.API_NAMESPACE
      auth_config_path: RikkiTikkiAPI.AUTH_CONFIG_PATH
      config_filename : RikkiTikkiAPI.CONFIG_FILENAME
      config_path : RikkiTikkiAPI.CONFIG_PATH
      schema_path  : RikkiTikkiAPI.SCHEMA_PATH
      destructive : RikkiTikkiAPI.DESTRUCTIVE
      wrap_schema_exports : RikkiTikkiAPI.WRAP_SCHEMA_EXPORTS
      adapter : RikkiTikkiAPI.ADAPTER
      debug : RikkiTikkiAPI.DEBUG
      ), params),
      # passes array of keys to restrict Hash access
      _.keys o
module.exports = APIOptions