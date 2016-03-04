module.exports = (gulp, plugins, config)->

  # gulp.src wrapper for remote directory
  plugins.remoteSrc = (source_glob)->
    gulp.src source_glob, {cwd: config.site.path()}

  # gulp.dest wrapper as above
  plugins.remoteDest = (target_files)->
    gulp.dest target_files, {cwd: config.site.path()}

  plugins.plumberNotify = ()->
    plugins.plumber {
      errorHandler: plugins.notify.onError "Error: <%= error.message %>"
    }

  plugins.PE = require 'pretty-error'

  plugins