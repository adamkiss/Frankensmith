'use strict'

pe = require('./src/pretty-error')()

gulp        = require 'gulp'
config      = require('./src/config')()
plugins     = require('gulp-load-plugins')()
plugins     = require('./src/gulp-plugins')(gulp, plugins, config)
plugins.prettyError = pe

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

gulp.task 'serve:startup', ()->
  plugins.runSequence 'styles:serve', 'scripts:serve', 'images', 'fonts', 'serve:reload-site'

gulp.task 'serve:watch', ['connect-sync'], ()->
  watchers =
    styles:  plugins.remoteWatch(
      'source/assets/styles/**/*.?(sass|scss|css)'
      ()-> plugins.runSequence 'styles:serve'
    )
    scripts: plugins.remoteWatch(
      'source/assets/scripts/**/*.?(coffee|js)'
      ()-> plugins.runSequence 'scripts:serve'
    )
    images:  plugins.remoteWatch(
      'source/assets/images/**/*.?(jpg|jpeg|png|gif|svg)'
      ()-> plugins.runSequence 'images'
    )
    source:  plugins.remoteWatch(
      ['source/{data,layouts,site}/**/*.*', 'include/**/*.php']
      ()-> plugins.runSequence 'serve:reload-site'
    )
  watchers.scripts.on 'change', (file)->
    lintTarget = file.replace config.site.path()+'/', ''
    if lintTarget.endsWith '.js'
      plugins.scriptsLintJs lintTarget
    else
      plugins.scriptsLintCoffee lintTarget

gulp.task 'serve', ['serve:startup', 'serve:watch']


gulp.task 'build', ['metalsmith:build']
gulp.task 'build:all', ()->
  plugins.runSequence 'build:manifest-clean', 'metalsmith:build'

gulp.task 'default', ['serve']