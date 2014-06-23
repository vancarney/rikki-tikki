class AuthAdapter extends Object
  constructor:(module, config, callback)->
    try
      # attempts to obtain authentication module
      _m = require module
    catch e
      # invokes callback if module could not be loaded
      callback? e, null if e?
    # tests if module is present and is a function
    if _m and typeof _m is 'function'
      # returns Passport Authentication handler method
      return =>
        # detects and removed callback in arguments
        _cB = arguments.pop() if typeof arguments[arguments.length - 1] is 'function'
        # pushes new callback into arguments wrapping passed callback 
        arguments.push (e,done)=>
          _cB?  e, done
        # invokes handler with modified arguments
        _m.apply @, arguments
    else
      # invokes callback with error if could not obtain handler function
      callback? "#{module} was not exported properly", null
    
