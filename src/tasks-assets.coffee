module.exports = (g, gp, cfg)->

  ##
  # STYLES
  ##
  stylesSassOptions = {
    build:
      outputStyle:    'compressed'
      sourceComments:  false
      errLogToConsole: true
    serve:
      sourceMap:         true
      sourceMapContents: true
      sourceComments:   'none'
      errLogToConsole:   true
  }

  stylesImageMinOptions = {
    progressive: true
  }

  taskStyles = (build = false)->
    gp.remoteSrc 'assets/styles/*.scss'
      .pipe gp.plumber()
      .pipe gp.sass(stylesSassOptions[if build then 'build' else 'serve'])
      .pipe gp.autoprefixer ['last 2 versions', 'ie 8', 'ios 7', 'android 4']

  g.task 'styles:clean', ()->
    gp.remoteSrc 'public/assets/*.css', {read: false}
      .pipe gp.clean()

  g.task 'styles:build', ['styles:clean'], ()->
    taskStyles(true)
      .pipe gp.rev()
      .pipe gp.remoteDest 'public/assets'
      .pipe gp.rev.manifest 'manifest.json', {
        base: cfg.site.path('public/assets')
        merge: true
      }
      .pipe gp.remoteDest 'public/assets'

  g.task 'styles:serve', ()->
    taskStyles()
      .pipe gp.remoteDest 'public/assets'
      .pipe gp.browserSync.stream()

  ##
  # FONTS
  ##
  g.task 'fonts', ()->
    gp.remoteSrc 'assets/fonts/*.*'
      .pipe changed 'public/assets/fonts'
      .pipe gp.remoteDest 'public/assets/fonts'

  ##
  # IMAGES
  ##
  g.task 'images', ()->
    gp.remoteSec 'assets/images/**/*?(jpg|jpeg|png|gif|svg)'
      .pipe gp.plumber()
      .pipe gp.changed 'public/assets/images'
      .pipe gp.imagemin stylesImageMinOptions
      .pipe gp.remoteDest 'public/assets/images'
