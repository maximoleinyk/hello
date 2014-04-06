module.exports = (grunt) ->
  grunt.initConfig

    pkg: grunt.file.readJSON('package.json')

    clean:
      dist: './dist/'
      temp: './temp/'

    eslint:
      target:
        src: ['./client/js/app/**/*.js', './client/js/etc/**/*.js']
      options:
        config: 'eslint.json'

    less:
      dev:
        options:
          cleancss: false
          modifyVars:
            'img-path': '"../img/"'
            'icon-font-path': '"../fonts/"'
        files:
          './client/css/main.css': './client/css/main.less'
      prod:
        options:
          cleancss: true
          modifyVars:
            'img-path': '"../img/"'
            'icon-font-path': '"../fonts/"'
        files:
          './dist/css/main.css': './client/css/main.less'

    coffee:
      dev:
        expand: true
        flatten: false
        ext: '.js'
        src: './temp/js/app/**/*.coffee'
      prod:
        expand: true
        flatten: false
        ext: '.js'
        src: './temp/js/app/**/*.coffee'

    watch:
      coffee:
        files: ['./client/js/app/**/*.coffee']
        tasks: ['coffee']
        options:
          spawn: false
          livereload: true
      less:
        files: ['./client/css/**/*.less']
        tasks: ['less:dev']
        options:
          livereload: true
      validate:
        files: ['./client/js/**/*.js']
        tasks: ['validate']

    copy:
      js:
        files: [
          {
            expand: true
            src: ['**']
            cwd: './client/js'
            dest: './temp/js'
          }
        ]
      css:
        files: [
          {
            expand: true
            src: ['**']
            cwd: './client/img'
            dest: './dist/img/'
          },
          {
            expand: true
            src: ['**']
            cwd: './client/fonts'
            dest: './dist/fonts/'
          }
        ]
      require:
        files: [
          {
            expand: true
            src: ['**/require.js']
            cwd: './client/js/libs/requirejs/'
            dest: './dist/js/'
          }
        ]
      config:
        files: [
          {
            expand: true
            src: ['**/config.js']
            cwd: './temp/built/js/'
            dest: './dist/js/app'
          }
        ]
      modules:
        files: [
          {
            expand: true
            src: ['**/landing/main.js']
            cwd: './temp/built/js/app'
            dest: './dist/js/app/'
          }
        ]

    replace:
      cs:
        src: './temp/js/app/**/*.js'
        overwrite: true
        replacements: [
          {
            from: /'cs!/gi
            to: '\''
          }
        ]
      html:
        src: './views/layout.ect'
        dest: './views/index.ect'
        replacements: [
          {
            from: 'src="/js/libs/requirejs/require.js"'
            to: 'src="/js/require.js"'
          }
          {
            from: '/js/config.js'
            to: '/js/app/config.js'
          }
          {
            from: 'cs!'
            to: ''
          }
        ]

    requirejs:
      app:
        options:
          appDir: './temp/js/'
          baseUrl: './'
          dir: './temp/built/js/'
          mainConfigFile: './temp/js/config.js'
          optimize: 'none'
          fileExclusionRegExp: /\.css/
          modules: [
            {
              name: 'config'
              include: [
                'jquery'
                'underscore'
                'backbone'
                'backbone.wreqr'
                'backbone.babysitter'
                'marionette'
                'handlebars'
                'hbs'
                'socket.io'
                'rivets'
                'text'
              ]
            },
            {
              name: 'app/landing/main'
              exclude: [
                'config'
              ]
            }
          ]

    uglify:
      production:
        files:
          './dist/js/require.js': './dist/js/require.js'
          './dist/js/app/config.js': './dist/js/app/config.js'
          './dist/js/app/landing/main.js': './dist/js/app/landing/main.js'

  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-text-replace'
  grunt.loadNpmTasks 'grunt-eslint'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-contrib-requirejs'
  grunt.loadNpmTasks 'grunt-contrib-uglify'

  grunt.registerTask 'validate', ['eslint']
  grunt.registerTask 'precompile', ['copy:js', 'less', 'coffee:prod', 'replace:cs']
  grunt.registerTask 'build', ['requirejs', 'replace:html', 'copy:css', 'copy:require', 'copy:config', 'copy:modules']
  grunt.registerTask 'optimize', ['uglify']

  grunt.registerTask 'default', ['clean', 'validate', 'precompile', 'build', 'optimize', 'clean:temp']






