{_}             = require 'lodash'
path            = require 'path'
{should,expect} = require 'chai'
global._        = _
global.should   = should
global.expect   = expect
global.api_options  = require '../lib/classes/config/APIOptions'
should()

#require './objects'