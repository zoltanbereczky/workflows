common = require './common'
p = require('gulp-load-plugins')()

# handle src coffeescript files: static compilation
module.exports = (gulp, c) ->
  config = common.GetConfig c
  files = common.GetCompilableDistFiles config, "coffee"

  return ->
    common.GulpSrc gulp, files, 'coffee', {base: config.base}
    .pipe p.coffeelint()
    .pipe p.coffeelint.reporter()
    .pipe p.coffee(bare:true).on 'error', common.HandleError
    .pipe gulp.dest config.buildRoot
    .on 'error', -> common.HandleError()