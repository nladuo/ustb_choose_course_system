<template>
    <div id="commentlist">
        <ul id="comment_list" class="list-group">
            <h4 class="list-group-item active">吐槽列表：</h4>
            <h5 v-if="{{comments.length == 0}}">暂无吐糟</h5>

            <li v-for="comment in comments" class="list-group-item">
                <div tag_id ="{{comment.Id}}" tag_name ="{{comment.NickName}}">
                    <article>
                        <header>
                            <p class='name'> {{comment.Nickname}} </p>
                            <time class='time'> {{new Date(comment.Time).Format("yyyy-MM-dd hh:mm:ss")}} </time>
                        </header>
                        <p> {{comment.Content}} </p>
                        <span class='reply_span'>回复</span><br/>
                    </article>
                    <ul class="list-group">
                        <li v-for="reply in comment.Replys" class="list-group-item">
                            <div tag_id ="{{reply.Id}}" tag_name ="{{reply.NickName}}">
                                <article>
                                    <header>
                                        <p class='name'> {{reply.Nickname}}&nbsp;&nbsp;<c>回复</c>&nbsp;&nbsp; {{reply.ReplyerName}} </p>
                                        <time class='time'> {{new Date(reply.Time).Format("yyyy-MM-dd hh:mm:ss")}} </time>
                                    </header>
                                    <p> {{reply.Content}} </p>
                                    <span class='reply_span'>回复</span><br/>
                                </article>
                            </div>
                        </li>
                    </ul>
                </div>
            </li>
        </ul>
    </div>
</template>
<script>
    import request from 'superagent/lib/client'

    export default {
        data(){
            return{
                comments:[]
            }
        },
        created () {
            let that = this;
            request.get('/api/comment_list')
                    .set('Accept', 'application/json')
                    .end(function(err, res){
                        if (err == null){
                            that.comments = JSON.parse(res.text).data;
                        }
                    });
        }
    };
</script>