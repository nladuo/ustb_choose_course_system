<template>
    <div class="container">
        <h1>北科大选课系统第三方客户端</h1>
        <h4 style="line-height: 1.6">功能：PC版(Window、Mac、Linux)支持退补选课，课表查询。移动版(Android、iOS)支持退补选课，预选课，课表查询，考试安排查询以及创新学分查询</h4>
        <h4>使用注意：登陆密码是选课系统的密码,不是本科教学网的密码</h4>
        <h4>软件说明：本软件为开源软件，目前UI比较简陋。</h4>
        <h4>源码地址：<a href="https://github.com/nladuo/ustb_choose_course_system">https://github.com/nladuo/ustb_choose_course_system</a></h4>
        <dowload_view></dowload_view>
        <comment_view></comment_view>
        <footer_view></footer_view>
    </div>
</template>

<script type="text/ecmascript-6">
    import DownloadView from './DownloadView.vue'
    import FooterView from './FooterView.vue'
    import CommentView from './CommentView.vue'

    export default {
        components: {
            dowload_view:DownloadView,
            comment_view:CommentView,
            footer_view:FooterView
        }
    }
</script>