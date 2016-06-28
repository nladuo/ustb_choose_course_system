<template>
    <h4 style="font-weight: bold;">对软件不满意？吐个槽：</h4>
    <div id="comments" class="list-group">
        <comment_form></comment_form>
        <comment_list></comment_list>
    </div>
</template>
<script>
    import CommentFrom from './CommentForm.vue'
    import CommentList from './CommentList.vue'
    export default{
        components:{
            comment_form:CommentFrom,
            comment_list:CommentList
        }
    }
</script>