var gulp = require('gulp');
var coffee = require('gulp-coffee');
var jade = require('gulp-jade');
var browserify = require('browserify');
var uglify = require('gulp-uglify');
var source = require('vinyl-source-stream');
var streamify = require('gulp-streamify');
var rename = require('gulp-rename');
var del = require('del');


gulp.task('coffee', function () {
  return gulp.src('scripts/*.coffee')
    .pipe(coffee({bare: true}))
    .pipe(gulp.dest('build'));
});

gulp.task('jade', function () { 
  return gulp.src('index.jade')
    .pipe(jade())
    .pipe(gulp.dest('.'));
});

gulp.task('browserify', ['coffee'], function () {
  var bundleStream = browserify('build/main.js').bundle();

  return bundleStream.pipe(source('build/main.js'))
    .pipe(streamify(uglify()))
    .pipe(rename('markato_bundle.js'))
    .pipe(gulp.dest('build'));
});

gulp.task('clean', function () {
  return del(['build', 'index.html']);
});

gulp.task('default', ['clean', 'browserify', 'jade']);