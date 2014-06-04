Env  = {}
Env.getEnvironment = ->
  process.env.NODE_ENV || 'development'
Env.isDevelopment = ->
  @getEnvironment() == 'development'
module.exports = Env