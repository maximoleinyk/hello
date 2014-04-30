define ['cs!app/common/baseController', 'cs!app/landing/view/dashboard/top'], (BaseController, LandingPage) ->
  'use strict'

  BaseController.extend

    index: ->
      @eventBus.trigger 'display:content', new LandingPage
