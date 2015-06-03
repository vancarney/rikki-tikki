{_}     = require 'lodash'
Hash    = require 'strictly-hash'
path    = require 'path'
#### APIOptions
class APIOptions extends Hash
  constructor:(params={})-> 
    Fleek = require '../..'
    # invokes `Hash` with extended API Option Defaults
    APIOptions.__super__.constructor.call @, o = _.extend((
      # defines `api_basepath`: the base path for the REST route
      api_basepath : Fleek.API_BASEPATH
      # defines `api_version`: the version for the REST route
      api_version : Fleek.API_VERSION
      # defines `api_namespace`: the published API NameSpace
      api_namespace : Fleek.API_NAMESPACE
      # defines `config_filename`: the config file name
      config_filename : Fleek.CONFIG_FILENAME
      # defines `config_path`: the config file path
      config_path : Fleek.CONFIG_PATH
      # defines `schema_path`: the schema directory path
      schema_path  : Fleek.SCHEMA_PATH
      # defines `require_path`: the path to require npm modules from
      schema_api_require_path  : Fleek.SCHEMA_API_REQUIRE_PATH
      # defines `destructive`: destroy orrenamedeleteted collection schemas
      destructive : Fleek.DESTRUCTIVE
      # defines `wrap_schema_exports`: wrap schema exports in Model
      wrap_schema_exports : Fleek.WRAP_SCHEMA_EXPORTS || true
      # defines `adapter`: routing adapter to use
      adapter : Fleek.ADAPTER
      # defines `debug`: debug mode on/off
      debug : Fleek.DEBUG
      # defines `default_datasource`: name of datasource to use by default
      default_datasource : Fleek.DEFAULT_DATASOURCE
      ), params),
      # passes array of keys to restrict Hash access
      _.keys o
module.exports = APIOptions