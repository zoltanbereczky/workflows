common = require './common'
p = require('gulp-load-plugins')()
#  {config: '/node_tmp/package.json'}

DEBUG = process.env.DEBUG?

module.exports = (gulp, c) ->
  config = common.GetConfig c

  return ->
    p.env.set NODE_ENV: "test"
    gulp.src [config.systemtestEntry, "#{config.buildRoot}/src/index.js", "#{config.buildRoot}/**/*system-tests.js"], {read: false}
    .pipe p.spawnMocha
      debugBrk: DEBUG
      reporter: 'spec'
      ui: 'bdd'
      recursive: true
    .once 'error', (err) -> common.HandleError()
