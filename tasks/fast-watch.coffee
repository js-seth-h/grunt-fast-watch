###
(c) js.seth.h@gmail.com
MIT License
### 
fs = require 'fs' 
path = require 'path'
ignore = require('ignore')  
 

log = undefined

trim = (str)->
  str.replace /(^\s*)|(\s*$)/gm, ""

arrayUnique = (a) ->
  a.reduce ((p, c) ->
    p.push c  if p.indexOf(c) < 0
    p
  ), []

memory = {}

 
module.exports = ( grunt ) -> 
  log = grunt.log
  verbose = grunt.verbose
  grunt.registerMultiTask 'fastWatch', 'fast', () ->
    # console.log.writeln this 

    done = @async()
    # log.writeln 'test'
    target = @target
    data = @data
    options = @options()

    unless memory[target]?
      memory[target] = {}
    mem = memory[target]
    mem.watchedDirs = []
    
    # log.writeln 'IgnoreSubDir Patterns - ',  patterns


    poxislize = (pathname) ->
      # log.writeln pathname
      sep = '/'
      pathname.replace(/\\/g, sep);
      
    IsIgnoreSubDir = (pathname) ->

      result = IgnoreSubDir.filter [ pathname]
      ret = result.length is 0
      # log.writeln 'is ignore - ', pathname , ' > ',  result,  ret if not ret 
      return ret

    Watch = (dirname)-> 

      dirname = poxislize dirname

      if not IsIgnoreSubDir(dirname)        
        unless dirname in mem.watchedDirs

          verbose.writeln 'Watch Dir:', dirname
          FsWatcher = fs.watch dirname, (event, filename)-> 
            HandleFsEvent event, filename, dirname          
          FsWatcher.on 'error', ()->
            console.log 'error', arguments
          mem.watchedDirs.push dirname

      fs.readdir dirname, (error, files ) -> 
        return if error
        # log.writeln 'read dir', files  
     
        #log.writeln 'readdir = ', dirname
        files.forEach (file) -> 
          
          pathname = path.relative '.', dirname + '/' + file
          
          fs.stat pathname, (err, stat) ->
            # log.writeln 'W :  = ',pathname 
            return if not stat
            return if not stat.isDirectory()
            # log.writeln 'pathname = ',pathname 
            Watch pathname
            
    HandleFsEvent =  (event, filename, dirname)->    

      # return if filename is null
      pathname = dirname
      pathname +=  '/' + filename if filename
      pathname = poxislize(path.relative data.dir, pathname)

      fs.exists pathname, (exists)->
        return unless exists
        fs.stat pathname, (err, stat)->
          if stat.isDirectory()
            unless pathname in mem.watchedDirs
              Watch pathname

      # log.writeln'watch event - ', event, pathname
      # console.log("\x1B[1;31m[Watcher]\x1B[0m   watch - ", arguments)
      return if IsIgnoreSubDir(pathname) 
      verbose.writeln 'watch event - ' , event,  " f: ", filename, ' d: ', dirname

        # return log.writeln'IgnoreSubDird event - ',  event, filename

      # log.writeln 'watched event - ', event, pathname 

      debounce(event, pathname) 

 
    pathsOfEvent = []
    debounceTimer = null
    debounce = (event, pathname)->
      # txt = "Watched '#{pathname}' #{event}"
      if debounceTimer is null
        pathsOfEvent = []
        pathsOfEvent.push pathname
        debounceTimer = setTimeout ()->
          debounceTimer = null

          # for where in arrayUnique pathsOfEvent
            # log.writeln e
          # RunTasks()
          matchUp arrayUnique pathsOfEvent
        ,500
      else
        pathsOfEvent.push pathname

    matchUp = (paths)->
      verbose.writeln 'Match up - paths of event : ', paths

      tasksToCall = []
      for own key, set of data.trigger
        do (key, set)->

          verbose.writeln 'matching ', key

          result = set._careFilter.filter paths
          # verbose.writeln 'matching ', paths, '-> ', result

          if result.length isnt paths.length
            tasksToCall = tasksToCall.concat set.tasks
            return 
 
      if tasksToCall.length > 0
        verbose.writeln 'Call Tasks', tasksToCall
        grunt.task.run tasksToCall
        grunt.task.run "fastWatch:#{target}"
        done()
      return



    RunTasks = ()->
      # log.writeln 'RunTasks - ', data.tasks
      grunt.task.run data.tasks
      grunt.task.run "fastWatch:#{target}"
      done()
 
    unless mem.watched? 
      IgnoreSubDir = ignore 
        twoGlobstars: true
        ignore : data.ignoreSubDir

      mem.watched = true
      log.writeln 'Watching... '


      for own key, set of data.trigger
        set._careFilter = ignore 
          matchCase : true
          twoGlobstars: true
          ignore : set.care 


      # data.dirs = [data.dirs] if 'string' is grunt.util.kindOf data.dirs
    
      # for dir in data.dirs
      #   Watch dir

      Watch data.dir
    else 
      log.writeln "Continue Watching..."