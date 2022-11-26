<template>
    <div v-loading="loading" style="min-height: 600px">
        <el-card shadow="never">
            <div v-if="text" class="markdown-body" v-html="$markdown(text)"></div>
            <div v-else style="min-height: 400px;margin-bottom: 20px;padding: 20px 0px 20px 0px;text-align: center">
                <font style="font-size: 30px;color:#dddddd ">
                    <b>◔ ‸◔？没有博客介绍</b>
                </font>
            </div>
        </el-card>
    </div>
</template>
<script>
import ProjectApi from '@/api/project'

export default {
        data() {
            return {
                loading: false,
                text: ""
            }
        },
        mounted() {
            this.loading = true
            ProjectApi.getBlogReadme().then((response) => {
                let result = response.data
                let base64 = require('js-base64').Base64
                this.text = base64.decode(result.content)
            }).then(() => this.loading = false).catch(() => this.loading = false)
        }
    }
</script>

<style>
</style>
