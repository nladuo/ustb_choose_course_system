var express = require('express');
var router = express.Router();
var db = require('../dao');

/**
 * 更新操作API接口
 * 输出格式:JSON
 * @param  {[type]} req   [description]
 * @param  {[type]} res   [description]
 * @param  {[type]} next) {	var        id [description]
 * @return {[type]}       [description]
 */
router.get('/', function(req, res, next) {

	var id = req.query.id;
	db.queryAPPInfo(function(results){
		res.send( JSON.stringify(results[id-1]));
	});

});

module.exports = router;
