##
# BUILD RELATED
##
module.exports = (g, gp, config)->

  ##
  # HASH LATEST STYLES & SCRIPTS
  ##
  g.task 'build:manifest', ['styles:build', 'scripts:build'], ()->
    gp.remoteSrc 'public/assets/*.?(js|css)'
      .pipe gp.hash()
      .pipe gp.remoteDest 'public/assets'
      .pipe gp.hash.manifest('assets-manifest.json')
      .pipe gp.remoteDest 'data'

  g.task 'build:manifest-clean', ['build:manifest'], ()->
    fs = require 'fs'
    fs.readFile config.site.path('data/assets-manifest.json'), 'utf8'. (err, data)->
      throw err if err?

      manifest = JSON.parse data
      console.log Object.keys manifest