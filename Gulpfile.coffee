'use strict'

require './src/pretty-error'

gulp        = require 'gulp'
config      = require('./src/config')()
plugins     = require('gulp-load-plugins')()
plugins     = require('./src/gulp-plugins')(gulp, plugins, config)

require('./tasks/metalsmith')(gulp, plugins, config)
require('./tasks/serversync')(gulp, plugins, config)
require('./tasks/scripts')(gulp, plugins, config)
require('./tasks/styles')(gulp, plugins, config)
require('./tasks/assets')(gulp, plugins, config)
require('./tasks/build')(gulp, plugins, config)
require('./tasks/gallery')(gulp, plugins, config)

gulp.task 'serve:reload', ()->
  plugins.browserSync.reload()

gulp.task 'serve:reload-site', ['metalsmith:serve'], ()->
  gulp.task 'serve:reload'

gulp.task 'serve', ['connect-sync'], ()->
  plugins.remoteWatch 'assets/styles/**/*.?(scss|css)', ['styles:serve']
  plugins.remoteWatch 'assets/scripts/**/*.js', ['scripts:serve']
  plugins.remoteWatch 'assets/images/**/*.?(jpg|jpeg|png|gif|svg)', ['images']
  plugins.remoteWatch '{data,partials,source}/**/*', ['serve:reload-site']

gulp.task 'build', ['metalsmith:build']
gulp.task 'build:all', ()->
  plugins.runSequence 'build:manifest-clean', 'metalsmith:build'


gulp.task 'default', ['serve']