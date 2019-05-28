# vue-cli-template-dev-server

*development server for building vue-cli custom templates*

[![NPM][1]][2]

---

<p align="center">
  <img src="./resources/example-usage.gif" />
</p>


## overview

this package provides a simple, file-watching server to ease the development of [vue-cli custom templates][3].

once started, the server will listen to changes in the app template source files (under the `/template` directory).
when a change is detected, it will re-compile the template to an output directory, allowing live inspection of the 
generated vue.js application.


## setup

- install via npm:
  
  ```sh
  npm i vue-cli-template-dev-server -D
  ```

- add these bits:
  
  *package.json <sup>\*</sup>*
  
  ```json5
  {
    "scripts": {
      "dev": "vue-cli-template-dev-server"
    },
  }
  ```
  
  *.gitignore*
  
  ```gitignore
  out/
  ```
  
<sup>*\* if you don't have a package.json file, run `npm init`.*</sup>


## usage

simply run the dev script:

```sh
npm run dev
```

the server script accepts two optional arguments. the first one is used for overriding the output directory path
(defaults to `out`), and the second for the output project name (`awesome-vue-app`, if not provided).

to use them, either directly run:

```sh
npm run dev -- 'dist/dev-server-out' 'my-app'
```

&hellip; or put them in the package scripts for good:

```json5
{
  "scripts": {
    "dev": "vue-cli-template-dev-server 'dist/dev-server-out' 'my-app'"
  },
}
```



## demo

check out the [*/example*][5] directory in this repository for an example usage with the most simple application.
it only contains what's required for the dev-server to work.

to see it in action:

- get a local clone:
  
  ```sh
  cd <workspace-path>
  #   ^ replace this with your local workspace directory
  git clone https://github.com/eliranmal/vue-cli-template-dev-server.git
  ```

- navigate to the demo, and ignite the engines:
  
  ```sh
  cd <workspace-path>/vue-cli-template-dev-server/example
  #   ^ you know the drill
  npm start
  ```

  this will install dependencies, and run the example app's dev server.  
  from now on, if you kill the server, you can run it again with:
  
  ```sh
  npm run dev
  ```

- open *./template/hello.md* and *./out/hello.md* in your editor.

- edit *./template/hello.md* and save your changes.

- see *./out/hello.md* change accordingly.


## CLI

use the `-h` flag to see the manual.





[1]: https://img.shields.io/npm/v/vue-cli-template-dev-server.svg?style=flat-square
[2]: https://www.npmjs.com/package/vue-cli-template-dev-server
[3]: https://github.com/vuejs/vue-cli/tree/master#custom-templates
[5]: example
