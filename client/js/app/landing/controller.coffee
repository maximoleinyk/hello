define ['marionette', 'cs!app/landing/view/dashboard/top'], (Marionette, LandingPage) ->
	'use strict'

	Marionette.Controller.extend
		index: -> 
			@eventBus.trigger 'layout:content', new LandingPage
