Schema = require '../src/classes/schema/Schema'
 
describe 'Schema Test Suite', ->
  it 'should initialize from params', =>
    (@schema = new Schema).set
      name: 'Test'
      plural: 'Tests'
      options:
        idInjection: true
      properties:
        field1:
          type: 'String'
          required: false
        field2:
          type: 'Number'
          required: false
    (@schema.get 'plural').should.equal 'Tests'
    (typeof (_opts = @schema.get 'options') == 'object').should.be.true
    (_opts.get 'idInjection').should.be.true
    (@schema.getOption 'idInjection').should.be.true
    (@schema.getProperty 'field1').get('type').should.eq 'String'
    (@schema.getProperty 'field1').get('required').should.be.false
  it 'should render toSource', =>
    @schema.__template = """
      name: <%=name%>
      schema: <%=schema%>
      ns: <%=ns%>
      api_path: <%=api_path%>
    """
    @schema.toSource(true).should.not.eq "// template was undefined"
    