module.exports = (g, gp, cfg)->

  scriptsJshintOptions =
    node: true
    esnext: true
    bitwise: true
    curly: true
    immed: true
    newcap: true
    noarg: true
    undef: true
    unused: 'vars'

  taskScripts = (build = false)->
    gp.remoteSrc 'assets/scripts/*.js'
      .pipe gp.plumber()
      .pipe gp.include()
      .pipe gp.uglify()

  g.task 'scripts:clean', ()->
    gp.remoteSrc 'public/assets/*.js', {read: false}
      .pipe gp.clean()

  # @TODO lint ONE file (changed)
  # ADD? (MAYBE OKAY?)
  g.task 'scripts:lint', ()->
    gp.remoteSrc ['assets/scripts/*.js', 'assets/scripts/src/*.js']
      .pipe gp.plumber()
      .pipe gp.jshint scriptsJshintOptions
      .pipe gp.jshint.reporter 'jshint-stylish'

  # TODO: DOESN'T WORK. MANIFEST TOGETHER
  g.task 'scripts:build', ['scripts:clean'], ()->
    taskScripts(true)
      .pipe gp.rev()
      .pipe gp.remoteDest 'public/assets'
      .pipe gp.rev.manifest 'manifest.json', {
        base: cfg.site.path('public/assets')
        cwd: cfg.site.path()
        merge: true
      }
      .pipe gp.remoteDest 'public/assets'

  g.task 'scripts:serve', ['scripts:lint'], ()->
    taskScripts()
      .pipe gp.remoteDest 'public/assets'
      .pipe gp.browserSync.stream()
