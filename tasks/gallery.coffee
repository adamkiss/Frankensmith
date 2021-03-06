##
# SCRIPTS
##

# chm    = require '../src/charmap'
# String.prototype.getUrlFormat = ()->
#   Array.prototype.map.call this, (char)->
#     chm[char.charCodeAt 0] || char
#   .join('').toLowerCase().replace /[^a-z0-9-_\.]+/g, '-'

module.exports = (g, gp, cfg)->
  fs        = require 'fs'
  chm       = require '../src/charmap'
  path      = require 'path'
  glob      = require 'glob'
  rimraf    = require 'rimraf'
  imagesize = require 'image-size'

  # Directory PARSER
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
      @thumbSuffix = config.gallerySettings['**/*'][0].rename.suffix

    jsonForFile: (file)->
      parsed = path.parse file
      {}=
        src: parsed.base
        thumb: [parsed.name, @thumbSuffix, parsed.ext].join ''
        size: imagesize(file)

    getJsonFilename: ()->
      "gallery-#{@id}.json"

    getJson: ()->
      @files = (@jsonForFile file for file in glob.sync path.join @src, '*.{jpg,jpeg,png}')
      JSON.stringify @files

  # Name helpers
  fixLetter = (char)->
    replacement = chm[char.charCodeAt 0]
    (if replacement? then replacement else char)
      .toLowerCase()
      .replace(/[^a-z0-9-_\.]/, '-')
  fixFilename = (filename)->
    (fixed = (fixLetter char for char in filename)).join('').replace('.jpeg', '.jpg')

  # GULP TASKS
  g.task 'gallery:fix-filenames', ()->
    glob.sync(cfg.site.path 'source/galleries/**/*.{jpg,jpeg,png}').forEach (file)->
      oldFileName = path.parse file
      newFileName = fixFilename(oldFileName.base)
      if newFileName isnt oldFileName.base
        fs.renameSync(
          path.join(oldFileName.dir, oldFileName.base)
          path.join(oldFileName.dir, newFileName)
        )

  g.task 'gallery:optimize', ['gallery:fix-filenames'], ()->
    gp.remoteSrc 'source/galleries/**/*.{jpg,jpeg,png}'
      .pipe gp.imagemin { progressive: true }
      .pipe gp.remoteDest 'public/galleries'
      .pipe gp.responsive cfg.fs.gallerySettings, { silent: true }
      .pipe gp.remoteDest 'public/galleries'

  g.task 'gallery:jsonize', ['gallery:optimize'], ()->
    glob.sync(cfg.site.path 'source/galleries/*/').forEach (directory)->
      gallery = new Directory directory, cfg.fs
      fs.writeFileSync(
        cfg.site.path("source/data/#{gallery.getJsonFilename()}"),
        gallery.getJson(), 'utf8'
      )

  g.task 'gallery', ['gallery:jsonize'], ()->
    logwhite = (string)-> gp.util.colors.white(string)
    loggreen = (string)-> gp.util.colors.green(string)

    glob.sync(cfg.site.path 'source/galleries/*/').forEach (directory)->
      directoryName = path.parse(directory).base
      rimraf cfg.site.path(path.join('source/galleries', directoryName)), ()->
        gp.util.log(logwhite('Gallery\:'),logwhite('Removed'),loggreen(directoryName))