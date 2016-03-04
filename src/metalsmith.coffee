module.exports = (gulp, plugins, config)->

  Metal =
    smith:   require 'metalsmith'
    plugins: require('load-metalsmith-plugins')()
    helpers: require('./metalsmith-helpers')()
    modules:  require('./metalsmith-modules')()


  var Metalsmith = require('metalsmith'),
      browserSync = require('browser-sync'),
      m = require('load-metalsmith-plugins')(),
      h = require('./metalsmith-helpers')();
      m = require('./metalsmith-plugins')(m);

  gulp.task('rebuild', function(){
    Metalsmith('../metalsmith-golfseason')
      .source(config.smith.src)
      .destination(config.smith.dest)
      .clean(false)

      .use(m.markdown())
      .use(m.ignore(['.DS_Store', 'sortofblog/gen.js']))
      .use(m.filenames())
      .use(m.prependPathForJade())
      .use(m.inPlace({
        engine: 'jade',
        cache: false,
        md: h.md,
      }))
      // .use(m.whatsWithMD())
      .use(m.rename([
        [/\.php\.jade$/, '.php'],
        [/\.jade$/, '.html']
      ]))

      .build(function(error){
        if (error) { console.log(plugins.PE.); }
        browserSync.reload();
      })
  });
};