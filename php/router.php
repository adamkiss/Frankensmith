<?php
  # settings
  $s_document_root = 'index';
  $s_document_exts = ['php', 'html', 'htm'];

  # shortcut functions
  function doc_exists($path) {
    global $s_document_exts;
    foreach($s_document_exts as $ext){
      $lookup = "{$path}.{$ext}";
      if (file_exists($lookup)){
        return $lookup;
      }
    }
    return false;
  }
  function redirect($path){
    if(empty($path)) $path = '/';
    header("Location: {$path}");
    exit;
  }
  function return_404(){
    header("HTTP/1.0 404 Not found");
    if ($doc404 = doc_exists('404')){
      require $doc404; exit;
    }
    echo '<html>
    <head><title>404</title></head>
    <body>404 Not found</body>
  </html>'; exit;
  }

  # DATA
  #
  $path = $_SERVER['REQUEST_URI'] ?: '/';
  $info = pathinfo($path);
  $info['dirname'] = ltrim($info['dirname'].'/', '/');
  // @note: pathinfo = array[ dirname, basename, filename . extension]

  $hasExtension = array_key_exists('extension', $info);
  $isPage = $hasExtension && in_array($info['extension'], $s_document_exts);
  $isDocRoot = $isPage && $info['filename'] === 'index';
  $isPermalink = !$hasExtension && (substr($path, -1)==='/');

  # ACTION
  #
  if ($isDocRoot){
    redirect("/{$info['dirname']}/");
  }
  if ($hasExtension && !$isPage) {
    return false;
  }
  if ($isPage && file_exists("{$info['dirname']}{$info['basename']}")){
    require "{$info['dirname']}{$info['basename']}"; exit;
  }
  if ($isPermalink) {
    if ($index = doc_exists(ltrim("{$path}index",'/'))) {
      require $index; exit;
    }
  }

  #  ¯\_(ツ)_/¯
  return_404();