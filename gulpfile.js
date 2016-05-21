var gulp = require('gulp');
var jade = require('gulp-jade');
var del = require('del');
var browserify = require('gulp-browserify');
var rename = require('gulp-rename');

gulp.task('jade', function () { 
  return gulp.src('index.jade')
    .pipe(jade())
    .pipe(gulp.dest('.'));
});

gulp.task('build', ['jade'], function () {
  gulp.src('scripts/main.coffee', { read: false })
    .pipe(browserify({
      transform: ['coffeeify'],
      extensions: ['.coffee']
    }))
    .pipe(rename('bundle.js'))
    .pipe(gulp.dest('.'))
});

gulp.task('clean', function () {
  return del(['main.js', 'index.html']);
});

gulp.task('default', ['clean', 'build']);
