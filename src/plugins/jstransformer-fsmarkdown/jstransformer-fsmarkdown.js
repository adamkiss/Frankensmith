'use strict';

/*
  Custom JSTransformer so I can skip options and plugins in jade.

  It's a copy from:
  https://github.com/RobLoach/jstransformer-markdown-it

  Modified by me.
 */

var _          = require('lodash');
var MarkdownIt = require('markdown-it');

exports.name = 'fsmarkdown';
exports.outputFormat = 'html';
exports.render = function (str, options) {
  var defaults = _.extend({
    html: true,
    breaks: true,
    linkify: true,
    typographer: true
  }, options);

  var md = MarkdownIt(options).use(require('markdown-it-footnote'))
  return md.render(str);
};