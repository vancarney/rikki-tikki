class APIOptions extends Object
  constructor:->
    @api_basepath = '/api'
    @api_version  = '1'
    @api_namespace = ''
    @db_config_file = 'db.json'
    @schema_trees_file = 'schema.json'
    @config_path = 'config'
    @schema_path  = null #{sku:Number, name:String, description:String}
    @adapter = null
APIOptions.API_BASEPATH = '/api'
APIOptions.API_VERSION  = '1'
APIOptions.API_NAMESPACE = ''
APIOptions.DB_CONFIG_FILE = 'db.json'
APIOptions.SCHEMA_TREES_FILE = 'schema.json'
APIOptions.CONFIG_PATH = 'config'
APIOptions.SCHEMAS  = null #{sku:Number, name:String, description:String}
APIOptions.ADAPTER  = null