##
# SCRIPTS
##

gu = require 'gulp-util'

module.exports = (g, gp, config)->

  path = require 'path'
  glob = require 'glob'

  gp.vinyl =
    source: require 'vinyl-source-stream'
    buffer: require 'vinyl-buffer'

  taskBrowserify = (entry, build = false)->
    gp.browserify {
      entries: entry
      basedir: config.site.path()
      debug: !build
      extensions: '.coffee'
      plugin: [gp.bundleCollapser]
      transform: [gp.coffeeify]
    }
      .bundle()
      .pipe gp.plumber()
      .pipe gp.vinyl.source path.basename(entry)
      .pipe gp.vinyl.buffer()

  #
  # This is abomination. Whatever
  # Streams don't work for me. (remote paths?). Run over
  # multiple files instead and emit done() when all files
  # were processed.
  #
  taskBrowserifyBuild = (done, build = false)->
    doneCount = 0
    beDoneIf = (match)->
      doneCount += 1
      if doneCount is match
        gp.browserSync.reload()
        done()

    jsSource = if !build && gu.env.js? then gu.env.js else '*'
    glob "source/assets/scripts/#{jsSource}.js", { cwd: config.site.path() }, (err, files)->
      done(err) if err

      files.forEach (entry)->
        if (build)
          taskBrowserify entry, true
            .pipe gp.uglify()
            .pipe gp.remoteDest 'public/assets'
            .on 'end', ()->
              beDoneIf files.length
        else
          taskBrowserify entry
            .pipe gp.remoteDest 'public/assets'
            .on 'end', ()->
              beDoneIf files.length

  g.task 'scripts:clean', ()->
    gp.remoteSrc 'public/assets/*.js', {read: false}
      .pipe gp.clean()

  # @TODO lint ONE file (changed)
  # @TODO lint coffeescript
  # ADD? (MAYBE OKAY?)
  g.task 'scripts:lint', ()->
    lintSource = if gu.env.js? then gu.env.js else '*'
    gp.remoteSrc ["source/assets/scripts/#{gu.env.js}.js" , 'source/assets/scripts/src/*.js']
      .pipe gp.plumber()
      .pipe gp.jshint config.gp.jshint
      .pipe gp.jshint.reporter 'jshint-stylish'

  g.task 'scripts:build', ['scripts:clean'], (done)->
    taskBrowserifyBuild(done, true)

  g.task 'scripts:serve', ['scripts:lint'], (done)->
    taskBrowserifyBuild(done)

  # Simple version for future ref.
  g.task 'scripts:browserify', ()->
    gp.browserify {
      basedir: config.site.path()
      entries: 'source/assets/scripts/app.js'
      extensions: '.coffee'
      # debug: true
      transform: [gp.coffeeify]
    }
    .bundle()
    .pipe gp.vinyl.source './app.js'
    .pipe gp.vinyl.buffer()
    .pipe gp.remoteDest 'public/assets'