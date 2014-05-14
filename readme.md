# grunt-fast-watch

> similar to [grunt-contrib-watch](https://github.com/gruntjs/grunt-contrib-watch), but faster. 

## Why Another Watch?

[grunt-contrib-watch](https://github.com/gruntjs/grunt-contrib-watch) somtime didn't capture fs event (in windows). And, it too slow for my purpose.

I using `fast-watch` to restart server for reloading source code in development.

I am impatience, so made this.



## Features

* fast, fast, fast!
* surely capture fs event in windows.
* watch `dir`, not `file`
* support ignore setting(git ignore style, visit [ignore][ig]) 
* call different task by file path matching   
* didn't unwatch when call `tasks`
* after running `tasks`, restart `fastWatch` task ( without redundant watch ) 

[ig]: https://www.npmjs.org/package/ignore
## Getting Started

If you haven't used [grunt][] before, be sure to check out the [Getting Started][] guide, as it explains how to create a [gruntfile][Getting Started] as well as install and use grunt plugins. Once you're familiar with that process, install this plugin with this command:

```bash
$ npm install --save-dev grunt-fast-watch
```

Once the plugin has been installed, it may be enabled inside your Gruntfile with this line of JavaScript:

```js
grunt.loadNpmTasks('grunt-fast-watch');
```

*Tip: the [load-grunt-tasks](https://github.com/sindresorhus/load-grunt-tasks) module makes it easier to load multiple grunt tasks.*

[grunt]: http://gruntjs.com
[Getting Started]: https://github.com/gruntjs/grunt/wiki/Getting-started


## Examples
 

```coffee
 
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

   
```

Watch all event under `dir` ( `.` = current workign directory ) exclude sub-direcoty matched by `.ignoreSubDir`

When file system event wached, it test `trigger.*.care`

If passed, run tasks.


## Configuration


`dir` & `ignoreSubDir` designate dirs which are watched.

`trigger` contains `tasks` list which are called by `care`

See [ignore][ig] for `ignoreSubDir` and `care`

**one more thing, matching of `care` is reverse result of [ignore][ig]**

Put simply, [ignore][ig] module filter out changed file path, then watcher cares. And vice versa.

It may be seem weird, but [ignore]][ig] is just filepath filter.

Anyway, write pattern naturally then fast-watch understands.
 


## License

(The MIT License)

Copyright (c) 2014 junsik &lt;js@seth.h@google.com&gt;

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


[sh]: https://github.com/sindresorhus/grunt-shell 
[sp]: https://github.com/cri5ti/grunt-shell-spawn