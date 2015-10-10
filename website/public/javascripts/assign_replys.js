var assign_replys = function(){
    var list = document.getElementById("comment_list");
    var listChildren  = list.children ;
    for (var i = 0; i <listChildren.length; i++){
        listChildren[i].onclick = function (e){
            e = e||window.event;
            var el = e.srcElement;
            if (el.className == 'reply_span') {
                var former_reply_form = document.getElementById("reply_form_id");
                if (former_reply_form != undefined){
                    former_reply_form.remove();
                }

                var reply_name = $(el).parents("li").attr("tag_name");          
                var parent_id = $(el).parents("li").attr("tag_id");
                var reply_form = "<textarea id='comment' name='comment' placeholder='回复" + reply_name +"：' rows=3 cols=50></textarea>" 
                    + "</br>" 
                    + "<textarea id='name' name='name' placeholder='你的昵称' rows=1 cols=15></textarea>" 
                    +"<input type='hidden' name='replyer_name' value='" + reply_name + "'/>"
                    +"<input type='hidden' name='parent_id'  value='" + parent_id + "'/>" 
                    +"<input type='submit' name='btn_reply' value='回复'/>";
                
                var form = document.createElement('form');
                form.setAttribute('name', 'replyform');
                form.setAttribute('onsubmit', 'return isReplyEmpty();');
                form.setAttribute('action', '/add');
                form.setAttribute('method', 'post');
                form.setAttribute('id', 'reply_form_id');
                form.innerHTML = reply_form;
                el.appendChild(form);
            }
        }
    }
}
