gulp = require 'gulp'

config =
  root: "/app/test/system"
  src: "src"
  dist: "/app/dist"

require('./gulp')(gulp, config)
return gulp
