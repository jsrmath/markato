var gulp = require('gulp');
var del = require('del');
var browserify = require('gulp-browserify');
var rename = require('gulp-rename');
var shell = require('gulp-shell');

gulp.task('build', function () {
  return gulp.src('public/scripts/main.cjsx', { read: false })
    .pipe(browserify({
      transform: ['coffee-reactify'],
      extensions: ['.coffee', '.cjsx']
    }))
    .pipe(rename('bundle.js'))
    .pipe(gulp.dest('public'))
});

gulp.task('apply-prod-environment', function() {
  return process.env.NODE_ENV = 'production';
});

gulp.task('default', ['build']);

gulp.task('production', ['apply-prod-environment', 'build']);

gulp.task('deploy', ['production'], shell.task([
  'firebase deploy'
]));
