# vue-cli-template-dev-server

*development server for building vue-cli custom templates*

[![NPM][1]][2]


## overview

this package provides a watch server to ease the development of [vue-cli custom templates][3].

once started, the server will listen to changes in the app template source files (under the `/template` directory).
when a change is detected, it will re-compile the template to an output directory, allowing live inspection of the 
generated vue.js application.


## setup

    npm i vue-cli-template-dev-server -D


## usage

*awesome-vue-cli-template/package.json*

    {
      "scripts": {
        "dev": "vue-cli-template-dev-server ./out awesome-app"
      }
    }

TODO - add captured gif of the live terminal activating the server


## CLI

TODO - possibly redirect to docs directory (if using styli.sh)


## workflow

TODO




[1]: https://img.shields.io/npm/v/vue-cli-template-dev-server.svg?style=flat-square
[2]: https://www.npmjs.com/package/vue-cli-template-dev-server
[3]: https://github.com/vuejs/vue-cli/tree/master#custom-templates
