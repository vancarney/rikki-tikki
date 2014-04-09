class RikkiTikki.VirtualType extends Object
  getters:[]
  setters:[]
  constructor:(options, name)->
    if name
      @path = name
    else
      throw "param 'name' must be defined"
    @options = options || {}
  get: (fn)->
    @getters.push fn
    @
  set: (fn)->
    @setters.push fn
    @
  applyGetters: (value, scope)->
    v = value
    for idx in [(@getters.length - 1)..0]
      break if idx == -1
      v = @getters[idx].call scope, v, @
    v
  applySetters: (value, scope)->
    v = value
    for idx in [(@setters.length - 1)..0]
      break if idx == -1
      v = @setters[idx].call scope, v, @
    v