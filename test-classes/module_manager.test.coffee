moduleConfig = modules:
  "apihero-module-mock":
    name:"something",
    boolValue: true

describe 'ModuleManager Test Suite', ->
  before =>
    _.each _.keys(require.cache), (name)=>
      delete require.cache[name] if name.match /apihero\-module\-mock/
      
    ModuleManager = require '../src/classes/module/ModuleManager'
    @modMan = new ModuleManager app, moduleConfig
    
  it 'should load modules', (done)=>
    @modMan.on 'ahero-modules-loaded', (modules)=>
      modules.length.should.be.above 0
      done()
    @modMan.load (e, res)=>
      expect(e).to.be.null
      
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
