/*
 * Created10.js
 * Schema Generated by RikkiTikki
 * Add custom Schema Validators, Types and Methods below
 */
var API = require('rikki-tikki');

var Created10 = new API.Schema(
  API.extend(API.getSchemaTree('Created10'),
  {
    // place custom Schema Type overrides here
  })
);

/*
 * Virtual Getters/Setters
 */
Created10.virtuals = {
  
};

/*
 * Static Methods
 */
Created10.statics = {
  
};

/*
 * Custom Schema Validators
 */
Created10.validators = {
  
};

module.exports = API.model('Created10', Created10);