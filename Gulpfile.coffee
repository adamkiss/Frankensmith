'use strict'

gulp        = require 'gulp'
config      = require('./src/config')()
plugins     = require('gulp-load-plugins')()
plugins     = require('./src/plugins')(gulp, plugins, config)

# smith:      require('./src/tasks-metalsmith')(gulp, plugins, config)
require('./tasks/serversync')(gulp, plugins, config)
require('./tasks/scripts')(gulp, plugins, config)
require('./tasks/styles')(gulp, plugins, config)
require('./tasks/assets')(gulp, plugins, config)
require('./tasks/build')(gulp, plugins, config)

gulp.task 'default', ()->
  # SERVE