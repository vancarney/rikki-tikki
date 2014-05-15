fs              = require 'fs'
child_process   = require 'child_process'
(chai           = require 'chai').should()
_               = (require 'underscore')._
Backbone        = require 'backbone'
Backbone.$      = require( 'jQuery')
RikkiTikki      = require('../lib/client').RikkiTikki
RikkiTikki.API_URL = "http://0.0.0.0:3006/api/1"
#child_process   = require 'child_process'
#proc            = child_process.spawn 'node', ['./scripts/server']

# myNS.createSchema 'Products', name:String, description:String, price:Number


