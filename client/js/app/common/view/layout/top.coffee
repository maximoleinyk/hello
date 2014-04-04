define ['jquery', 'marionette', 'hbs!app/common/view/layout/top'], ($, Marionette, html) ->
	'use strict'

	Layout = Marionette.Layout.extend 

		el: '#app'
		template: html

		regions:
			content: '#content'

		appEvents:
			'layout:content': '_showContent'

		_showContent: (view) ->
			@content.show view
