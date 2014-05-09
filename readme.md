# grunt-fast-watch

> similar to [grunt-contrib-watch](https://github.com/gruntjs/grunt-contrib-watch), but faster. 

## Why made this?

[grunt-contrib-watch](https://github.com/gruntjs/grunt-contrib-watch) somtime didn't capture fs event (in windows). And, it too slow for my purpose.

I using `fast-watch` to restart server for reloading source code in development.

I am impatience, so made this.



## Features

* fast, fast, fast!
* surely capture fs event in windows.
* support ignore setting(git ignore style, visit [ignore](https://www.npmjs.org/package/ignore)) 
* din't unwatch when call `tasks`
* after running `tasks`, restart `fastWatch` task ( without redundant watch ) 

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

  grunt.initConfig    
    fastWatch:   
      here: 
        dir : '.'
        ignore:  ignore
        tasks: ["service:server:restart"]
  
```

Watch all event  under `.` ( = current workign directory ).
And then filtered by ignore pattern
If passed, run tasks.


 

## Options
	 
it has 3 options: dir, ignore, tasks.

I beleive it is trivial.
 
## License

MIT


[sh]: https://github.com/sindresorhus/grunt-shell 
[sp]: https://github.com/cri5ti/grunt-shell-spawn