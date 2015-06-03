class Hash extends Object
  constructor:(object={},restrict_keys=[])->
    Hash::get = (key)=>
      object[ key ]
    Hash::set = (key,value)=>
      if typeof key is 'string'
        return false if restrict_keys.length and 0 > restrict_keys.indexOf key
        object[key] = value
      else if typeof key is 'object'
        for k,v in key
          @set k,v
    Hash::valueOf   = => object
    Hash::toJSON    = => object
    Hash::toString  = (pretty=false)=> 
      JSON.stringify @toJSON(), null, if pretty then 2 else undefined
module.exports = Hash