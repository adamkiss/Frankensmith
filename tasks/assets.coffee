module.exports = (g, gp, config)->

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
    gp.remoteSrc 'assets/images/**/*?(jpg|jpeg|png|gif|svg)'
      .pipe gp.plumber()
      .pipe gp.changed 'public/assets/images', {cwd: config.site.path()}
      .pipe gp.imagemin config.gp.imagemin
      .pipe gp.remoteDest 'public/assets/images'

  ##
  # GALLERIES STUFF HERE
  ##