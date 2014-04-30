{_} = require 'underscore'
module.exports.RikkiTikkiAPI = RikkiTikkiAPI = module.parent.exports
module.exports.AbstractAdapter  = require './AbstractAdapter'
module.exports.express          = require './ExpressAdapter'
module.exports.hapi             = require './HapiAdapter'
module.exports.routes           = require './RoutesAdapter'
RikkiTikkiAPI.addRoutingAdapter = (name, adapter)->
  module.exports[name] = adapter
RikkiTikkiAPI.getRoutingAdapter = (name)->
  module.exports[name]
RikkiTikkiAPI.removeRoutingAdapter = (name)->
  delete module.exports[name]
RikkiTikkiAPI.listRoutingAdapters = ->
  _.keys module.exports
