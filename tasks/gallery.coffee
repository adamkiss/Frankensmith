##
# SCRIPTS
##

module.exports = (g, gp, cfg)->

  fs   = require 'fs'
  path = require 'path'
  glob = require 'glob'

  class Directory
    @id
    @src
    @files
    @thumbSuffix
    constructor: (directory_path, config)->
      @src = directory_path
      @id = path.parse(directory_path).base
      @setSuffix config

    setSuffix: (config)->
      @thumbSuffix = config().gallerySettings['**/*'][0].rename.suffix

    jsonForFile: (file)->
      parsed = path.parse file
      {}=
        src: parsed.base
        thumb: [parsed.name, @thumbSuffix, parsed.ext].join ''

    getJsonFilename: ()->
      "gallery-#{@id}.json"

    getJson: ()->
      @files = (@jsonForFile file for file in glob.sync path.join @src, '*.{jpg,jpeg,png}')
      JSON.stringify @files

  g.task 'gallery:optimize', ()->
    gp.remoteSrc 'assets/galleries/**/*.{jpg,jpeg,png}'
      .pipe gp.imagemin { progressive: true }
      .pipe gp.remoteDest 'public/assets/galleries'
      .pipe gp.responsive cfg.fs.gallerySettings
      .pipe gp.remoteDest 'public/assets/galleries'

  g.task 'gallery:jsonize', ()->
    glob.sync(cfg.site.path 'assets/galleries/*/').forEach (directory)->
      gallery = new Directory directory, cfg.fs
      fs.writeFileSync(
        cfg.site.path("data/#{gallery.getJsonFilename()}"),
        gallery.getJson(), 'utf8'
      )
