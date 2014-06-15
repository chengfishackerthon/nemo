var http = require('http');
var fs = require('fs');
http.createServer(function (request, response) {
    console.log('request starting...');

        fs.readFile('./query.json', function(error, content) {
                if (error) {
                        response.writeHead(500);
                        response.end();
                }
                else {
                        response.writeHead(200, { 'Content-Type': 'text/html' });
                        response.end(content, 'utf-8');
                }
        });

}).listen(5000);
console.log('Server running at http://127.0.0.1:80/');
