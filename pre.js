var Module
if(typeof Module === "undefined") {
    Module={}
}
if(typeof Module.preRun === "undefined") {
    Module.preRun = []
}
Module.preRun.push(
    function() {
        var os = require('os')
        ENV.HOME = os.homedir()
        ENV.CWD = require('path').resolve()
        ENV.PLATFORM = os.platform()
    }
)
