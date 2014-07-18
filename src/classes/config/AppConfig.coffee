{_} = require 'underscore'
path = require 'path'
RikkiTikkiAPI = module.parent.exports.RikkiTikkiAPI || module.parent.exports
#### APIOptions
class AppConfig extends RikkiTikkiAPI.base_classes.Hash
  constructor:(params={})->
    # invokes `Hash` with extended API Option Defaults
    AppConfig.__super__.constructor.call @, o = _.extend( (
      data_path : "#{process.cwd()}#{path.sep}.rikki-tikki"
      trees_path : "#{process.cwd()}#{path.sep}.rikki-tikki#{path.sep}trees"
      ), params),
      # passes array of keys to restrict Hash access
      _.keys o
    # seals the hash to prevent tampering
    @seal()
module.exports = AppConfig