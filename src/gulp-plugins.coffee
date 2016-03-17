module.exports = (gulp, plugins, config)->

  # gulp.src wrapper for remote directory
  plugins.remoteSrc = (source_glob)->
    gulp.src source_glob, {cwd: config.site.path()}

  # gulp.dest wrapper as above
  plugins.remoteDest = (target_files)->
    gulp.dest target_files, {cwd: config.site.path()}

  # gulp.watch wrapper as above
  plugins.remoteWatch = (globs, tasks)->
    plugins.watch(globs, {
      cwd: config.site.path()
      read: false
      readDelay: 50
    }, tasks)

  plugins.del = require 'del'
  plugins.runSequence = require 'run-sequence'

  plugins.browserify      = require 'browserify'
  plugins.coffeeify       = require 'coffeeify'
  plugins.bundleCollapser = require 'bundle-collapser/plugin'

  plugins