{_}             = require 'lodash'
fs              = require 'fs'
path            = require 'path'
{should,expect} = require 'chai'
global._        = _
global.should   = should
global.expect   = expect
global.app_root = __dirname
should()

app = 
  ApiHero:
    proxyEvent: (name, delegator)->
      true

moduleConfig = modules:
  "apihero-module-mock":
    name:"something",
    boolValue: true 
ModuleManager = require '../src/classes/module/ModuleManager'
  
describe 'ModuleManager Test Suite', ->
  @modMan = new ModuleManager app, moduleConfig
    
  it 'should load modules', (done)=>
    @modMan.on 'ahero-modules-loaded', (modules)=>
      modules.length.should.be.above 0
      done()
    @modMan.load (e, res)=>
      
  it 'should list modules', =>
    list = @modMan.listModules()
    list.length.should.be.above 0
    
  it 'should retrieve a module', =>
    modName = _.keys(moduleConfig.modules)[0]
    mod     = @modMan.getModule modName
    mod.getApp.should.be.a 'function'
    
  it 'should get module options', =>
    modName = _.keys(moduleConfig.modules)[0]
    opts = @modMan.getModuleOptions modName
    opts.name.should.equal moduleConfig.modules[modName].name
    opts.boolValue.should.be[moduleConfig.modules[modName].boolValue]

  it 'should have saved module config to package file', =>
    pkg = require path.join app_root, 'package.json'
    pkg.apihero.should.exist
    pkg.apihero.modules.should.exist
    pkg.apihero.modules['apihero-module-mock'].should.exist
    
  after (done)=>
    package_path = path.join app_root, 'package.json'
    pkg = require package_path
    delete pkg.apihero if pkg.hasOwnProperty 'apihero'
    fs.writeFile package_path, (JSON.stringify pkg, null, 2), done
