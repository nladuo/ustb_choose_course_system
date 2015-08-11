var express = require('express');
var router = express.Router();
var db = require('../dao');
var path = require('path');

/* GET home page. */
router.get('/', function(req, res, next) {
	db.queryAPPInfo(function(app_results){
		db.queryMessageBoard(function(message_results){
			res.render('index', { 
				app_results: app_results,
				message_results: message_results
			});
		});
	});
	
});

/**
 * 添加一条留言
 * @param  {[type]} req   [description]
 * @param  {[type]} res   [description]
 * @param  {Object} next) {	var        message [description]
 * @return {[type]}       [description]
 */
router.post('/add', function(req, res, next) {
	var message = {
		nickname: req.body.name,
		content: req.body.message,
		time: new Date().Format("yyyy-MM-dd hh:mm:ss")
	};
	//console.log(message);
	db.addMessage(message, function(){
		res.redirect("/");
	});

});

router.get('/add', function(req, res, next) {
        res.render('404', {});    
});

/**
 * 下载文件
 * @param  {[type]} req   [description]
 * @param  {[type]} res   [description]
 * @param  {[type]} next) {	var        id [description]
 * @return {[type]}       [description]
 */
router.get('/download', function(req, res, next) {
	var id = req.query.id;
	db.queryAPPInfo(function(results){
		var filename = results[id - 1].app_name;
		var filepath = path.join('public', 'downloads', filename);
		res.download(filepath);
	});
});

Date.prototype.Format = function (fmt) { //author: meizz 
    var o = {
        "M+": this.getMonth() + 1, //月份 
        "d+": this.getDate(), //日 
        "h+": this.getHours(), //小时 
        "m+": this.getMinutes(), //分 
        "s+": this.getSeconds(), //秒 
        "q+": Math.floor((this.getMonth() + 3) / 3), //季度 
        "S": this.getMilliseconds() //毫秒 
    };
    if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
    for (var k in o)
    if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
    return fmt;
}

module.exports = router;
