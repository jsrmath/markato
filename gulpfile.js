var gulp = require('gulp');
var jade = require('gulp-jade');
var del = require('del');
var coffeeify = require('gulp-coffeeify');

gulp.task('jade', function () { 
  return gulp.src('index.jade')
    .pipe(jade())
    .pipe(gulp.dest('.'));
});

gulp.task('build', ['jade'], function () {
  return gulp.src('scripts/main.coffee')
    .pipe(coffeeify())
    .pipe(gulp.dest('.'));
});

gulp.task('clean', function () {
  return del(['main.js', 'index.html']);
});

gulp.task('default', ['clean', 'build']);
