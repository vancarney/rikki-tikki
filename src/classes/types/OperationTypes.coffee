module.exports = 
  query:[
    # coparison operators
    '$gt', '$gte', '$in', '$lt', '$lte', '$ne', '$nin',
    # logical operators
    '$and', '$or', '$not', '$nor', 
    # elemental operators
    '$exists', '$type', 
    # evaluation operators
    '$mod', '$regex', '$where', 
    # geospatial operators
    '$geoWithin', '$geoIntersects', '$near', '$nearSphere',
    # array operators
    '$all', '$elemMatch', '$size',
    # projection operators
    '$', '$elemMatch', '$slice'
  ]
  update:[
    # field operators
    '$inc', '$rename', '$setOnInsert', '$set', '$unset',
    # array operators
    '$', '$addToSet', '$pop', '$pullAll', '$pull', '$pushAll', '$push',
    # operation modifiers
    '$each', '$slice', '$sort'
    # bitwaise operators
    '$bit',
    # Isolation operators
    '$isolated'
  ]
  aggregate:[
    # pipeline operators
    '$project', '$match', '$limit', '$skip', '$unwind', '$group', '$sort', '$geoNear',
    # $group operators
    '$addToSet', '$first', '$last', '$max', '$min', '$avg', '$push', '$sum',
    # boolean operators
    '$and', '$or', '$not',
    # comparison operators
    '$cmp', '$eq', '$gt', '$gte', '$lt', '$lte', '$ne',
    # arithmetic operators
    '$add', '$divide', '$mod', '$multiply', '$subtract',
    # string operators
    '$concat', '$strcasecmp', '$substr', '$toLower', '$toUpper',
    # date operators
    '$dayOfYear', '$dayOfMonth', '$dayOfWeek', '$year', '$month', '$week', '$hour', '$minute', '$second', '$millisecond',
    # conditional operators
    '$cond', '$ifNull'
  ]
  query_modifiers:[
    '$comment', '$explain', '$hint', '$maxScan', '$max', '$min', '$orderby', '$returnKey', '$showDiskLoc', '$snapshot', '$query',
    # sort operators
    '$natural'
  ]