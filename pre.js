Module = {
    preRun: [function() {
        ENV.HOME = require('os').homedir()
        ENV.CWD = require('path').resolve()
    }]
}
