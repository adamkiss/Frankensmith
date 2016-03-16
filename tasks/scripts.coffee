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
      .on 'error', (err)->
        console.log gp.prettyError.render err
        this.emit 'end'
      .pipe gp.plumber()
      .pipe gp.vinyl.source path.basename(entry)
      .pipe gp.vinyl.buffer()
      .pipe gp.rename { extname: '.js'}

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
    glob "source/assets/scripts/#{jsSource}.{js,coffee}", { cwd: config.site.path() }, (err, files)->
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


  #
  # Linting
  # create stream and return
  # were processed.
  #
  g.task 'scripts:lint', ['scripts:lint:all']
  g.task 'scripts:lint:all', ['scripts:lint:js', 'scripts:lint:coffee']

  gp.scriptsLintJs = (remoteSrcPath)->
    gp.remoteSrc(remoteSrcPath)
      .pipe gp.plumber()
      .pipe gp.jshint config.gp.jshint
      .pipe gp.jshint.reporter 'jshint-stylish'

  g.task 'scripts:lint:js', ()->
    lintSource = if gu.env.js? then gu.env.js else '*'
    gp.scriptsLintJs [
      "source/assets/scripts/#{gu.env.js}.js",
      'source/assets/scripts/src/*.js']

  gp.scriptsLintCoffee = (remoteSrcPath)->
    gp.remoteSrc(remoteSrcPath)
      .pipe gp.plumber()
      .pipe gp.coffeelint config.gp.coffeelint
      .pipe gp.coffeelint.reporter 'coffeelint-stylish'

  g.task 'scripts:lint:coffee', ()->
    lintSource = if gu.env.js? then gu.env.js else '*'
    gp.scriptsLintCoffee [
      "source/assets/scripts/#{gu.env.js}.{coffee,litcoffee}",
      'source/assets/scripts/src/*.{coffee,litcoffee}']

  g.task 'scripts:build', ['scripts:clean', 'scripts:vendor'], (done)->
    taskBrowserifyBuild(done, true)

  g.task 'scripts:serve', ['scripts:vendor'], (done)->
    taskBrowserifyBuild(done)

  g.task 'scripts:vendor', (done)->
    gp.remoteSrc 'source/assets/scripts/vendor/*.js'
      .pipe gp.plumber()
      .pipe gp.changed 'public/assets/vendor', {cwd: config.site.path()}
      .pipe gp.remoteDest 'public/assets/vendor'


  # Simple version for future ref.
  g.task 'scripts:browserify', ()->
    gp.browserify {
      basedir: config.site.path()
      entries: 'source/assets/scripts/app.js'
      extensions: '.coffee'
      debug: true
      transform: [gp.coffeeify]
    }
    .bundle()
    .pipe gp.vinyl.source './app.js'
    .pipe gp.vinyl.buffer()
    .pipe gp.jshint config.gp.jshint
    .pipe gp.jshint.reporter 'jshint-stylish'
    .pipe gp.remoteDest 'public/assets'