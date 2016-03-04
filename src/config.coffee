module.exports = ()->
  path = require 'path'

  class Directory
    constructor: (@_path)->

    path: (relative_path)->
      rel = if relative_path? then "/#{relative_path}" else ''
      @_path + rel

    to: (from)->
      path.relative @_path, from

  config = { 
    self: new Directory process.cwd()
    site: new Directory process.env.INIT_CWD
  }

  return config