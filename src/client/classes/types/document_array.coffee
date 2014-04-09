class RikkiTikki.DocumentArray extends RikkiTikki.Array
    constructor:->
      if doc
        doc.on 'save', arr.notify 'save'
        doc.on 'isNew', arr.notify 'isNew'