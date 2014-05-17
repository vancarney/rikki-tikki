class Collection extends Object
  constructor:(@__collection)->
  drop:->
    @__collection.drop()
  dropIndex:(name)->
    throw "can not drop index on _id field" if name == '_id'
    @__collection.dropIndex name
  dropIndexes:->
    @__collection.dropIndexes()
  find:(params)->
  insert:(data)->
  update:(data)->
  upsert:(data)->
  show:->
  destroy:(data)->