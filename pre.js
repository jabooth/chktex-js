var Module
if(typeof Module === "undefined") {
    Module={}
}
if(typeof Module.preRun === "undefined") {
    Module.preRun = []
}
Module.preRun.push(
    function() {
        ENV.HOME = require('os').homedir()
        ENV.CWD = require('path').resolve()
    }
)
