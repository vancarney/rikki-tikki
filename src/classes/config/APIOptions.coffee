{_} = require 'underscore'
path = require 'path'
RikkiTikkiAPI = module.parent.exports
#### APIOptions
class APIOptions extends RikkiTikkiAPI.base_classes.Hash
  constructor:(params={})-> 
    # invokes `Hash` with extended API Option Defaults
    APIOptions.__super__.constructor.call @, o = _.extend((
      # defines `api_basepath`: the base path for the REST route
      api_basepath : RikkiTikkiAPI.API_BASEPATH
      # defines `api_version`: the version for the REST route
      api_version : RikkiTikkiAPI.API_VERSION
      # defines `api_namespace`: the published API NameSpace
      api_namespace : RikkiTikkiAPI.API_NAMESPACE
      # defines `config_filename`: the config file name
      config_filename : RikkiTikkiAPI.CONFIG_FILENAME
      # defines `config_path`: the config file path
      config_path : RikkiTikkiAPI.CONFIG_PATH
      # defines `schema_path`: the schema directory path
      schema_path  : RikkiTikkiAPI.SCHEMA_PATH
      # defines `destructive`: destroy orrenamedeleteted collection schemas
      destructive : RikkiTikkiAPI.DESTRUCTIVE
      # defines `wrap_schema_exports`: wrap schema exports in Model
      wrap_schema_exports : RikkiTikkiAPI.WRAP_SCHEMA_EXPORTS
      # defines `adapter`: routing adapter to use
      adapter : RikkiTikkiAPI.ADAPTER
      # defines `debug`: debug mode on/off
      debug : RikkiTikkiAPI.DEBUG
      ), params),
      # passes array of keys to restrict Hash access
      _.keys o
module.exports = APIOptions