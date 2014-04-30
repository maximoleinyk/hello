require.config({

    baseUrl: '/js',

    paths: {
        app: 'app',
        jquery: 'libs/jquery/dist/jquery',
        underscore: 'libs/underscore/underscore',
        backbone: 'libs/backbone/backbone',
        'backbone.wreqr': 'libs/backbone.wreqr/lib/amd/backbone.wreqr',
        'backbone.babysitter': 'libs/backbone.babysitter/lib/backbone.babysitter',
        marionette: 'libs/marionette/lib/core/amd/backbone.marionette',
        handlebars: 'libs/handlebars/handlebars',
        hbs: 'libs/requirejs-hbs/hbs',
        'rivets': 'libs/rivets/dist/rivets',
        cs: 'libs/require-cs/cs',
        'coffee-script': 'libs/coffee-script/extras/coffee-script',
        text: 'libs/requirejs-text/text',
        bootstrap: 'libs/bootstrap/dist/js/bootstrap',
        eventBus: 'etc/eventBus',
        'rivets-config': 'etc/rivets-config',
        'socket.io': 'libs/socket.io-client/dist/socket.io',
        io: 'etc/io'
    },

    shim: {
        jquery: {
            exports: '$'
        },
        underscore: {
            exports: '_'
        },
        backbone: {
            deps: ['underscore', 'jquery'],
            exports: 'Backbone'
        },
        'backbone.wreqr': {
            deps: ['backbone']
        },
        'backbone.babysitter': {
            deps: ['backbone']
        },
        marionette: {
            deps: ['backbone']
        },
        handlebars: {
            exports: 'Handlebars'
        },
        cs: {
            deps: ['coffee-script']
        },
        hbs: {
            deps: ['text', 'handlebars']
        },
        bootstrap: {
            deps: ['jquery']
        }
    },

    deps: [
        'bootstrap',
        'eventBus',
        'rivets-config',
        'io'
    ]

});

window.Hello || (window.Hello = {});
