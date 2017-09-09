var express = require('express');
var rp = require('request-promise');
var router = express.Router();

var host_url = process.env.HOST_URL || 'http://localhost:3000/users';
//process.env.NODE_TLS_REJECT_UNAUTHORIZED = "0";
/* GET users listing. */
router.get('/', function(req, res, next) {
    console.log(host_url);  
    var options = {
        uri: host_url,
        method: 'GET',
        rejectUnauthorized: false
    };
    rp(options)
        .then(function(repos){
            console.log(repos);
            res.send(repos);
        })
        .catch(function(err){
            console.log(err);
            res.send(err);
        })
//  res.send('respond with a resource');
});

module.exports = router;
