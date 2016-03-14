pe = require('pretty-error').start()

pe.appendStyle {
  'pretty-error':
    margin: 0

  'pretty-error > header > title > kind': {
     color: 'black'
     background: 'red'
     padding: '0 1' # top/bottom left/right
  },

  # the 'colon' after 'Error':
  'pretty-error > header > colon': {
     # we hide that too:
     display: 'none'
  },

  'pretty-error > header > message': {
     color: 'bright-red',
     padding: '0 1'
  },
  'pretty-error > trace':
    marginLeft: 2

  'pretty-error > trace > item': {
     marginLeft: 2
     marginBottom: 0
     bullet: '"<grey>→</grey>"'
  },
  'pretty-error > trace > item > header > pointer > file': {
     color: 'bright-cyan'
  },
  'pretty-error > trace > item > header > pointer > colon': {
     color: 'cyan'
  },
  'pretty-error > trace > item > header > pointer > line': {
     color: 'white'
  },
  'pretty-error > trace > item > header > what': {
     color: 'bright-white'
     padding: '0 1'
  },
}

pe.alias '/Users/adam/Projects/Frankensmith', '(Frankensmith)'
pe.skipPackage 'gulp', 'orchestrator', 'ware', 'wrap-fn', 'async', 'consolidate', 'bluebird'
pe.skipNodeFiles()