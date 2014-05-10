 
ignore = """
.git
.gitignore
package.json  
tmp
node_modules
*.bak
*.htm
*.html
*.css
*.ico 
*.png
*.gif
*.js
*.jpg 
*.jpeg
*.less
*.bat
*.lnk 
**/template
# saf - this is comment
public  
!node_modules/handover
node_modules/handover/node_modules
**/.git
**/.gitignore
""".split('\n')
 

module.exports = (grunt)->  
 
    
  grunt.loadTasks 'tasks' 
  grunt.initConfig    
    fastWatch:   
      here:  
        dirs : '.' # or dirs : ['.', '../static']
        ignore:  ignore
        tasks: ['print']


  grunt.registerTask 'print', ()-> console.log 'capture watch event '
  grunt.registerTask 'default', 'fastWatch:here'
