module.exports = (gulp, plugins, config)->
  metalsmith = require '../src/metalsmith'

  gulp.task 'metalsmith:serve', (done)->
    Metalsmith done