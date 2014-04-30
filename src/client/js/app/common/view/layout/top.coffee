define ['marionette', 'hbs!app/common/view/layout/top'], (Marionette, html) ->
  'use strict'

  Marionette.Layout.extend

    el: '#app'
    template: html

    regions:
      content: '#content'

    appEvents:
      'display:content': '_showContent'

    _showContent: (view) ->
      @content.show view
