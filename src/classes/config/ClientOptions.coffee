{_} = require 'underscore'
RikkiTikkiAPI = module.parent.exports.RikkiTikkiAPI || module.parent.exports
#### ClientOptions
class ClientOptions extends RikkiTikkiAPI.base_classes.Hash
  constructor:(params={})->
    # invokes `Hash` with extended API Option Defaults
    ClientOptions.__super__.constructor.call @, o = _.extend( (
      host : RikkiTikkiAPI.CLIENT_HOST
      port : RikkiTikkiAPI.CLIENT_PORT
      api_version : RikkiTikkiAPI.CLIENT_API_VERSION
      app_id: RikkiTikkiAPI.CLIENT_APP_ID
      app_id_param_name : RikkiTikkiAPI.CLIENT_APP_ID_PARAM_NAME
      api_namespace : RikkiTikkiAPI.CLIENT_API_NAMESPACE
      rest_key : RikkiTikkiAPI.CLIENT_REST_KEY
      rest_key_param_name  : RikkiTikkiAPI.CLIENT_REST_KEY_PARAM_NAME
      protocol : RikkiTikkiAPI.CLIENT_PROTOCOL
      ), params),
      # passes array of keys to restrict Hash access
      _.keys o
module.exports = ClientOptions