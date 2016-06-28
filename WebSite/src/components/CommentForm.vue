<template>
    <form class="form-horizontal" name="commentform" onsubmit="return isCommentEmpty();" action="/api/add" method="post">
        <fieldset>
            <div class="form-group">
                <label for="textArea" class="col-lg-2 control-label">内容：</label>
                <div class="col-lg-8">
                    <textarea style="resize: none" name="comment" class="form-control" rows="6" id="textArea" placeholder="你可以在这里输入你的吐槽....."></textarea>
                </div>
            </div>

            <div class="form-group">
                <label for="inputEmail" class="col-lg-2 control-label">昵称：</label>
                <div class="col-lg-8">
                    <input type="text" name="name" class="form-control" id="inputEmail" placeholder="请输入你的昵称">
                </div>
            </div>
            <div class="form-group">
                <div class="col-lg-8 col-lg-offset-2">
                    <input name="parent_id" type="hidden" value="0" />
                    <input name="replyer_name" type="hidden" value=" " />
                    <button style="display:block;margin: 0 auto;" type="submit" class="btn btn-primary">发表吐槽</button>
                </div>
            </div>
            <!--<input id="submit" type="submit" value="" />-->
        </fieldset>
    </form>
</template>