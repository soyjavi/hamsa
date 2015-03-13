"use strict"

# -- DEPENDENCIES --------------------------------------------------------------
gulp    = require "gulp"
coffee  = require "gulp-coffee"
concat  = require "gulp-concat"
connect = require 'gulp-connect'
gutil   = require "gulp-util"
header  = require "gulp-header"
jasmine = require "gulp-jasmine"
karma   = require('karma').server
uglify  = require "gulp-uglify"
pkg     = require "./package.json"

# -- FILES ---------------------------------------------------------------------
path =
  bower : "./bower"
  build : "./build"
  source: "source/hamsa.coffee"
  spec  : "spec/hamsa.coffee"
  coffee: "**/**.coffee"

test = ["#{path.build}/hamsa.js", "#{path.build}/spec.js"]

banner = [
  "/**"
  " * <%= pkg.name %> - <%= pkg.description %>"
  " * @version v<%= pkg.version %>"
  " * @link    <%= pkg.homepage %>"
  " * @author  <%= pkg.author.name %> (<%= pkg.author.site %>)"
  " * @license <%= pkg.license %>"
  " */"
  ""
].join("\n")

# -- TASKS ---------------------------------------------------------------------
gulp.task "webserver", ->
  connect.server
    port      : 8000
    livereload: true

gulp.task "source", ->
  gulp.src path.source
    .pipe concat "hamsa.coffee"
    .pipe coffee().on "error", gutil.log
    .pipe gulp.dest path.build
    .pipe uglify mangle: true
    .pipe header banner, pkg: pkg
    .pipe gulp.dest path.bower
    .pipe connect.reload()

gulp.task "spec", ->
  gulp.src path.spec
    .pipe concat "spec.coffee"
    .pipe coffee().on "error", gutil.log
    .pipe gulp.dest path.build
    .pipe connect.reload()

gulp.task "karma", ["source", "spec"], (done) ->
  karma.start
    configFile: __dirname + '/karma.js',
    files     : test
    singleRun : true
  , done

gulp.task "init", ["source", "spec", "karma"]

gulp.task "default", ->
  gulp.run ["webserver"]
  gulp.watch path.coffee, ["karma"]
