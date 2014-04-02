#### RikkiTikki.Query
class RikkiTikki.Query
  __q:{}
  __include: []
  __limit: -1
  __skip: 0
  __extraOpts: {}
  #### constructor(classOrName)
  # > Class Constructor Method
  constructor:(classOrName)->
    if classOrName?
      @objectClass = if _.isString classOrName then RikkiTikki.Object._getSubclass classOrName else classOrName
      @className = @objectClass.className || RikkiTikki.getConstructorName @objectClass
    @or = @_or
    @in = @_in
    @clear()
  clear:->
    @__q = {}
  #### find([options])
  # > Executes query and returns all results
  find:(opts={})->
    throw 'valid Class required' if typeof @objectClass != 'function'
    (new @objectClass).sync( RikkiTikki.CRUD_METHODS.read, [], _.extend opts, {where:@__q}
    ).then (s,r,o)=>
      _.each r.results, (v,k)=>
        (obj = if v.className then new RikkiTikki.Object v.className else new @objectClass)._finishFetch v, true
        obj
  #### first([options])
  # > Executes query and returns only the first result
  first:(opts={})->
    @find _.extend opts, {skip:0, limit:1}
  set:(col, key, val)->
    @__q[col] ?= {} if col?
    (@__q[col] || @__q)[key] = val
    @
  getParams:->
    (_.map _.pairs @__q, (v,k)=>v.join '=' ).join '&'
  toJSON:->
    @__q
  toString:->
    JSON.stringify @__q
  equalTo:(col, value)->
    @set null, col, value
  notEqualTo:(col, value)->
    @set col, '$ne', value
  dontSelect:(query)->
    @set null, '$dontSelect', query:query
  #### exists(column)
  # > Sets condition that column must exist
  exists:(col) -> @set col, '$exists', true
  #### doesNotExist(column)
  # > Sets condition that column must not exist
  doesNotExist:(col) -> @set col, '$exists', false
  #### greaterThan(column, value)
  # > Sets condition that column value must be greater than given value
  greaterThan:(col, val)->
    @set col, '$gt', val
  #### greaterThanOrEqualTo(column, value)
  # > Sets condition that column value must be greater than or equal to the given value
  greaterThanOrEqualTo:(col, val)->
    @set col, '$gte', val
  #### lessThan(column, value)
  # > Sets condition that column value must be less than given value
  lessThan:(col, value)->
    @set col, '$lt', value
  #### lessThanOrEqualTo(column, value)
  # > Sets condition that column value must be less than or equal to the given value
  lessThanOrEqualTo:(col, value)->
    @set col, '$lte', value
  contains:(col, val)->
    @set col, '$regex', "#{RikkiTikki.Query._quote val}"
  #### containsAll(column, array)
  # > Sets condition that column value must be an array containing all items in given array
  containsAll:(col,array)->
    @set null, '$all'
  containedIn:(col, value)->
    @set col, '$in', array
  notContainedIn:(col, array)->
    @set col, '$nin', array
  select:(col, query)->
    @set col, '$select', query:query
  inQuery:(col,query)->
    @set col, '$inQuery', where:query
  notInQuery:(col,query)->
    @set col, '$notInQuery', where:query
    
  _or:(queries...)->
    @__q['$or'] = (@__q['$or'] ?= []).concat RikkiTikki.Query.or queries
    
  relatedTo:(object, key)->
    throw new Error 'RikkiTikki.Query.$relatedTo required object be of Type RikkiTikki.Object' if !(object instanceof RikkiTikki.Object) and object.className?
    @set null, "$relatedTo", 
      object:
        __type: "Pointer"
        objectId: object.get 'objectId'
        className: object.className
      key:"#{key}"
  include:(value)->
    @set null, 'include', "#{value}"
  keys:(val)->
    @set null, 'keys', "#{value}"
  count:(value)->
    @set null, 'count', "#{value}"
  order:(value)->
    @set null, 'order', "#{value}"
  limit:(value)->
    @set null, 'limit', "#{value}"
  skip:(value)->
    @set null, 'skip', "#{value}"
  arrayKey:(col,value)->
    @set null, col, "#{value}"
RikkiTikki.Query.or = (queries...)->
  className = null
  _.each queries, (q)=>
    throw "All queries must be of the same class" if (className ?= q.className) != q.className
  _.map _.flatten(queries), (v,k)-> if v.query? then v.query() else v
#### _quote(string)
# > Implementation of Parse _quote to create RegExp from string value
RikkiTikki.Query._quote = (s)-> "\\Q#{s}\\E"
