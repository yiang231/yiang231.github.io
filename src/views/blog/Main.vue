<template>
    <div v-loading="loading" style="min-height: 600px">
        <el-card shadow="never" style="margin-bottom: 20px">
            <el-input v-model="searchKey" clearable placeholder="请输入关键字" style="width: 300px"></el-input>
            <el-button circle icon="el-icon-search" plain style="margin-left: 10px" @click="search"></el-button>
            <el-button circle icon="el-icon-share" plain style="margin-left: 10px" type="warning" @click="$share()"></el-button>
            <el-button icon="el-icon-edit" plain round style="float: right;" type="primary" @click="goAdd">写博文</el-button>
        </el-card>

        <div v-if="blogs&&blogs.length>0">
            <el-card v-for="(item,index) in blogs" v-if="!item.hide" :key="'p'+index" shadow="hover" style="margin-bottom: 20px">
                <div slot="header">
                    <el-row>
                        <el-col :span="16">
                            <span>
                                <a style="text-decoration:none;cursor:pointer" @click="goDetails(item.id)">
                                    <i class="el-icon-edit-outline"></i>&nbsp;&nbsp; {{item.title}}
                                </a>
                            </span>
                        </el-col>
                        <el-col :span="8">
                            <div style="text-align: right;">
                                <el-button icon="el-icon-share" style="padding: 3px 0" type="text" @click="$share('/user/blog/details/'+item.id)"></el-button>
                                <el-button v-if="token" icon="el-icon-edit" style="padding: 3px 0" type="text" @click="editBlog(index)"></el-button>
                                <el-button v-if="token" icon="el-icon-delete" style="padding: 3px 0" type="text" @click="deleteBlog(index)"></el-button>
                            </div>
                        </el-col>
                    </el-row>
                </div>
                <div style="font-size: 0.9rem;line-height: 1.5;color: #606c71;">
                    最近更新 {{item.updateTime}}
                </div>
                <div style="font-size: 1.1rem;line-height: 1.5;color: #303133;padding: 10px 0px 0px 0px">
                    {{item.description}}
                </div>
            </el-card>
            <div style="text-align: center">
                <el-pagination :current-page.sync="query.page" :page-size="query.pageSize" :total="query.pageNumber*query.pageSize" background layout="prev, pager, next"
                    @current-change="list">
                </el-pagination>
            </div>

        </div>

        <el-card v-if="!blogs||blogs.length==0" shadow="never" style="margin-bottom: 20px;padding: 20px 0px 20px 0px;text-align: center">
            <font style="font-size: 30px;color:#dddddd ">
                <b>还没有博客 (╯°Д°)╯︵ ┻━┻</b>
            </font>
        </el-card>
    </div>
</template>
<script>
    import { mapGetters } from 'vuex'
    import GistApi from '@/api/gist'
    export default {
        data() {
            return {
                query: {
                    page: 1,
                    pageSize: 5,
                    pageNumber: 1
                },
                loading: false,
                searchKey: "",
                blogs: []
            }
        },
        computed: {
            ...mapGetters([
                'token',
            ])
        },
        mounted() {
            this.list()
        },
        methods: {
            list() {
                this.blogs = []
                this.loading = true
                GistApi.list(this.query).then((response) => {
                    let result = response.data
                    let pageNumber = this.$util.parseHeaders(response.headers)
                    if (pageNumber) {
                        this.query.pageNumber = pageNumber
                    }
                    for (let i = 0; i < result.length; i++) {
                        for (let key in result[i].files) {
                            let data = {}
                            data['title'] = key
                            data['url'] = result[i].files[key]
                            data['description'] = result[i]['description']
                            data['id'] = result[i]['id']
                            data['createTime'] = this.$util.utcToLocal(result[i]['created_at'])
                            data['updateTime'] = this.$util.utcToLocal(result[i]['updated_at'])
                            data['hide'] = false
                            this.blogs.push(data)
                            break
                        }
                    }
                }).then(() => this.loading = false)
            },
            search() {
                for (let i = 0; i < this.blogs.length; i++) {
                    this.blogs[i].hide = this.blogs[i].title.indexOf(this.searchKey) < 0
                }
            },
            editBlog(index) {
                if (!this.token) {
                    this.$message({
                        message: '请绑定有效的Token',
                        type: 'warning'
                    })
                    return
                }
                this.$router.push('/user/blog/edit/' + this.blogs[index].id)
            },
            deleteBlog(index) {
                this.$confirm('是否永久删除该博客?', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(() => {
                    let blog = this.blogs[index]
                    GistApi.delete(blog.id).then((result) => {
                        this.$message({
                            message: '删除成功',
                            type: 'success'
                        })
                        this.blogs.splice(index, 1)
                    })
                })
            },
            goAdd() {
                if (!this.token) {
                    this.$message({
                        message: '请绑定有效的Token',
                        type: 'warning'
                    })
                    return
                }
                this.$router.push('/user/blog/add')
            },
            goDetails(id) {
                this.$router.push("/user/blog/details/" + id)
            }
        }
    }
</script>
