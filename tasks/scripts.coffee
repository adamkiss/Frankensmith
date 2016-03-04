##
# SCRIPTS
##

module.exports = (g, gp, config)->

  es = require 'event-stream'
  glob = require 'glob'

  gp.vinyl =
    source: require 'vinyl-source-stream'
    buffer: require 'vinyl-buffer'
  gp.utils =
    globby: require 'globby'
    through:require 'through2'

  taskScripts = (build = false)->
    gp.remoteSrc 'assets/scripts/*.js'
      .pipe gp.plumber()
      .pipe gp.include()
      .pipe gp.uglify()
      .pipe gp.remoteDest 'public/assets'

  g.task 'scripts:clean', ()->
    gp.remoteSrc 'public/assets/*.js', {read: false}
      .pipe gp.clean()

  # @TODO lint ONE file (changed)
  # @TODO lint coffeescript
  # ADD? (MAYBE OKAY?)
  g.task 'scripts:lint', ()->
    gp.remoteSrc ['assets/scripts/*.js', 'assets/scripts/src/*.js']
      .pipe gp.plumber()
      .pipe gp.jshint config.gp.jshint
      .pipe gp.jshint.reporter 'jshint-stylish'

  g.task 'scripts:build', ['scripts:clean'], ()->
    taskScripts(true)

  g.task 'scripts:serve', ['scripts:lint'], ()->
    taskScripts()
      .pipe gp.browserSync.stream()

  g.task 'scripts:browserify', ()->
    bundleStream = gp.utils.through()
      .pipe gp.plumber()
      .pipe gp.vinyl.source './app.js'
      # .pipe gp.vinyl.buffer()
      .pipe gp.remoteDest 'public/assets'

    gp.utils.globby ['assets/scripts/*.js'], { cwd: config.site.path() }
      .then (entries)->
        gp.browserify({
          basedir: config.site.path()
          entries: entries
          extensions: '.coffee'
          debug: true
          transform: [gp.coffeeify]
        }).bundle().pipe(bundleStream)
      .catch (err)->
        bundleStream.emit 'error', gp.notify.error(err)

    bundleStream

  # g.task 'scripts:browserify2', ()