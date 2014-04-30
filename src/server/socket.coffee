
module.exports = (app) ->

	server = require("http").createServer app
	io = require("socket.io").listen server

	server.listen 8081

	io.sockets.on "connection", (socket) ->
		socket.emit('client', { message:'Hello from server!' });
		socket.on "server", (data) ->
			socket.broadcast.emit "message", data
