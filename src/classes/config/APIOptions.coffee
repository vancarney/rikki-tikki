{_}       = require 'lodash'
Hash      = require 'strictly-hash'
path      = require 'path'
Singleton = require '../base_class/Singleton'
#### APIOptions
class APIOptions extends Hash
  constructor:-> 
    config_path = './server/api-hero.json'
    params = if path.exists config_path then require config_path else {}
    # invokes `Hash` with extended API Option Defaults
    APIOptions.__super__.constructor.call @, o = _.extend((
      # defines `api_basepath`: the base path for the REST route
      api_basepath : '/api'
      # defines `api_version`: the version for the REST route
      api_version : ''
      api_path:''
      # defines `api_namespace`: the published API NameSpace
      api_namespace : ''
      # defines `schema_path`: the schema directory path
      schema_path  : "#{process.cwd()}#{path.sep}schemas"
      # defines `require_path`: the path to require npm modules from
      schema_api_require_path  : "#{process.cwd()}#{path.sep}.api-hero"
      # defines `data_path`: the location of the rikki-tikki's hidden file cache
      data_path : "#{process.cwd()}#{path.sep}.api-hero"
      # defines `trees_path`: the location of the rikki-tikki's cache file for schema trees file
      trees_path : "#{process.cwd()}#{path.sep}.api-hero#{path.sep}trees"
      # defines `destructive`: destroy orrenamedeleteted collection schemas
      destructive : false
      # defines `wrap_schema_exports`: wrap schema exports in Model
      wrap_schema_exports : true
      # defines `debug`: debug mode on/off
      debug : process.NODE_ENV is undefined or process.NODE_ENV is 'development'
      # defines `default_datasource`: name of datasource to use by default
      default_datasource : 'mongo'
      ), params),
      # passes array of keys to restrict Hash access
      _.keys o
    @set 'api_path', "#{@get 'api_basepath'}/#{@get 'api_version'}/"
    # replaces setter method with a no-op
    @set = => false
    # sets all values to read-only
    @freeze()
class ReturnValue extends Singleton
  constructor:->
    @__opts = new APIOptions
  getOpts:->
    @__opts
module.exports = ReturnValue.getInstance().getOpts()
