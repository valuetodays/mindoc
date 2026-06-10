<div class="footer">
    <div class="container">
        <div class="row text-center border-top">
            <span><a href="https://mindoc.cn" target="_blank">{{i18n .Lang "common.official_website"}}</a></span>
            <span>&nbsp;·&nbsp;</span>
            <span><a href="https://github.com/mindoc-org/mindoc/issues" target="_blank">{{i18n .Lang "common.feedback"}}</a></span>
            <span>&nbsp;·&nbsp;</span>
            <span><a href="https://github.com/mindoc-org/mindoc" target="_blank">{{i18n .Lang "common.source_code"}}</a></span>
            <span>&nbsp;·&nbsp;</span>
            <span><a href="https://mindoc.cn/docs/mindochelp" target="_blank">{{i18n .Lang "common.manual"}}</a></span>
        </div>
        {{if .site_beian}}
        <div class="row text-center">
            <a href="https://beian.miit.gov.cn/" target="_blank">{{.site_beian}}</a>
        </div>
        {{end}}
    </div>
</div>
{{if eq .ENABLE_WATERMARK "true"}}
<script type="text/javascript">
(function () {
    var text = {{.WatermarkTextJS}};
    if (!text) {
        return;
    }
    function renderWatermark() {
        if (document.getElementById("mindoc-watermark")) {
            return;
        }
        var canvas = document.createElement("canvas");
        canvas.width = 260;
        canvas.height = 180;
        var ctx = canvas.getContext("2d");
        ctx.translate(130, 90);
        ctx.rotate(-Math.PI / 6);
        ctx.font = "16px Arial";
        ctx.fillStyle = "rgba(0, 0, 0, 0.08)";
        ctx.textAlign = "center";
        ctx.textBaseline = "middle";
        ctx.fillText(text, 0, 0);

        var style = document.createElement("style");
        style.type = "text/css";
        style.appendChild(document.createTextNode("@media print { #mindoc-watermark { display: none !important; } }"));
        document.head.appendChild(style);

        var layer = document.createElement("div");
        layer.id = "mindoc-watermark";
        layer.style.cssText = "pointer-events:none;position:fixed;left:0;top:0;right:0;bottom:0;z-index:2147483647;background-repeat:repeat;background-image:url(" + canvas.toDataURL("image/png") + ");";
        document.body.appendChild(layer);
    }
    if (document.readyState === "loading") {
        document.addEventListener("DOMContentLoaded", renderWatermark);
    } else {
        renderWatermark();
    }
})();
</script>
{{end}}
{{.SiteScript}}
