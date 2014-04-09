class RikkiTikki.Array extends Array
  _atomics: {}
  validators: []
  _path: null
  _parent: null
  _schema: null
  valueOf:-> @slice.apply @
  constructor:(values=[], @_path, doc)->
    @push.apply @, values
    if (doc)
      @_parent = doc
      @_schema = doc.schema.path path
