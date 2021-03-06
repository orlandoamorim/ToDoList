var express = require('express'),
app = express(),
port = process.env.PORT || 3000,
mongoose = require('mongoose'),
Task = require('./api/models/todoListModel'),
User = require('./api/models/userModel'),
bodyParser = require('body-parser'),
jsonwebtoken = require("jsonwebtoken");

// mongoose instance connection url connection
mongoose.Promise = global.Promise; //async operations
mongoose.connect('mongodb://localhost/Tododb');


app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

app.use(function(req, res, next) {
if (req.headers && req.headers.authorization && req.headers.authorization.split(' ')[0] === 'JWT') {
  jsonwebtoken.verify(req.headers.authorization.split(' ')[1], 'RESTFULAPIs', function(err, decode) {
    if (err) req.user = undefined;
    req.user = decode;
    next();
  });
} else {
  req.user = undefined;
  next();
}
});
var routes = require('./api/routes/todoListRoutes'); //importing route
routes(app); //register the route

app.use(function(req, res) {
  res.status(404).send({ url: req.originalUrl + ' not found' })
});

app.listen(port);

console.log('todo list RESTful API server started on: ' + port);

module.exports = app;
