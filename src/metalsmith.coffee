module.exports = (g, gp, cfg)->

  _   = require 'lodash'
  MS  = require 'metalsmith'
  msp = require('load-metalsmith-plugins')()
  msp = require('./metalsmith-plugins')(g, gp, MS, msp, cfg)

  jadeHelpers = require('./jade-helpers')({g: g, gp: gp, ms: MS, msp: msp, cfg: cfg})

  renameMap = [
    [/\.php\.jade$/, '.php'],
    [/\.jade$/     , '.html']
  ]

  Metalsmith: (opts, callback)->
    cfg.metalsmith = msp.readDataFiles 'source/data/*.*'
    cfg.runtime = {
      build: opts.build || false
      assets: cfg.metalsmith.metadata['assets-manifest']
    }
    cfg.metalsmith.metadata.env =
      build: cfg.runtime.build

    MS cfg.site.path()
      .source      'source/site'
      .destination 'public'
      .clean        false
      .frontmatter  false

      .use msp.matters()
      .use msp.ignore(cfg.mp.ignore)
      .use msp.virtualPages(cfg.metalsmith.generators)
      .use msp.define(cfg.metalsmith.metadata)
      .use msp.metaPath()
      .use msp.permalinks()
      .use msp.collections(cfg.fs.collections)
      .use msp.inPlace(_.extend(cfg.mp.inPlace, jadeHelpers))
      .use msp.rename(renameMap)

      .build (error)->
        if (error)
          gp.notifier.notify {
            title: '❌ Error: METALSMITH'
            message: error.message.substr error.message.lastIndexOf("\n")+1
          }
          callback(error)
        else
          gp.browserSync.reload()
          callback()
