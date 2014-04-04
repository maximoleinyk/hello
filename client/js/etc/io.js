define(['socket.io'], function(io) {
	'use strict';

	var socket = io.connect('http://localhost:8081');

		socket.on('connect', function () {
			socket.on('client', function(data) {
				console.log(data);
				socket.emit('server', {mesage: 'Hello from client!'});
			});
		});
});
