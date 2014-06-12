module.exports.RikkiTikkiAPI = RikkiTikkiAPI = module.parent.exports
module.exports = AdapterManager = require './AdapterManager'
RikkiTikkiAPI.Adapters = AdapterManager.getInstance()
RikkiTikkiAPI.Adapters.registerAdapter 'express', ExpressAdapter = require './ExpressAdapter'
# RikkiTikkiAPI.Adapters.registerAdapter 'hapi',    HapiAdapter = require './HapiAdapter'
RikkiTikkiAPI.Adapters.registerAdapter 'routes',  RoutesAdapter = require './RoutesAdapter'