ChkTeX-JS
=========

This is a lightly modified version of ChkTeX 1.7.6 that has been adapted to
work inside a node environment with
[Emscripten](https://github.com/kripken/emscripten).

Building this code produces a single `chktex.js` module that is around `370kb` (`98kb` compressed) that can be used interchangably with `chktex` binaries. By that I mean:
```
> node ./chktex.js -a -flag -or -two ./some/tex/file.tex
```
should perform identically to:
```
> chktex -a -flag -or -two ./some/tex/file.tex
```
If you find anything where this isn't true - it's a bug, please open an issue.

### Prerequisites

- [Emscripten SDK](https://kripken.github.io/emscripten-site/docs/getting_started/downloads.html)
- `make`/`autoconf` etc
- A LaTeX install (for now). This is only used to build the docs as far as I can tell, so we can remove this restriction fairly easily.

### Building

To build a node module with performance optimisations enabled:
```
> ./jsconfigure
> ./jsmake
```
That's it.

## FAQ

### Why do this?

Well firstly it was a fun way to learn emscripten. :)

Secondly I'm a contributor to the [LaTeX Workshop VS Code extension](https://github.com/James-Yu/LaTeX-Workshop) which includes rich ChkTeX support. This is an experiment to see if it would be possible to provide hassle-free LaTeX linting to all users of our plugin without them having to have a particular `chktex` binary installed. There's a number of benefits to this:
- We can offer a consistent experience across platforms by using a bundled `.js` linter
- We know the user has the latest version of `chktex`
- We can potentailly be a little more nimble in fixing minor bugs in chktex quickly (although of course we would rather go [upstream](http://www.nongnu.org/chktex/)!)


### Can this be used in the browser?

Presently, no. For now I mapped through the FS access explictly for Node - this means we can offer a drop-in replacement for the existing `chktex` binary. For instance, by default `chktex` will follow other latex files included with `\input{}` and lint those also. This means `chktex` needs to call `fopen` of it's own valition and have something happen, which ain't happening in the browser sandbox.

However, `chktex` can be given input on `stdin` for a single file and you can disable following to other files with `-I0`. It would only be an hour or two's work to take this and get it working in the browser, and least for linting one file at a time.

#### How's the performance?

It's not bad. I actually discovered that at least on my `MaxTeX` install it seems `chktex` was compiled without optimizations! Given this, `chktex.js` is quite competitive linting my thesis:
```
> time node ~/gits/chktex-js/chktex.js thesis.tex > /dev/null
ChkTeX v1.7.6 - Copyright 1995-96 Jens T. Berger Thielemann.
Compiled with POSIX extended regex support.
No errors printed; 682 warnings printed; No user suppressed warnings; 498 line suppressed warnings.
See the manual for how to suppress some or all of these warnings/errors.

real	0m0.402s
user	0m0.472s
sys	0m0.056s
```
vs
```
> time chktex thesis.tex > /dev/null
ChkTeX v1.7.4 - Copyright 1995-96 Jens T. Berger Thielemann.
Compiled with POSIX extended regex support.
No errors printed; No warnings printed; No user suppressed warnings; 92 line suppressed warnings.

real	0m0.206s
user	0m0.172s
sys	0m0.013s
```

So, within a factor of two. Also note that my local `chktex` has a bunch of warnings disabled hence the discrepancy.


#### I see 'WARNING - Could not find global resource file' what's that all about?

Presently the default `chktexrc` is not injected into the virtual file system of Emscripten, so `chktex` complains it can't find the global configuration. I'll fix this.

## That's all folks!

_Now follows is the original `README` of ChkTeX:_

ChkTeX
======

ChkTeX is a tool to check for common errors in LaTeX files.  It also
supports checking CWEB files (uses a perl5 script).  It is highly
customizable allowing you turn off any warnings you don't like, as
well as add your own warnings.  It works easily with Emacs and AUCTeX,
but should also be easy to interface with other editors.  If you have
interfaced ChkTeX with another editor, please contribute how you did
it.

It is important to remember that ChkTeX is only intended as a *guide*
to fixing faults.  It is by no means always correct.  This means that
correct LaTeX code may produce errors in ChkTeX, and vice versa:
incorrect LaTeX code may pass silently through.  If you have ideas for
new warnings or ways in which current warnings could be improved,
please report them on the
[bug tracker](https://savannah.nongnu.org/bugs/?group=chktex).

For complete documentation see [the manual](http://www.nongnu.org/chktex/ChkTeX.pdf).

ChkTeX is released under the GNU Public License version 2 or greater.
