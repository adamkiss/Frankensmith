##
# SCRIPTS
##

module.exports = (g, gp, config)->

  path = require 'path'
  glob = require 'glob'

  gp.vinyl =
    source: require 'vinyl-source-stream'
    buffer: require 'vinyl-buffer'

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

  #
  # This is abomination. Whatever
  # Streams don't work for me. (remote paths?). Run over
  # multiple files instead and emit done() when all files
  # were processed.
  #
  g.task 'scripts:browserify-multiple', (done)->

    doneCount = 0
    beDoneIf = (match)->
      doneCount += 1
      done() if doneCount is match

    glob 'assets/scripts/*.js', { cwd: config.site.path() }, (err, files)->
      done(err) if err

      files.forEach (entry)->
        stream = gp.browserify {
          basedir: config.site.path()
          entries: entry
          extensions: '.coffee'
          # debug: true
          plugin: [gp.bundleCollapser]
          transform: [gp.coffeeify]
        }
        .bundle()
        .pipe gp.plumber()
        .pipe gp.vinyl.source path.basename(entry)
        .pipe gp.vinyl.buffer()
        .pipe gp.uglify()
        .pipe gp.remoteDest 'public/assets'
        .on 'end', ()->
          beDoneIf files.length

        true

  g.task 'scripts:browserify', ()->
    gp.browserify {
      basedir: config.site.path()
      entries: 'assets/scripts/app.js'
      extensions: '.coffee'
      # debug: true
      transform: [gp.coffeeify]
    }
    .bundle()
    .pipe gp.vinyl.source './app.js'
    .pipe gp.vinyl.buffer()
    .pipe gp.remoteDest 'public/assets'