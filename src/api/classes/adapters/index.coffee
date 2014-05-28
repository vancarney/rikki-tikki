module.exports.RikkiTikkiAPI = RikkiTikkiAPI = module.parent.exports
module.exports = AdapterManager = require './AdapterManager'
RikkiTikkiAPI.Adapters = AdapterManager.getInstance()
RikkiTikkiAPI.Adapters.registerAdapter 'express', require './ExpressAdapter'
RikkiTikkiAPI.Adapters.registerAdapter 'hapi',    require './HapiAdapter'
RikkiTikkiAPI.Adapters.registerAdapter 'routes',  require './RoutesAdapter'