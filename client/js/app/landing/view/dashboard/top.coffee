define ['marionette', 'hbs!app/landing/view/dashboard/top'], (Marionette, html) ->
  Marionette.ItemView.extend
    template: html
    className: 'dashboard'

    ui:
      $hello: '.js-hello'

    onRender: ->
      animate = =>
        @ui.$hello.css({
          opacity: 0
          marginTop: 0
        }).removeClass('hide').animate
          duration: 100,
          easing: 'easeOutQuint'
          opacity: 1
          'margin-top': '20px'
      setTimeout animate, 250