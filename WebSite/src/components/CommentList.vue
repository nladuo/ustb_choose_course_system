<template>
    <div id="commentlist">
        <h4>吐槽列表：</h4>
        <ul id="comment_list" class="list-group">
            <h5 v-if="{{comments.length == 0}}">暂无吐糟</h5>

            <li v-for="comment in comments" class="list-group-item">
                <div class="container-fluid">
                    <div class="row">
                        <div class="col-xs-2">
                            <span class='name'> {{comment.Nickname}} </span><br>
                            <time class='time'> {{new Date(comment.Time).Format("yyyy-MM-dd hh:mm:ss")}} </time>
                        </div>
                        <div class="col-xs-10">
                            <p> {{comment.Content}} </p>
                            <div v-if="comment.show_reply_form" >
                                <reply_form :comment="comment"></reply_form>
                            </div>
                            <button class="btn btn-primary btn-xs" v-else v-on:click="show_reply_form(comment)">回复</button><br/>
                        </div>
                    </div>
                    <ul class="list-group">
                        <li v-for="reply in comment.Replys" class="list-group-item">
                            <div class="row">
                                <div class="col-xs-2">
                                    <span> {{reply.Nickname}}&nbsp;&nbsp;<c>回复</c>&nbsp;&nbsp; {{reply.ReplyerName}}  </span><br>
                                    <time> {{new Date(reply.Time).Format("yyyy-MM-dd hh:mm:ss")}} </time>
                                </div>
                                <div class="col-xs-10">
                                    <p> {{reply.Content}} </p>
                                    <div v-if="reply.show_reply_form" >
                                        <reply_form :comment="reply"></reply_form>
                                    </div>
                                    <button class="btn btn-primary btn-xs" v-else v-on:click="show_reply_form(reply)">回复</button><br/>
                                </div>
                            </div>
                        </li>
                    </ul>
                </div>
            </li>
        </ul>
    </div>
</template>
<script type="text/ecmascript-6">
    import request from 'superagent/lib/client'
    import ReplyFrom from './ReplyForm.vue'

    export default {
        components:{
            reply_form: ReplyFrom,
        },
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
                            that.parse_comments(JSON.parse(res.text).data);
                            that.comments.reverse()
                        }
                    });
        },
        methods:{
            no_reply_form(){
                for (var i = 0; i < this.comments.length; i++) {
                    var comment = this.comments[i];
                    comment.show_reply_form = false;
                    for (var j = 0; j < comment.Replys.length; j++){
                        var reply = comment.Replys[j]
                        reply.show_reply_form = false;
                    }
                }

            },
            show_reply_form(comment){
                this.no_reply_form();
                comment.show_reply_form = ~comment.show_reply_form;
            },
            parse_comments(list){//解析评论
                this.comments = [];
                var comment_list = this.get_comments_by_parent_id(list, 0);
                for (var i = 0; i < comment_list.length; i++) {
                    var comment = comment_list[i];
                    comment.show_reply_form = false;
                    comment.Replys = this.parse_replys(list, comment.Id);
                    this.comments.push(comment);
                }
            },
            get_comments_by_parent_id(list, parent_id){//获取制定parent_id的comments
                var comments =[];
                for (var i = 0; i < list.length; i++) {
                    var comment = list[i];
                    if (comment.ParentId == parent_id) {
                        comments.push(comment);
                    }
                }
                return comments;
            },
            parse_replys(list, parent_id){//获取某一个评论的所有回复
                let that = this;
                var comment_replys = [];
                function parse_replys_by_parent_id(list, parent_id){
                    var replys = that.get_comments_by_parent_id(list, parent_id);
                    for (var i = 0; i < replys.length; i++ ) {
                        var reply = replys[i];
                        reply.show_reply_form = false;
                        //递归添加回复，如果下面还有回复的话就添加
                        comment_replys.push(reply);
                        parse_replys_by_parent_id(list, reply.Id);
                    }
                }
                parse_replys_by_parent_id(list, parent_id);
                return comment_replys;
            }
        }
    };
</script>