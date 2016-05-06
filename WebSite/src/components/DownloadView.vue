<template>
    <h4>下载列表：</h4>
    <div class="list-group">
        <table class="table table-striped table-hover table-bordered">
            <thead>
                <tr>
                    <th>类别</th>
                    <th>当前版本</th>
                    <th>下载地址</th>
                    <th>说明</th>
                </tr>
            </thead>
            <tbody>
                <tr v-for="app in apps">
                    <td> {{app.TypeName}} </td>
                    <td> {{app.Version}} </td>
                    <td><a href="/downloads/{{app.AppName}}"> {{app.AppName}}  </a></td>
                    <td> {{app.Note}} </td>
                </tr>
            </tbody>
        </table>
    </div>
</template>
<script type="text/ecmascript-6">
    import request from 'superagent/lib/client'

    export default {
        data(){
            return{
                apps:[]
            }
        },
        created () {
            let that = this;
            request.get('/api/app_list')
                    .set('Accept', 'application/json')
                    .end(function(err, res){
                        if (err == null){
                            that.apps = JSON.parse(res.text).data;
                        }
                    });
        }
    };

</script>