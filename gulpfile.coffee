"use strict"

# -- DEPENDENCIES --------------------------------------------------------------
gulp    = require "gulp"
coffee  = require "gulp-coffee"
concat  = require "gulp-concat"
gutil   = require "gulp-util"
header  = require "gulp-header"
jasmine = require "gulp-jasmine"
karma   = require "gulp-karma"
uglify  = require "gulp-uglify"
pkg     = require "./package.json"

# -- FILES ---------------------------------------------------------------------
path =
  bower : "./bower"
  temp  : "./build"
  source: "source/hamsa.coffee"
  spec  : "spec/hamsa.coffee"

test = [
  path.temp + "/spec.js"
  path.temp + "/hamsa.js"
]

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
gulp.task "source", ->
  gulp.src(path.source)
    .pipe(concat("hamsa.coffee"))
    .pipe(coffee().on("error", gutil.log))
    .pipe(gulp.dest(path.temp))
    .pipe(uglify(mangle: true))
    .pipe(header(banner, pkg: pkg))
    .pipe(gulp.dest(path.bower))

gulp.task "spec", ->
  gulp.src(path.spec)
    .pipe(concat("spec.coffee"))
    .pipe(coffee())
    .pipe(gulp.dest(path.temp))

  gulp.src(test).pipe(karma(
    configFile: "karma.js"
    action: "run"
  )).on "error", (err) ->
    throw err

gulp.task "init", ->
  gulp.run ["source", "spec"]


gulp.task "default", ->
  gulp.watch path.source, ["source", "spec"]
  gulp.watch path.spec, ["spec"]
  gulp.src(test).pipe karma(
    configFile: "karma.js"
    action: "watch"
  )
