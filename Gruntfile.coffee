module.exports = (grunt) ->
  grunt.initConfig

    pkg: grunt.file.readJSON('package.json')

    clean:
      dist: 'dist'
      temp: 'temp'

    eslint:
      target:
        src: ['src/client/js/app/**/*.js', 'src/client/js/etc/**/*.js']
      options:
        config: 'eslint.json'

    less:
      compile:
        options:
          cleancss: true
          modifyVars:
            'img-path': '"../img/"'
            'icon-font-path': '"../fonts/"'
            'fa-font-path': '"../fonts/"'
        files:
          'src/client/css/main.css': 'src/client/css/main.less'

    coffee:
      compile:
        expand: true
        flatten: false
        ext: '.js'
        src: 'temp/js/app/**/*.coffee'

    watch:
      coffee:
        files: ['src/client/js/app/**/*.coffee']
        tasks: ['coffee']
        options:
          spawn: false
          livereload: true
      less:
        files: ['src/client/css/**/*.less']
        tasks: ['less']
        options:
          livereload: true
      validate:
        files: ['src/client/js/**/*.js']
        tasks: ['validate']

    copy:
      misc:
        files: [
          {
            expand: true
            src: ['**/robots.txt']
            cwd: 'src/client'
            dest: 'dist/client'
          }
          {
            expand: true
            src: ['**/sitemap.xml']
            cwd: 'src/client'
            dest: 'dist/client'
          }
        ]
      ect:
        files: [
          {
            expand: true
            src: ['**']
            cwd: 'temp/server'
            dest: 'dist/server'
          }
        ]
      temp:
        files: [
          {
            expand: true
            src: ['**']
            cwd: 'src/client/js'
            dest: 'temp/js'
          }
          {
            expand: true
            src: ['**']
            cwd: 'src/server/views'
            dest: 'temp/server'
          }
        ]
      css:
        files: [
          {
            expand: true
            src: ['**']
            cwd: 'src/client/img'
            dest: 'dist/client/img'
          }
          {
            expand: true
            src: ['**']
            cwd: 'src/client/fonts'
            dest: 'dist/client/fonts'
          }
          {
            expand: true
            src: ['**/main.css']
            cwd: 'src/client/css'
            dest: 'dist/client/css'
          }
        ]
      js:
        files: [
          {
            expand: true
            src: ['**/require.js']
            cwd: 'temp/built/js/libs/requirejs'
            dest: 'dist/client/js'
          }
          {
            expand: true
            src: ['**/config.js']
            cwd: 'temp/built/js'
            dest: 'dist/client/js/app'
          },
          {
            expand: true
            src: [
              '**/landing/main.js'
            ]
            cwd: 'temp/built/js/app'
            dest: 'dist/client/js/app'
          }
        ]
    replace:
      cs:
        src: 'temp/js/app/**/*.js'
        overwrite: true
        replacements: [
          {
            from: /'cs!/gi
            to: '\''
          }
        ]
      html:
        src: 'temp/server/index.ect'
        dest: 'temp/server/index.ect'
        replacements: [
          {
            from: 'cs!'
            to: ''
          }
          {
            from: 'src="/js/libs/requirejs/require.js"'
            to: 'src="/js/require.js"'
          }
          {
            from: '/js/config.js'
            to: '/js/app/config.js'
          }
        ]

    requirejs:
      app:
        options:
          appDir: 'temp/js'
          baseUrl: './'
          dir: 'temp/built/js/'
          mainConfigFile: 'temp/js/config.js'
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
      compile:
        files:
          'dist/client/js/require.js': 'dist/client/js/require.js'
          'dist/client/js/app/config.js': 'dist/client/js/app/config.js'
          'dist/client/js/app/landing/main.js': 'dist/client/js/app/landing/main.js'

    mochaTest:
      test:
        options:
          reporter: 'spec'
        src: ['test/**/*.js']

  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-text-replace'
  grunt.loadNpmTasks 'grunt-eslint'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-contrib-requirejs'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-mocha-test'

  grunt.registerTask 'validate', ['eslint']
  grunt.registerTask 'build', ['copy:temp', 'coffee', 'less', 'replace', 'requirejs']
  grunt.registerTask 'dist', ['copy:ect', 'copy:css', 'copy:js', 'copy:misc']
  grunt.registerTask 'optimize', ['uglify', 'clean:temp']

  grunt.registerTask 'test', ['mochaTest']
  grunt.registerTask 'default', ['clean', 'validate', 'build', 'dist', 'optimize']






