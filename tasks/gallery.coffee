##
# SCRIPTS
##

module.exports = (g, gp, cfg)->

  path = require 'path'
  glob = require 'glob'

  g.task 'gallery:optimize', ()->
    gp.remoteSrc 'assets/galleries/**/*.{jpg,jpeg,png}'
      .pipe gp.imagemin { progressive: true }
      .pipe gp.remoteDest 'public/assets/galleries'
      .pipe gp.responsive cfg.fs.gallerySettings
      .pipe gp.remoteDest 'public/assets/galleries'

  g.task 'gallery:jsonize', ()->
    glob.sync(cfg.site.path 'assets/galleries/*/').forEach (directory)->
      console.log directory