define [
	'backbone'
	'cs!app/common/baseRouter'
	'cs!app/landing/controller'
	'cs!app/common/app'
], (Backbone, BaseRouter, Controller, app) ->
	'use strict'

	Router = BaseRouter.extend
		routes:
			'': 'index'

	app.addInitializer (options) ->
		new Router 
			controller: new Controller options

		Backbone.history.start
			root: '/'
			pushState: true
