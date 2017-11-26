'use strict';

module.exports = function(app) {
	var todoList = require('../controllers/todoListController'),
	userHandlers = require('../controllers/userController.js');

	// todoList Routes
	app.route('/tasks')
		.get(userHandlers.loginRequired, todoList.list_all_tasks)
		.post(userHandlers.loginRequired, todoList.create_a_task);

	app.route('/tasks/:id')
		.get(userHandlers.loginRequired, todoList.read_a_task)
		.put(userHandlers.loginRequired, todoList.update_a_task)
		.delete(userHandlers.loginRequired, todoList.delete_a_task);

	app.route('/auth/register')
		.post(userHandlers.register);

	app.route('/auth/sign_in')
		.post(userHandlers.sign_in);
};
