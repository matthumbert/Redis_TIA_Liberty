# Generated on 2015-02-26 using generator-reveal 0.4.0
module.exports = (grunt) ->

    grunt.initConfig

        watch:

            livereload:
                options:
                    livereload: true
                files: [
                    'index.html'
                    'protected/master.html'
                    'slides/{,*/}*.{md,html}'
                    'js/**/*.js'
                    'css/*.css'
                ]

            index:
                files: [
                    'templates/_index.html'
                    'templates/_master.html'
                    'templates/_section.html'
                    'slides/list.json'
                ]
                tasks: ['buildIndexClient', 'buildIndexMaster']

            coffeelint:
                files: ['Gruntfile.coffee']
                tasks: ['coffeelint']

            jshint:
                files: ['js/**/*.js']
                tasks: ['jshint']
                options:
                    globals:
                        Reveal: true
        
            sass:
                files: ['css/source/theme.scss']
                tasks: ['sass']

        sass:

            theme:
                files:
                    'css/theme.css': 'css/source/theme.scss'
        
        connect:

            livereload:
                options:
                    port: 9000
                    # Change hostname to '0.0.0.0' to access
                    # the server from outside.
                    hostname: '0.0.0.0'
                    base: '.'
                    open: false
                    livereload: true
            server:
                options:
                    port: 8000,
                    hostname: '*',
                    onCreateServer: (server, connect, options) ->
                        io = require('socket.io').listen(server)
                        io.sockets.on('connection') ->
                            console.log('rptou')
        

        coffeelint:

            options:
                indentation:
                    value: 4
                max_line_length:
                    level: 'ignore'

            all: ['Gruntfile.coffee']

        jshint:
            options:
                globals:
                    Reveal: true

            all: ['js/*.js']

        copy:

            dist:
                files: [{
                    expand: true
                    src: [
                        'slides/**'
                        'bower_components/**'
                        'js/**/**'
                        'css/*.css'
                    ]
                    dest: 'dist'
                },{
                    expand: true
                    src: ['index.html','protected/master.html']
                    dest: 'dist'
                    filter: 'isFile'
                }]


    # Load all grunt tasks.
    require('load-grunt-tasks')(grunt)

    grunt.registerTask 'buildIndexClient',
        'Build index.html from templates/_index.html and slides/list.json.',
        ->
            indexTemplate = grunt.file.read 'templates/_index.html'
            # sectionTemplate = grunt.file.read 'templates/_voterForm.html'
            # slides = grunt.file.readJSON 'slides/list.json'

            # html = grunt.template.process indexTemplate, data:
            #     slides:
            #         slides
            #     section: (slide) ->
            #         grunt.template.process sectionTemplate, data:
            #             slide:
            #                 slide
            grunt.file.write 'index.html', indexTemplate

    grunt.registerTask 'buildIndexMaster',
        'Build index.html from templates/_master.html and slides/list.json.',
        ->
            indexTemplate = grunt.file.read 'templates/_master.html'
            sectionTemplate = grunt.file.read 'templates/_section.html'
            slides = grunt.file.readJSON 'slides/list.json'

            html = grunt.template.process indexTemplate, data:
                slides:
                    slides
                section: (slide) ->
                    grunt.template.process sectionTemplate, data:
                        slide:
                            slide
            grunt.file.write 'protected/master.html', html

    grunt.registerTask 'test',
        '*Lint* javascript and coffee files.', [
            'coffeelint'
            'jshint'
        ]

    grunt.registerTask 'serve',
        'Run presentation locally and start watch process (living document).', [
            'buildIndexClient'
            'buildIndexMaster'
            'sass'
            'connect:livereload'
            'watch'
        ]

    grunt.registerTask 'dist',
        'Save presentation files to *dist* directory.', [
            'test'
            'sass'
            'buildIndexClient'
            'buildIndexMaster'
            'copy'
        ]

    

    # Define default task.
    grunt.registerTask 'default', [
        'test'
        'serve'
    ]
