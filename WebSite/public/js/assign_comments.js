function assign_comments(data){
    var innerText = "";
    var comments = parse_comments(data);
    for (var i = 0; i < comments.length; i++) {
        var comment = comments[i];
        innerText += "<li tag_id='" + comment.Id+"' tag_name='"+ comment.Nickname+"'>";
        innerText += "<div id='comment_one' ><article ><header >";
        innerText += "<p id='name'>" + comment.Nickname + ":</p>";
        innerText += "<time id='time'>" + new Date(comment.Time).Format("yyyy-MM-dd hh:mm:ss") + ":</time>";
        innerText += "</header>";
        innerText += "<p id='content'>" + comment.Content + "</p>";
        innerText += "<span class='reply_span'> 回复</span><br/>";
        innerText += "</article></div></li>";
        for (var j = 0; j < comment.Replys.length; j++) {
            var reply =  comment.Replys[j];
            innerText += "<li tag_id='" + reply.Id+"' tag_name='"+ reply.Nickname+"'>";
            innerText += "<div id='reply' ><article ><header >";
            innerText += "<p>" + reply.Nickname + "&nbsp;&nbsp;<c>回复</c>&nbsp;&nbsp;" + reply.ReplyerName + ":</p> ";
            innerText += "<time id='time'>" + new Date(reply.Time).Format("yyyy-MM-dd hh:mm:ss") + ":</time>";
            innerText += "</header>";
            innerText += "<p id='content'>" + reply.Content + "</p>";
            innerText += "<span class='reply_span'> 回复</span><br/>";
            innerText += "</article></div></li>";
        }
    }
    var comment_list = document.getElementById("comment_list");
    comment_list.innerHTML = innerText;
}

/**
 * 调用的元评论数据处理函数
 * @param  {[type]} datas [description]
 * @return {[type]}       [description]
 */
function parse_comments(datas){
    var ret_datas = [];
    var comment_datas = find_datas_by_parent_id(datas, 0);
    for (var i = 0; i < comment_datas.length; i++) {
        var data = comment_datas[i];
        var temp_data;
        temp_data = data;
        temp_data.Replys = parse_replys(datas, temp_data.Id);
        ret_datas.push(temp_data);
    }
    return ret_datas;
}

/**
 * 讲一条评论的所有回复添加到评论的replys对象里面
 * @param  {[type]} datas     [description]
 * @param  {[type]} parent_id [description]
 * @return {[type]}           [description]
 */
function parse_replys(datas, parent_id){
    var ret_datas = [];
    function parse_replys_by_parent_id(datas, parent_id){
        var reply_datas = find_datas_by_parent_id(datas, parent_id);
        for (var i = 0; i < reply_datas.length; i++ ) {
            var data = reply_datas[i];
            //递归添加回复，如果下面还有回复的话就添加
            ret_datas.push(reply_datas[i]);
            parse_replys_by_parent_id(datas, data.Id);
        }
    }
    parse_replys_by_parent_id(datas, parent_id);
    return ret_datas;
}

/**
 * 遍历查找元数据函数
 * @param  {[type]} datas     [description]
 * @param  {[type]} parent_id [description]
 * @return {[type]}           [description]
 */
function find_datas_by_parent_id(datas, parent_id){
    var ret_datas =[];
    for (var i = 0; i < datas.length; i++) {
        var data = datas[i];
        if (data.ParentId == parent_id) {
            ret_datas.push(data);
        }
    }
    return ret_datas;
}