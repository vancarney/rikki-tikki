Env  = {}
Env.getEnvironment = ->
  process.env.NODE_ENV || 'development'
Env.isDevelopment = ->
  (@getEnvironment().match /^dev+(el|elopment)?$/)?
Env.isProduction = ->
  (@getEnvironment().match /^prod+(uction)?$/)?
module.exports = Env