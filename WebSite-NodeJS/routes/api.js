/**
 * Created by kalen on 7/12/16.
 */

var express = require('express');
var router = express.Router();
var db = require('../dao');


router.get('/app_list', function(req, res, next) {
    db.queryAPPInfo(function(app_results){
        res.end(JSON.stringify({
            code: 0,
            data: app_results
        }));
    });
});

router.get('/comment_list', function(req, res, next) {
    db.queryMessageBoard(function(comment_results){
        res.end(JSON.stringify({
            code: 0,
            data: comment_results
        }));
    });
});

router.get('/add', function (req, res, next) {
    res.render('404');
});

router.post('/add', function(req, res, next) {

    if (req.body.parent_id == undefined ||req.body.comment == ''
        || req.body.name == undefined || req.body.name == ''
        || req.body.parent_id == undefined || req.body.parent_id == ''
        || req.body.replyer_name == undefined || req.body.replyer_name == '') {
        res.render('404', {});
        return;
    }
    var comment = {
        parent_id: req.body.parent_id,
        nickname: req.body.name,
        replyer_name: req.body.replyer_name,
        content: req.body.comment,
        time: new Date().Format("yyyy-MM-dd hh:mm:ss")
    };
    console.log(comment);
    db.addMessage(comment, function(){
        res.redirect("/");
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
