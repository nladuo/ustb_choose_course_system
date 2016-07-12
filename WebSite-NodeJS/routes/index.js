var express = require('express');
var router = express.Router();
var db = require('../dao');
var path = require('path');

/* GET home page. */
router.get('/', function(req, res, next) {
    res.render('index');
});


router.get('/update', function(req, res, next) {
	var id = req.query.id;
	db.queryAPPInfo(function(results){
		res.send( JSON.stringify(results[id-1]));
	});

});

router.get('/download', function(req, res, next) {
	var id = req.query.id;
	db.queryAPPInfo(function(results){
		var filename = results[id - 1].app_name;
		var filepath = path.join('public', 'downloads', filename);
		res.download(filepath);
	});
});



module.exports = router;
