module.exports = (gulp, plugins, config)->
  metalsmith = require './metalsmith'
  plugins.metalsmith = metalsmith

  gulp.task 'metalsmith', ()->
    console.log plugins