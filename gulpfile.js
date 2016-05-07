var gulp = require('gulp');
var coffee = require('gulp-coffee');
var jade = require('gulp-jade');
var browserify = require('browserify');
var uglify = require('gulp-uglify');
var source = require('vinyl-source-stream');
var streamify = require('gulp-streamify');
var rename = require('gulp-rename');


gulp.task('coffee', function () {
  gulp.src('*.coffee')
    .pipe(coffee({bare: true}))
    .pipe(gulp.dest('.'));
});

gulp.task('jade', function() { 
  gulp.src('*.jade')
    .pipe(jade())
    .pipe(gulp.dest('.'));
});

gulp.task('browserify', function() {
  var bundleStream = browserify('./main.js').bundle();

  bundleStream.pipe(source('main.js'))
    .pipe(streamify(uglify()))
    .pipe(rename('markato_bundle.js'))
    .pipe(gulp.dest('./'));
});

gulp.task('default', ['coffee', 'jade', 'browserify']);