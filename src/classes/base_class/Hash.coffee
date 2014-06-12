class Hash extends Object
  constructor:(object={},restrict_keys=[])->
    Hash::get = (key)=>
      object[ key ]
    Hash::set = (key,value)=>
      if typeof key == 'string'
        return false if restrict_keys.length and 0 > restrict_keys.indexOf key
        object[key] = value
      else if typeof key == 'object'
        for k,v in key
          @set k,v
    Hash::valueOf   = => object
    Hash::toJSON    = => object
    Hash::toString  = (readable=false)=> 
      JSON.stringify @toJSON(), null, if readable then 2 else undefined
module.exports = Hash