'use strict'

path        = require 'path'
gulp        = require 'gulp'
config      = require('./src/config')()
plugins     = require('gulp-load-plugins')()
plugins     = require('./src/plugins')(gulp, plugins, config)

  # smith:      require('./src/tasks-metalsmith')(gulp, plugins, config)
require('./tasks/serversync')(gulp, plugins, config)
require('./tasks/scripts')(gulp, plugins, config)
require('./tasks/styles')(gulp, plugins, config)
require('./tasks/assets')(gulp, plugins, config)

gulp.task 'default', ()->
  console.log config.site.to config.self.path 'site/modules'

# _g = gulp; _p = plugins; _c = config

# tasks      = {
#   smith    : require('./tasks/metalsmith')(_g, _p, _c)
#   serversync : require('./tasks/serversync')(_g, _p, _c)
# }
# # ['rebuild-site']
# gulp.task 'default', ['resolve-paths'], ()->
# gulp.task 'startup', ['rebuild', 'connect-sync', 'tonks']
# gulp.task 'tonks', ()->
#   gulp.watch '../metalsmith-golfseason/site/source/*.*', ()->
#     console.log arguments

# gulp.task 'test', ()->
#   paths =
#     self: process.cwd()
#     site: process.env.INIT_CWD
#   paths.toSelf = path.relative(paths.site, paths.self)
#   paths.toSite = path.relative(paths.self, paths.site)

#   config.paths = paths

#   console.log config.paths


# # console.log config, config2

# # // gulp.task('all', [ 'styles', 'utils:fonts', 'scripts:build', 'images' ]);
# # // gulp.task('build', [ 'all', 'utils:build:version' ]);
# # // gulp.task('serve', [ 'all', 'utils:server', 'bs:start', 'watch' ]);

# # // //default
# # // gulp.task('default', ['serve']);
