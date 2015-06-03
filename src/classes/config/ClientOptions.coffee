{_}   = require 'lodash'
Hash  = require '../base_class/Hash'
#### ClientOptions
class ClientOptions extends Hash
  constructor:(params={})->
    Fleek = require '../..'
    # invokes `Hash` with extended API Option Defaults
    ClientOptions.__super__.constructor.call @, o = _.extend( (
      host : Fleek.getApp().get 'host'
      port : Fleek.getApp().get 'post'
      api_version : (Fleek.getApp().get 'version') || 1
      # app_id: require.main.exports.get 'APP'
      # app_id_param_name : Fleek.CLIENT_APP_ID_PARAM_NAME
      # api_namespace : Fleek.CLIENT_API_NAMESPACE
      # rest_key : Fleek.CLIENT_REST_KEY
      # rest_key_param_name  : Fleek.CLIENT_REST_KEY_PARAM_NAME
      # protocol : Fleek.CLIENT_PROTOCOL
      ), params),
      # passes array of keys to restrict Hash access
      _.keys o
module.exports = ClientOptions
# Fleek = require '../..'
