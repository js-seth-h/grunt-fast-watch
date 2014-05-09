###
(c) js.seth.h@gmail.com
MIT License
### 
fs = require 'fs' 
path = require 'path'
ignore = require('ignore') 

log = undefined
 

arrayUnique = (a) ->
  a.reduce ((p, c) ->
    p.push c  if p.indexOf(c) < 0
    p
  ), []

memory = {}
 
module.exports = ( grunt ) -> 
  log = grunt.log
  grunt.registerMultiTask 'fastWatch', 'fast', () ->
    # console.log.writeln this 

    unless memory[target]?
      memory[target] = {}
    mem = memory[target]

    done = @async()
    # log.writeln 'test'
    target = @target
    data = @data
    options = @options()

    patterns = data.ignore
    # log.writeln 'Ignore Patterns - ',  patterns


    poxislize = (pathname) ->
      # log.writeln pathname
      sep = '/'
      pathname.replace(/\\/g, sep);
      
    IsIgnore = (pathname) ->

      pathname = poxislize pathname
      result = Ignore.filter [ pathname]
      ret = result.length is 0
      # log.writeln 'is ignore - ', pathname , ' > ',  result,  ret if not ret 
      return ret

    Watch = (dirname)-> 
      if not IsIgnore(dirname)        
        # log.writeln "Watch dir : ", dirname
        FsWatcher = fs.watch dirname, (event, filename)-> 
          HandleFsEvent event, filename, dirname 
        
        FsWatcher.on 'error', ()->
          console.log arguments

      fs.readdir dirname, (error, files ) -> 
        return if error
        # log.writeln 'read dir', files  
     
        #log.writeln 'readdir = ', dirname
        files.forEach (file) => 
          
          pathname = path.relative '.', dirname + '/' + file
          
          fs.stat pathname, (err, stat) =>
            # log.writeln 'W :  = ',pathname 
            return if not stat
            return if not stat.isDirectory()
            # log.writeln 'pathname = ',pathname 
            Watch pathname
            
    HandleFsEvent =  (event, filename, dirname)->    
      log.writeln 'watch event - ' , event, filename, dirname

      # return if filename is null
      pathname = dirname
      pathname +=  '/' + filename if filename
      pathname = poxislize(path.relative '.', pathname)
      # log.writeln'watch event - ', event, pathname
      # console.log("\x1B[1;31m[Watcher]\x1B[0m   watch - ", arguments)
      return if IsIgnore(pathname) 

        # return log.writeln'Ignored event - ',  event, filename

      # log.writeln 'watched event - ', event, pathname 

      DelayedEvent(event, pathname) 

  
    DelayedEvents = []
    DelayedEventTimer = null
    DelayedEvent = (event, pathname)->
      txt = "Watched '#{pathname}' #{event}"
      if DelayedEventTimer is null
        DelayedEvents = []
        DelayedEvents.push txt
        DelayedEventTimer = setTimeout ()->
          DelayedEventTimer = null

          for e in arrayUnique DelayedEvents
            log.writeln e
          RunTasks()
        ,500
      else
        DelayedEvents.push txt

    RunTasks = ()->
      # log.writeln 'RunTasks - ', data.tasks
      grunt.task.run data.tasks
      grunt.task.run "fastWatch:#{target}"
      done()
 
    unless mem.watched?

      Ignore = ignore 
        twoGlobstars: true
        ignore : patterns

      mem.watched = true
      log.writeln 'Watching... '
      Watch data.dir