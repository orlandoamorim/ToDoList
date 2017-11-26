'use strict';

var mongoose = require('mongoose'),
  Task = mongoose.model('Tasks');


exports.list_all_tasks = function(req, res) {
  Task.find({user: req.user}, function(err, task) {
    if (err)
      return res.send({
        message: err.message
      });
    res.json(task);
  });
};


exports.create_a_task = function(req, res) {
  try{  
    req.body = JSON.parse(Object.keys(req.body)[0])
  }catch(err){
    req.body = req.body
  }
  var new_task = new Task(req.body);
  new_task.user = req.user;
  new_task.save(function(err, task) {
    if (err)
      return res.send({
        message: err.message
      });
    res.json(task);
  });
};

exports.read_a_task = function(req, res) {
  Task.findById(req.params.id, function(err, task) {
    if (err)
      return res.send({
        message: err.message
      });
    res.json(task);
  });
};

exports.update_a_task = function(req, res) {
  try{  
    req.body = JSON.parse(Object.keys(req.body)[0])
  }catch(err){
    req.body = req.body
  }
  Task.findOneAndUpdate({_id:req.params.id}, req.body, {new: true}, function(err, task) {
    if (err)
      return res.send({
        message: err.message
      });
    res.json(task);
  });
};
// Task.remove({}).exec(function(){});
exports.delete_a_task = function(req, res) {

  Task.remove({
    _id: req.params.id
  }, function(err, task) {
    if (err)
      return res.send({
        message: err.message
      });
    res.json({ message: 'Task successfully deleted' });
  });
};
