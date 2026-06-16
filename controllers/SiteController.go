package controllers

import (
	neturl "net/url"
	"regexp"
	"strconv"
	"strings"

	"github.com/mindoc-org/mindoc/conf"
)

type SiteController struct {
	BaseController
}

var blogURLPattern = regexp.MustCompile(`^/blog-([0-9]+)\.html$`)

func (c *SiteController) About() {
	c.Prepare()

	aboutURL := strings.TrimSpace(c.Option["site_about_url"])
	if aboutURL == "" {
		c.Abort("404")
	}

	aboutPath := aboutURL
	if u, err := neturl.Parse(aboutURL); err == nil && u.Path != "" {
		aboutPath = u.Path
	}
	if !strings.HasPrefix(aboutPath, "/") {
		aboutPath = "/" + aboutPath
	}

	if matches := blogURLPattern.FindStringSubmatch(aboutPath); len(matches) == 2 {
		if !c.EnableAnonymous && c.Member == nil {
			c.Redirect(conf.URLFor("AccountController.Login")+"?url="+neturl.PathEscape(conf.BaseUrl+c.Ctx.Request.URL.RequestURI()), 302)
		}
		blogId, _ := strconv.Atoi(matches[1])
		renderBlog(&c.BaseController, blogId)
		return
	}

	c.Redirect(aboutURL, 302)
}
