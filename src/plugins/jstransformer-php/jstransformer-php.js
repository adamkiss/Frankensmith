'use strict';

/*
  Custom JSTransformer so I can skip options and plugins in jade.

  It's a copy from:
  https://github.com/RobLoach/jstransformer-markdown-it

  Modified by me.
 */

exports.name = 'php';
exports.outputFormat = 'php';
exports.render = function (str, options) {
  return '<?php '+str+' ?>';
};