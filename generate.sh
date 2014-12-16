#!/bin/bash

function push_js {
    cat $1 >> public/script.js
    echo -e "\n" >> public/script.js
}

function push_css {
    cat $1 >> public/theme.css
    echo -e "\n" >> public/theme.css
}

rm -rf public/
mkdir public

#JS
push_js bower_components/jquery/dist/jquery.min.js 
push_js bower_components/angular/angular.min.js
push_js bower_components/angular-resource/angular-resource.min.js
push_js bower_components/angular-route/angular-route.min.js
push_js bower_components/bootstrap/dist/js/bootstrap.min.js
push_js assets/js/app-router.js
push_js assets/js/app-controller.js

#MAP FILES
cp ./bower_components/*/*.map ./public

#CSS
push_css bower_components/bootstrap/dist/css/bootstrap.min.css
push_css assets/css/main.css

#IMAGES
cp -r assets/img public/img

echo "Done"
