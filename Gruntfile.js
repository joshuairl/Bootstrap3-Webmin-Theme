'use strict';
module.exports = function(grunt) {
  var js = [
    'assets/js/vendor/jquery-1.10.2.js',
    'assets/js/vendor/jquery.jpanelmenu.js'
  ];
  grunt.initConfig({
    jshint: {
      options: {
        jshintrc: '.jshintrc'
      },
      all: [
        'Gruntfile.js',
        'assets/js/*.js',
        '!assets/js/webmin.js',
      ]
    },
    less: {
      dist: {
        files: {
          'assets/css/webmin.css': [
            'assets/less/app.less'
          ]
        },
        options: {
          compress: true,
          // LESS source map
          // To enable, set sourceMap to true and update sourceMapRootpath based on your install
          sourceMap: false,
          sourceMapFilename: 'assets/css/webmin.min.css.map',
          sourceMapRootpath: '/app/themes/roots/'
        }
      }
    },
    concat: {
      options: {
        separator: ';',
      },
      dist: {
        src: js,
        dest: 'assets/js/webmin.js',
      }
    },
    uglify: {
      dist: {
        files: {
          'assets/js/webmin.js': js
        },
        options: {
          // JS source map: to enable, uncomment the lines below and update sourceMappingURL based on your install
          // sourceMap: 'assets/js/scripts.min.js.map',
          // sourceMappingURL: '/app/themes/roots/assets/js/scripts.min.js.map'
        }
      }
    },
    watch: {
      less: {
        files: [
          'assets/less/*.less',
          'assets/less/bootstrap/*.less',
          'assets/less/font-awesome/*.less',
          'assets/less/responsive/large/*.less',
          'assets/less/responsive/medium/*.less',
          'assets/less/responsive/small/*.less',
          'assets/less/responsive/tiny/*.less'
        ],
        tasks: ['less']
      },
      js: {
        files: [
          '<%= jshint.all %>',
          js
        ],
        tasks: ['jshint', 'concat']
      },
      livereload: {
        // Browser live reloading
        // https://github.com/gruntjs/grunt-contrib-watch#live-reloading
        options: {
          livereload: false
        },
        files: [
          'assets/css/webmin.css',
          'assets/js/webmin.js',
          '*.cfm'
        ]
      }
    },
    clean: {
      dist: [
        'assets/css/webmin.css',
        'assets/js/webmin.js'
      ]
    }
  });

  // Load tasks
  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-contrib-concat');
  grunt.loadNpmTasks('grunt-contrib-jshint');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-less');

  // Register tasks
  grunt.registerTask('default', [
    'clean',
    'less',
    'concat',
    'uglify'
  ]);
  grunt.registerTask('dev', [
    'clean',
    'less',
    'concat',
    'watch'
  ]);

};
