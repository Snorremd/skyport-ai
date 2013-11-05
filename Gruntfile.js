module.exports = function(grunt) {
    
    grunt.initConfig({
        // Initilize build configurations
        pkg: grunt.file.readJSON('package.JSON'),
        clean: {
            build: {
                src: [ 'build/*/*.js' ]
            },
            changed: {}
        },
        coffeelint: {
            build: ['src/**/*.coffee'],
            changed: {}
        },
        coffee: {
            build: {
                expand: true,
                cwd: 'src',
                src: [ '**/*.coffee' ],
                dest: 'build',
                ext: '.js'
            },
            changed: {}
        },
        watch: {
            scripts: {
                files: ["src/**/*.coffee", 'test/**/*.coffee'],
                tasks: ["coffeelint:build", "clean:build", "coffee:build"]
            }
        }

    });

    grunt.loadNpmTasks('grunt-contrib-clean');
    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-coffeelint');
    grunt.loadNpmTasks('grunt-contrib-coffee');

    grunt.registerTask(
        'run',
        'runs the node application',
        function() {

        });

    grunt.registerTask(
        'build',
        'lints and compiles all files',
        ['clean:build', 'coffeelint:build', 'coffee:build']
    );

    grunt.registerTask(
        'default',
        'builds and then watches project for changes',
        ['build', 'watch']
    );




};