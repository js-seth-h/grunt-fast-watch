
ignoreDir = """ 
.git
.gitignore
tmp
node_modules

""".split '\n' 

serverMatch = """
*.coffee
""".split '\n'
  
clientMatch = """ 
package.json
""".split '\n'   

module.exports = (grunt)->   
 
  grunt.initConfig       
    fastWatch:
      cwd:     
        dir : '.'
        ignoreSubDir : ignoreDir 
        trigger:
          server:  
            match : serverMatch
            tasks: ["print:Server"]
          client: 
            match : clientMatch  
            tasks: ['print:Client']

  grunt.loadTasks 'tasks' 

  grunt.registerTask 'print', (arg)-> console.log 'PRINT ',arg
  grunt.registerTask 'default', 'fastWatch:cwd'
