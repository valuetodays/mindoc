package controllers

import (
	"math"
	"net/url"
	"regexp"

	"github.com/beego/beego/v2/core/logs"
	"github.com/mindoc-org/mindoc/conf"
	"github.com/mindoc-org/mindoc/models"
	"github.com/mindoc-org/mindoc/utils/pagination"
)

var homeBookTitlePrefixPattern = regexp.MustCompile(`^\d{1,3}-`)

type HomeController struct {
	BaseController
}

func (c *HomeController) Prepare() {
	c.BaseController.Prepare()
	//如果没有开启匿名访问，则跳转到登录页面
	if !c.EnableAnonymous && c.Member == nil {
		c.Redirect(conf.URLFor("AccountController.Login")+"?url="+url.PathEscape(conf.BaseUrl+c.Ctx.Request.URL.RequestURI()), 302)
	}
}

func (c *HomeController) Index() {
	c.Prepare()
	c.TplName = "home/index.tpl"

	pageIndex, _ := c.GetInt("page", 1)
	pageSize := 18
	memberId := 0
	if c.Member != nil {
		memberId = c.Member.MemberId
	}
	books, totalCount, err := models.NewBook().FindForHomeToPager(pageIndex, pageSize, memberId)
	if err != nil {
		logs.Error(err)
		c.Abort("500")
	}
	homePins, err := models.NewBook().FindHomePins(4)
	if err != nil {
		logs.Error(err)
		c.Abort("500")
	}
	for _, item := range homePins {
		item.BookName = homeBookTitlePrefixPattern.ReplaceAllString(item.BookName, "")
	}
	if totalCount > 0 {
		pager := pagination.NewPagination(c.Ctx.Request, totalCount, pageSize, c.BaseUrl())
		c.Data["PageHtml"] = pager.HtmlPages()
	} else {
		c.Data["PageHtml"] = ""
	}
	c.Data["TotalPages"] = int(math.Ceil(float64(totalCount) / float64(pageSize)))
	c.Data["HomePins"] = homePins
	c.Data["Lists"] = books
}
