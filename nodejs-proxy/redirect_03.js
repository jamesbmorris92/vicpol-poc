var jsonBody = require("body/json")
var http = require("http")
const https = require('https')
var ESPrequest = require('request');

var log = console.log;

console.log = function () {
    var first_parameter = arguments[0];
    var other_parameters = Array.prototype.slice.call(arguments, 1);

    function formatConsoleDate (date) {
        var hour = date.getHours();
        var minutes = date.getMinutes();
        var seconds = date.getSeconds();
        var milliseconds = date.getMilliseconds();

        return '[' +
               ((hour < 10) ? '0' + hour: hour) +
               ':' +
               ((minutes < 10) ? '0' + minutes: minutes) +
               ':' +
               ((seconds < 10) ? '0' + seconds: seconds) +
               '.' +
               ('00' + milliseconds).slice(-3) +
               '] ';
    }

    log.apply(console, [formatConsoleDate(new Date()) + first_parameter].concat(other_parameters));
};

console.log("--- Server started ")
 
http.createServer(function (req, res) {
    
console.log("-- request received")

    jsonBody(req, res, function (err, body) {
        // err is probably an invalid json error
        if (err) {
            res.statusCode = 500
            return res.end("NO U")
        }
        // I am an echo server
        res.setHeader("content-type", "application/json")
        res.end('{"result": "ok"}')
console.log("--- attempt to reset the IOS client");
        console.log(JSON.stringify(body))

var options = {
//  uri: "https://webhook.site/94cd6c8b-1358-490d-bfca-a92e7d4d5a4c", 
   uri: "https://iim2.sasanzdemo.com:9080/SASESP/windows/PERSONS_OF_INTEREST/PERSONS_OF_INTEREST_CQ/SOURCE/state?value=injected",
    rejectUnauthorized: false,
    method: "PUT",
//    json: JSON.stringify(body)
   json: body
}
ESPrequest(options, function(error, response, body){
console.log("--- message PUT to ESP")
    if(error) console.log(error);
    else console.log("--- successful invocation");
console.log('statusCode:', response && response.statusCode); // Print the response status code if a response was received
  console.log('body:', body);
});

    })
}).listen(3000)
