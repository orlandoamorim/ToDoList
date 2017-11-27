'use strict';


var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var TaskSchema = new Schema({
  name: {
    type: String,
    required: 'Name of the task'
  },
  user: {
    type: Schema.ObjectId
  },
  date: {
    type: Date,
    default: Date.now
  },
  created_at: {
    type: Date,
    default: Date.now
  },
  isCompleted: {
    type: Boolean,
    default: false
  },
  type: {
    type: String,
    enum: ['home', 'supermarket', 'work', 'college', 'school', 'others'],
    default: 'others'
  }
});


module.exports = mongoose.model('Tasks', TaskSchema);