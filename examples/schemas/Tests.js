/*
 * Tests.js
 * Schema Generated by RikkiTikki
 * Add custom Schema Validators, Types and Methods below
 */
var API = require('../../lib');

var Tests = new API.Schema(
  API.extend(API.getSchemaTree('Tests'),
  {
    // place custom Schema Type overrides here
  })
);

/*
 * Virtual Getters/Setters
 */
Tests.virtuals = {
  
};

/*
 * Static Methods
 */
Tests.statics = {
  
};

/*
 * Custom Schema Validators
 */
Tests.validators = {
  
};

module.exports = API.model('Tests', Tests);