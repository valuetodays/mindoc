<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <title>{{.SITE_NAME}} - Powered by MinDoc</title>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="renderer" content="webkit">
    <meta name="author" content="Minho" />
    <meta name="site" content="https://www.iminho.me" />
    <meta name="keywords" content="MinDoc,文档在线管理系统,WIKI,wiki,wiki在线,文档在线管理,接口文档在线管理,接口文档管理">
    <meta name="description" content="MinDoc文档在线管理系统 {{.site_description}}">
    <!-- Bootstrap -->
    <link href="{{cdncss "/static/bootstrap/css/bootstrap.min.css"}}" rel="stylesheet">
    <link href="{{cdncss "/static/font-awesome/css/font-awesome.min.css"}}" rel="stylesheet">
    <link href="{{cdncss "/static/css/main.css" "version"}}" rel="stylesheet">
    <script type="text/javascript">
        window.updateBookOrder = "{{urlfor "BookController.UpdateBookOrder"}}";
    </script>
</head>
<body>
<div class="manual-reader manual-container">
    {{template "widgets/header.tpl" .}}
    <div class="container manual-body">
        <section class="home-hero">
            <div class="home-hero-content">
                <h1>个人知识库 / 技术沉淀 / 财富实验室</h1>
                <p>
                    这里记录长期积累的技术问题、系统设计、生产复盘、财富实验与个人观察。<br>
                    不是碎片收藏，而是持续维护的个人知识系统。
                </p>
            </div>
            <div class="home-hero-tags">
                <span>持续维护</span>
                <span>真实问题复盘</span>
                <span>财富实验室</span>
                <span>技术与系统沉淀</span>
            </div>
        </section>
        <section class="home-entry-list">
            <a href="#" class="home-entry-card">
                <strong>财富实验室</strong>
                <span>记录真实观察、实验验证与财富相关规律。</span>
            </a>
            <a href="#" class="home-entry-card">
                <strong>生产问题复盘</strong>
                <span>沉淀真实线上问题、排查过程与解决方案。</span>
            </a>
            <a href="#" class="home-entry-card">
                <strong>开发技术沉淀</strong>
                <span>记录 Java、Quarkus、Spring Boot、前后端开发经验。</span>
            </a>
            <a href="#" class="home-entry-card">
                <strong>基础设施与运维</strong>
                <span>记录 Docker、Nginx、日志、监控、部署等内容。</span>
            </a>
        </section>
        <div class="row">
             <div class="manual-list home-book-directory">
                <div class="home-book-directory-head">
                    <strong>知识库目录</strong>
                    <span>按主题进入长期维护的知识库</span>
                </div>
                {{range $index,$item := .Lists}}
                    <a href="{{urlfor "DocumentController.Index" ":key" $item.Identify}}" class="home-book-link" data-id="{{$item.BookId}}" title="{{$item.BookName}}">
                        {{$item.BookName}}
                    </a>
                {{else}}
                    <div class="home-book-empty">{{i18n $.Lang "message.no_project"}}</div>
                {{end}}
                <div class="clearfix"></div>
            </div>
        </div>
    </div>
    {{template "widgets/footer.tpl" .}}
</div>
<script src="{{cdnjs "/static/jquery/1.12.4/jquery.min.js"}}" type="text/javascript"></script>
<script src="{{cdnjs "/static/bootstrap/js/bootstrap.min.js"}}" type="text/javascript"></script>
<script src="{{cdnjs "/static/layer/layer.js"}}"></script>
<script src="{{cdnjs "/static/js/sort.js"}}" type="text/javascript"></script>
{{.Scripts}}
</body>
</html>
