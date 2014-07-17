"use strict"

// -- DEPENDENCIES -------------------------------------------------------------
var gulp    = require('gulp');
var coffee  = require('gulp-coffee');
var concat  = require('gulp-concat');
var gutil   = require('gulp-util');
var header  = require('gulp-header');
var jasmine = require('gulp-jasmine');
var karma   = require('gulp-karma');
var uglify  = require('gulp-uglify');
var pkg     = require('./package.json');


// -- FILES --------------------------------------------------------------------
var path = {
  // Exports
  bower   : './bower',
  temp    : './build',
  // Sources
  source  : ['source/hamsa.coffee'],
  // Spec
  spec    : ['spec/hamsa.coffee'] };

var banner = ['/**',
  ' * <%= pkg.name %> - <%= pkg.description %>',
  ' * @version v<%= pkg.version %>',
  ' * @link    <%= pkg.homepage %>',
  ' * @author  <%= pkg.author.name %> (<%= pkg.author.site %>)',
  ' * @license <%= pkg.license %>',
  ' */',
  ''].join('\n');

// -- TASKS --------------------------------------------------------------------
gulp.task('source', function() {
  gulp.src(path.source)
    .pipe(concat('hamsa.coffee'))
    .pipe(coffee().on('error', gutil.log))
    .pipe(gulp.dest(path.temp))
    .pipe(uglify({mangle: true}))
    .pipe(header(banner, {pkg: pkg}))
    .pipe(gulp.dest(path.bower));
});

gulp.task('spec', function() {
  gulp.src(path.spec)
    .pipe(concat('spec.coffee'))
    .pipe(coffee())
    .pipe(gulp.dest(path.temp));

  var spec = [
    path.temp + '/spec.js',
    path.temp + '/hamsa.js'];

  gulp.src(spec)
    .pipe(karma({
      configFile: 'karma.js',
      action: 'run'
    }));
});

gulp.task('init', function() {
  gulp.run(['source', 'spec']);
});

gulp.task('default', function() {
  gulp.watch(path.modules, ['source', 'spec']);
  gulp.watch(path.spec, ['spec']);
});
