Env  = {}
Env.getEnvironment = ->
  process.env.NODE_ENV || 'development'
Env.isDevelopment = ->
  Env.getEnvironment() == 'development'
module.exports = Env