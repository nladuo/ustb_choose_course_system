<template>
    <form class="form-horizontal" name="replyform" onsubmit="return isReplyEmpty();" action="/api/add" method="post">
        <textarea class="form-control" id="comment" name="comment" placeholder="回复{{comment.Nickname}}" rows="3" cols="50"></textarea><br>
        <textarea class="form-control" id="name" name="name" placeholder="你的昵称" rows="1" cols="15"></textarea>
        <input type="hidden" name="replyer_name" value="{{comment.Nickname}}">
        <input type="hidden" name="parent_id" value="{{comment.Id}}"><br>
        <input class="btn btn-primary btn-sm" type="submit" name="btn_reply" value="发表回复">
    </form>
</template>
<script>
    export default{
        props: {
            comment: Object
        }
    }
</script>