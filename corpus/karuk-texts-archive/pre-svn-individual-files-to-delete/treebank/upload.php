<?php
    $uploads_dir = '/home/karuk/public_html/internal/treebank/';
    $upfile_size_limit = 500000;

    header("Cache-control: private");
    header("Content-Type: text/plain");

    $upfile_name = $_POST['filename'];
// TODO: check filename for allowed format

    $fromFile = $_FILES['data']['tmp_name'];
    $toFile = $uploads_dir . $upfile_name;
    if ($_FILES['data']['size'] <= $upfile_size_limit) {
        $moveResult = move_uploaded_file( $fromFile, $toFile );
        if( $moveResult )
        {
            error_log("SUCCESS - move_uploaded_file( ) succeeded!"); 
        }
        else
        {
            error_log("ERROR - move_uploaded_file( ) failed!"); 
        }
    } else {
        error_log("ERROR - uploaded file too large!"); 
    }
?>
