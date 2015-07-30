# # just a scratchpad for an idea...
# class ResultsOps
  # operateOnResults: (op, data, callback) ->
    # if callback == null or typeof callback != 'function'
      # throw 'callback required'
    # # tests for Object as op argument
    # if op == null or typeof op != 'object'
      # return callback('operation object was invalid')
    # # defines missing and fields Arrays
    # missing = undefined
    # fields = [
      # 'fieldName'
      # 'opType'
      # 'dataType'
      # 'call'
    # ]
    # # tests to ensure all required fields exist in object
    # if (missing = _.difference fields, _.keys op ).length > 0
      # return callback "operation object was missing required parameter '#{missing[0]}'"
#   
    # doOp = (op, record, callback) ->
      # # console.log(arguments);
      # if op.opType == 'append' and record.hasOwnProperty(op.fieldName)
        # return callback(null, record)
      # # derives callee method based on `on` parameter or from `helpers` object
      # _callee = if op.call.hasOwnProperty('on') then record[op.call.on] or null else global.helpers or {}
      # # returns with callback if `on` parameter is defined and _callee unset
      # if op.call.hasOwnProperty('on') and _callee == null
        # return callback(null, record)
      # # resets _callee with value of function if _callee is function
      # if typeof _callee == 'function'
        # _callee = _callee()
      # # tests _callee for method reference
      # if _callee.hasOwnProperty(op.call.method)
        # # tests if method reference is a function
        # if typeof _callee[op.call.method] == 'function'
          # # tests if call settings has a `with` parameter defined
          # if op.call.hasOwnProperty('with')
            # # obtains Array of values from record values
            # _with = _.map(op.call['with'], (col) ->
              # record[col]
            # )
            # # invokes method with arguments passed from  values in `with`
            # record.__data[op.fieldName] = _callee[op.call.method].apply(_callee, _with)
            # # returns with callback
            # return callback(null, record)
          # # invokes mthod directly with no arguments
          # record.__data[op.fieldName] = _callee[op.call.method].call(_callee)
          # # returns with callback
          # return callback(null, record)
        # # sets directly with value of method parameter
        # record.__data[op.fieldName] = _callee[op.call.method]
        # # returns with callback
        # return callback(null, record)
      # # attempts to set with default value
      # if op.hasOwnProperty('default')
        # record.__data[op.fieldName] = op['default']
        # # returns with callback
        # return callback(null, record)
      # # sets field to null as fallback
      # record.__data[op.fieldName] = null
      # # returns with callback
      # callback null, record
#   
    # # tests if dataset is array
    # if _.isArray(data)
      # # handles callbacks  to emit only after completed
      # done = _.after(data.length, callback)
      # _.each data, (record) ->
        # # invokes doOp for each record
        # doOp op, record, done
        # return
    # else
      # # invokes doOp for result
      # doOp op, data, ->
        # callback null
        # return
    # return
#   
# if c_query.hasOwnProperty("operations")
#   
  # # tests if operations parameter is of type Array
#   
  # # transforms operations parameter fr om Object to Array
  # c_query.operations = [ c_query.operations ]  unless _.isArray(c_query.operations)
  # done = _.after(c_query.operations.length, ->
    # callback null, o
  # )
  # _.each c_query.operations, (op) ->
    # operateOnResults op, o[elName], done
    
# # config...
  # "operations":[
    # {
      # "fieldName":"tracksCount",
      # "opType":"add",
      # "dataType":"int",
      # "call": {
        # "method":"length",
        # "on":"tracks"
      # },
      # "default":0
    # },
    # {
      # "fieldName":"createdAgo",
      # "opType":"add",
      # "dataType":"string",
      # "call": {
        # "method":"fromNow",
        # "with":["created"]
      # },
      # "default":"just now"
    # }
    # ]