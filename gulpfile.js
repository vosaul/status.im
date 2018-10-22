var gulp = require('gulp')
var gutil = require('gulp-util')
var source = require('vinyl-source-stream')
var babelify = require('babelify')
var watchify = require('watchify')
var exorcist = require('exorcist')
var browserify = require('browserify')
var browserSync = require('browser-sync').create()
var sass = require('gulp-sass')
var imagemin = require('gulp-imagemin')
var gutil = require('gulp-util');
var Hexo = require('hexo');
var runSequence = require('run-sequence');

// generate html with 'hexo generate'
var hexo = new Hexo(process.cwd(), {});
gulp.task('generate', function(cb) {
    hexo.init().then(function() {
        return hexo.call('generate', {
            watch: false
        });
    }).then(function() {
        return hexo.exit();
    }).then(function() {
        return cb()
    }).catch(function(err) {
        console.log(err);
        hexo.exit(err);
        return cb(err);
    })
})

var config = {
    paths: {
        src: {
            scss: './themes/navy/source/css/scss/*.scss',
            js: './themes/navy/source/js/main.js',
        },
        dist: {
            css: './public/css',
            js: './public/js'
        }
    }
}

// Watchify args contains necessary cache options to achieve fast incremental bundles.
// See watchify readme for details. Adding debug true for source-map generation.
watchify.args.debug = true
// Input file.
var bundler = watchify(browserify(config.paths.src.js, watchify.args))

// Babel transform
bundler.transform(
    babelify.configure({
        sourceMapRelative: './themes/navy/source/js/'
    })
)

// On updates recompile
bundler.on('update', bundle)

function bundle() {
    gutil.log('Compiling JS...')

    return bundler
        .bundle()
        .on('error', function(err) {
            gutil.log(err.message)
            browserSync.notify('Browserify Error!')
            this.emit('end')
        })
        .pipe(exorcist('./themes/navy/source/js/vendor.js.map'))
        .pipe(source('vendor.js'))
        .pipe(gulp.dest('./themes/navy/source/js'))
        .pipe(browserSync.stream({ once: true }))
}

gulp.task('bundle', function() {
    return bundle()
})


gulp.task('sass', function() {
    return gulp.src("./themes/navy/source/css/scss/main.scss")
        .pipe(sass())
        .on('error', gutil.log)
        .pipe(gulp.dest(config.paths.dist.css))
        .pipe(browserSync.stream())
})

gulp.task('watch', function() {
    gulp.watch(config.paths.src.scss, ['sass'])
});

gulp.task('build', function(cb) {
    runSequence('generate', 'sass', 'bundle', 'watch')
});

gulp.task('default', [])