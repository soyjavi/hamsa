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
stylus  = require "gulp-stylus"
pkg     = require "./package.json"

# -- FILES ---------------------------------------------------------------------
path =
  dist  : "./dist"
  build : "./build"
  source: "source/*.coffee"
  spec  : "spec/hamsa.coffee"
  test  : "spec/test.coffee"
  coffee: "*/**.coffee"
  page  :
    folder: "gh-pages"
    styl  : "gh-pages/source/*.styl"
    coffee: "gh-pages/source/*.coffee"

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
    .pipe gulp.dest path.dist
    .pipe concat "index.js"
    .pipe gulp.dest path.dist

gulp.task "spec", ->
  gulp.src path.spec
    .pipe concat "spec.coffee"
    .pipe coffee().on "error", gutil.log
    .pipe gulp.dest path.build

gulp.task "test", ->
  gulp.src path.test
    .pipe concat "test.coffee"
    .pipe coffee().on "error", gutil.log
    .pipe gulp.dest path.build
    .pipe connect.reload()

gulp.task "karma", ["source", "spec"], (done) ->
  karma.start
    configFile: __dirname + '/karma.js',
    files     : test
    singleRun : false
  , done

# -- gh-pages
gulp.task "stylus", ->
  gulp.src path.page.styl
    .pipe concat "site.styl"
    .pipe stylus
      compress: true
      errors  : true
    .pipe header banner, pkg: pkg
    .pipe gulp.dest path.page.folder
    .pipe connect.reload()

gulp.task "coffee", ->
  gulp.src path.page.coffee
    .pipe concat "site.coffee"
    .pipe coffee().on "error", gutil.log
    .pipe gulp.dest path.build
    .pipe uglify mangle: true
    .pipe header banner, pkg: pkg
    .pipe gulp.dest path.page.folder
    .pipe connect.reload()

gulp.task "init", ["source", "spec", "test", "karma"]

gulp.task "default", ->
  gulp.run ["webserver"]
  # gulp.watch path.coffee, ["karma"]
  gulp.watch path.coffee, ["source", "spec", "test"]
  # gh-pages
  gulp.watch path.page.styl, ["stylus"]
  gulp.watch path.page.coffee, ["coffee"]
