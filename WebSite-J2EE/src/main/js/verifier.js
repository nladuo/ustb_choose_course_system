function isCommentEmpty(){
    if (document.commentform.comment.value.trim() == "") {
        alert("评论内容不得为空");
        document.commentform.comment.focus();
        return false;
    }
    
    if (document.commentform.name.value.trim() == "") {
        alert("请输入您的昵称!");
        document.commentform.name.focus();
        return false;
    }
    return true;
}

function isReplyEmpty(){
    if (document.replyform.comment.value.trim() == "") {
        alert("回复内容不得为空");
        document.replyform.comment.focus();
        return false;
    }
    
    if (document.replyform.name.value.trim() == "") {
        alert("请输入您的昵称!");
        document.replyform.name.focus();
        return false;
    }
    return true;
}

function  trim(str)
{
    for(var  i  =  0  ;  i<str.length  &&  str.charAt(i)=="  "  ;  i++  )  ;
    for(var  j  =str.length;  j>0  &&  str.charAt(j-1)=="  "  ;  j--)  ;
        if(i>j)  return  "";  
    return  str.substring(i,j);  
}