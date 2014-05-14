
trim = (str)->
  str.replace /(^\s*)|(\s*$)/gm, ""
fromLines = (patterns)->
  return trim(patterns).split('\n').map (pattern)->
    trim(pattern)


ignoreDir = fromLines """ 
.git
.gitignore
tmp        
node_modules

"""
serverCares = fromLines """
*.coffee       
*.json
""" 

clientCares = fromLines """ 
*.coffee   
!Gruntfile.coffee
package.json 
"""  # every coffee file, but Gruntfile.coffe + package.json
 
module.exports = (grunt)->   
 
  grunt.initConfig 
    fastWatch: 
      cwd:     
        dir : '.' 
        ignoreSubDir : ignoreDir 
        trigger:
          server:  
            care : serverCares
            tasks: ["print:Server"]
          client: 
            care : clientCares  
            tasks: ['print:Client']

  grunt.loadTasks 'tasks' 

  grunt.registerTask 'print', (arg)-> console.log 'PRINT ',arg
  grunt.registerTask 'default', 'fastWatch:cwd'
