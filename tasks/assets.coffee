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
    gp.remoteSec 'assets/images/**/*?(jpg|jpeg|png|gif|svg)'
      .pipe gp.plumber()
      .pipe gp.changed 'public/assets/images'
      .pipe gp.imagemin stylesImageMinOptions
      .pipe gp.remoteDest 'public/assets/images'

  ##
  # GALLERIES STUFF HERE
  ##

  ##
  # HASH LATEST STYLES & SCRIPTS
  ##
  g.task 'build:manifest', ['styles:build', 'scripts:build'], ()->
    gp.remoteSrc 'public/assets/*.?(js|css)'
      .pipe gp.hash()
      .pipe gp.remoteDest 'public/assets'
      .pipe gp.hash.manifest('assets-manifest.json')
      .pipe gp.remoteDest 'data'
