{_}     = require 'lodash'
path    = require 'path'
Hash    = require 'strictly-hash'
#### AppConfig
class AppConfig extends Hash
  constructor:->
    # invokes `Hash` with internal application settings
    AppConfig.__super__.constructor.call @, o = (
      # defines `data_path`: the location of the rikki-tikki's hidden file cache
      data_path : "#{process.cwd()}#{path.sep}.rikki-tikki"
      # defines `trees_path`: the location of the rikki-tikki's cache file for schema trees file
      trees_path : "#{process.cwd()}#{path.sep}.rikki-tikki#{path.sep}trees"
      ),
      # passes array of keys to restrict Hash access
      _.keys o
    # seals the hash to prevent tampering
    @seal()
module.exports = AppConfig