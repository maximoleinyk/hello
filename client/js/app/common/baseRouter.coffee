define ['marionette', 'cs!app/common/view/notFound/top'], (Marionette, NotFound) ->

	Marionette.AppRouter.extend

		routes: 
			'*404': 'notFound'

		notFound: ->
			@eventBus.trigger 'show:page', new NotFound