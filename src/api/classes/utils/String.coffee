Str = {}
Str.capitalize = (string)->
  "#{string.charAt(0).toUpperCase()}#{string.slice(1)}"
Str.stripNull = (string)->
  string.replace /\0/g, ''
module.exports = Str