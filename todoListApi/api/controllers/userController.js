'use strict';

var mongoose = require('mongoose'),
  jwt = require('jsonwebtoken'),
  bcrypt = require('bcrypt'),
  User = mongoose.model('User');

  exports.register = function(req, res) {
    try{  
      req.body = JSON.parse(Object.keys(req.body)[0])
    }catch(err){
      req.body = req.body
    }
    console.log(req.body);    
    var newUser = new User(req.body);
    newUser.hash_password = bcrypt.hashSync(req.body.password, 10);
    newUser.save(function(err, user) {
      if (err) {
        return res.status(400).send({
          message: 'Email ja cadastrado'
        });
      } else {
        user.hash_password = undefined;
        user.fullName = undefined;
        user.__v = undefined;
        user.fullName = "ToDoList"
        return res.json(user);
      }
    });
  };

exports.sign_in = function(req, res) {
  try{  
    req.body = JSON.parse(Object.keys(req.body)[0])
  }catch(err){
    req.body = req.body
  }
  User.findOne({
    email: req.body.email
  }, function(err, user) {
    if (err) throw err.message;
    if (!user || !user.comparePassword(req.body.password)) {
      return res.status(401).json({ message: 'Usuario ou senha invalidos' });
    }
    return res.json({ token: jwt.sign({ email: user.email, fullName: user.fullName, _id: user._id }, 'RESTFULAPIs') });
  });
};

exports.loginRequired = function(req, res, next) {
  if (req.user) {
    next();
  } else {
    return res.status(401).json({ message: 'Usuario não autorizado' });
  }
};
