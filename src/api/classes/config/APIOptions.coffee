{_} = require 'underscore'
RikkiTikkiAPI = module.parent.exports
class APIOptions extends RikkiTikkiAPI.base_classes.Hash
  constructor:(params={})->
    APIOptions.__super__.constructor.call @, o = _.extend( (
      api_basepath : RikkiTikkiAPI.API_BASEPATH
      api_version : RikkiTikkiAPI.API_VERSION
      api_namespace : RikkiTikkiAPI.API_NAMESPACE
      config_filename : RikkiTikkiAPI.CONFIG_FILENAME
      schema_trees_file : RikkiTikkiAPI.SCHEMA_TREES_FILE
      config_path : RikkiTikkiAPI.CONFIG_PATH
      schema_path  : RikkiTikkiAPI.SCHEMA_PATH
      adapter : RikkiTikkiAPI.ADAPTER
      ), params), 
      _.keys o
module.exports = APIOptions