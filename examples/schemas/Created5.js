/*
 * Created5.js
 * Schema Generated by RikkiTikki
 * Add custom Schema Validators, Types and Methods below
 */
var API = require('rikki-tikki');

var Created5 = new API.Schema(
  API.extend(API.getSchemaTree('Created5'),
  {
    // place custom Schema Type overrides here
  })
);

/*
 * Virtual Getters/Setters
 */
Created5.virtuals = {
  
};

/*
 * Static Methods
 */
Created5.statics = {
  
};

/*
 * Custom Schema Validators
 */
Created5.validators = {
  
};

module.exports = API.model('Created5', Created5);