##
# BUILD RELATED
##
module.exports = (g, gp, config)->

  _ = require 'lodash'

  ##
  # HASH LATEST STYLES & SCRIPTS
  ##
  g.task 'build:manifest', ['styles:build', 'scripts:build', 'images'], ()->
    gp.remoteSrc 'public/assets/*.?(js|css)'
      .pipe gp.hash()
      .pipe gp.remoteDest 'public/assets'
      .pipe gp.hash.manifest('assets-manifest.json')
      .pipe gp.remoteDest 'source/data'

  g.task 'build:manifest-clean', ['build:manifest'], ()->
    fs = require 'fs'
    fs.readFile config.site.path('source/data/assets-manifest.json'), 'utf8', (err, data)->
      throw err if err?

      manifest = JSON.parse data
      manifiles = _.map Object.keys(manifest), (file)->
        "public/assets/#{file}"

      gp.remoteSrc manifiles, {read: false}
        .pipe gp.clean()

