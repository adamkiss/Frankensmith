<?php
  # settings
  $s_document_root = 'index';
  $s_lookup_extensions = ['php', 'html', 'htm'];

  # shortcut functions
  function redirect($path){
    if(empty($path)) $path = '/';
    header("Location: {$path}");
    exit;
  }
  function redirect_pathinfo($info){
    redirect(rtrim($info['dirname'], '/').'/'.$info['filename']);
  }
  function return_404(){
    header("HTTP/1.0 404 Not found");
    echo '<html>
  <head><title>404</title></head>
  <body>404 Not found</body>
</html>';
    exit;
  }

  # let's go
  $path = $_SERVER['REQUEST_URI'] ?: '/';
  $info = pathinfo($path);

  # If there's extension, we check whether we're intereste in the file
  # - Yes: redirect to no extension
  # - No:  ignore it and serve the file
  if (array_key_exists('extension', $info)){
    if (in_array($info['extension'], $s_lookup_extensions)){
      redirect_pathinfo($info);
    }
    return false;
  } else {
    # Redirect /file/index to /file
    if (substr($path, -5) === 'index'){
      redirect(substr($path, 0, -6));
    }
    # Remove leading slash
    $path = ltrim($path, '/');
    # For lookup, put index back.
    if (substr($path, -1, 1)==='/' or empty($path)){
      $path .= $s_document_root;
    }

    # Look for the file
    foreach($s_lookup_extensions as $ext){
      $lookup = "{$path}.{$ext}";
      if (file_exists($lookup)){
        require $lookup;
        exit;
      }
    }

    #  ¯\_(ツ)_/¯
    return_404();
  }
