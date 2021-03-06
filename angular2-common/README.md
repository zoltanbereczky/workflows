# Angular 2 development

The main concepts are the same than that of the Angular 1 based development, implemented in the `webpack` container.

_tl;dr_

```
npm run setup
yarn
npm run build:docker
npm run unittest
npm run build:prod

npm start
npm run start:docker
git add .
npm run commit
```

## General concepts

* The project is based on the [Angular Webpack Starter](https://github.com/AngularClass/angular2-webpack-starter) project, learn about the used tehchnology/dependencies there. The generated starting code implements a TODO list app that you have to turn into the real application/module.
* The code has some really good code samples, and it has 100% test coverage - we should keep this ratio.

## Organizing the project, files

* Unit tests: see [unit test organization](#unit-testing).
* Place all the services, components, etc. to separate folders. Name the folders after the component name.
* Use `index.ts` for the file defining the component (so, not `foo.component.ts`).
* Import the component using the folder name, and let webpack to resolve the `index.ts`.

## Dependency management

The dependencies should go to `package.json`, as usual. The build system will merge its content with the `package.json` file in the container, and install the project-specific packages as well. So, add those dependencies only that you cannot find in the container, for performance reasons.

Mind, that only the following keys are merged: `dependencies, peerDependencies, devDependencies, garlic`.

However, you can should use the packages for local development as well, to please your code editor: if you install all the the required dependencies locally (both project-specific ones and the ones that the container provides), the editor will find them and won't report 'undefined' errors, etc.

## Project types

There are two project types: `site` and `module`. Site is a full-blown web site with `index.html`. Module is an Angular2 module, to be reused by other modules and sites.

In case of modules, you can find a folder called `dev-site`. Here, you can build a test site for the module: you can test the functionalities in a real site, and you can use e2e test as well. The development site is not part of the module.

## Start development

After cloning the project, do not forget setting it up:

`npm run setup`

It will create some important folders and files.

## Build commands

Webpack, Karma, etc. run in a development Docker container. So, you must not install npm dependencies in the local development folder, doing so will cause failures. The development commands mount the source code into the continer.

Before starting, you have to build the development Docker container with some of the build commands below. Webpack, Karma, etc. all run in that container. You can define the development Docker container in `Dockerfile.dev`: extend it if you have to add something more. Don't remove sections marked as "don't remove", unless you know what you do.

### `npm run build:docker`

Builds the development container. It is a 'light' build, it uses Docker cache, etc. It provides fast rebuild, but it cannot detect if the base docker image changes, or the versions of the dependencies change.

### `npm run build:docker:all`

It rebuilds everything: pulls the latest base container and disables the Docker cache. Use it when the bse container changes, or when you want to integrate a newer version of a dependency.

### `npm run build:prod`

It creates the production build:

* AOT-compile the project and creates the dist folder
* Creates an nginx-based docker image serving the web site

### Webpack hook

Webpack is pre-configured in the base container. If you need, you can customize webpack further: you can access the webpack configuration object in `hooks/webpack/webpack.js`, and modify the config. The container will call this function as the last step of preparing the webpack config. 

## Unit testing

The base container preinstalls and configures the Karma test runner with Jasmine test framework and PhantomJS headless browser. Similarly to the webpack hook, you can access both the test Webpack configuraion (`hooks/webpack/webpack.test.js`) and the Karma configuration (`hooks/webpack/karma.js`).

Mind, that in Angular 1, we used Mocha, however in Angular 2, we use Jasmine. The reason is: the seed project uses Jasmine in the sample tests, in fact, the basic concepts of the two frameworks are the same.

### Project organization, files

* Add the unit tests under a `test` subfolder in a module/component folder. This is just a recommendation, the system will find the test files wherever you place them.
* Name them like `foo.spec.ts`. The `spec.ts` part is the Jasmine standard, and it is important. Karma will execute spec files only.

### `npm run unittest`

Run the unit tests, and start watching. When the test/source files change, karma will re-run the tests. 

In watching mode, navigate to http://localhost:9876, to see the debug output of karma. Here, you can inspect the full test code and go to the exact code lines where an error happened (in the development tools of the browser). Configure this port in `docker/docker-compose.net.yml`.

#### Coverage report

At the end of each test run, you will receive a test coverage report. Mind, that we should keep it at 100%, later, we will force build failure in CI if the coverage is less, than 100!

You can access the coverage report in your project folder, under `reports/coverage` (open it in a browser). The system will create this folder after teh very first test run. _Warning_: it is a mounted folder, so it will disappear after shutting down the unit test runner!

## Starting the project

### `npm start`

It launches a webpack dev server in the container, and start watching project source changes. Access the site at http://localhost:8081. The internal container always uses the port 8081, you can map this port to somewhere else in `docker/docker-compose.net.yml` in the project folder.

### `npm start:docker`

Starts the (previously built) Docker/nginx based web server.

## Debugging

### Debugging the container

Log in to the container and see its actual content:

```npm run bash```

The command opens a bash session where you can directly change the development container. Mind, that those changes are not persistent, you loose them when you exit.

## Supportes technologies

### File types

Supported files (by their extension): `js, ts, jade, pug, scss, css, html, json, coffee, png, jpeg, jpg, gif, svg, woff, woff2, ttf, eot, ico`
