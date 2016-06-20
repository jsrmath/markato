var gulp = require('gulp');
var del = require('del');
var browserify = require('gulp-browserify');
var rename = require('gulp-rename');

gulp.task('build', function () {
  gulp.src('scripts/main.cjsx', { read: false })
    .pipe(browserify({
      transform: ['coffee-reactify'],
      extensions: ['.coffee', '.cjsx']
    }))
    .pipe(rename('bundle.js'))
    .pipe(gulp.dest('.'))
});

gulp.task('clean', function () {
  return del(['bundle.js']);
});

gulp.task('default', ['clean', 'build']);
