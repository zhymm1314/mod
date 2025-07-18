package routes

import (
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
)

// SetApiGroupRoutes 定义 api 分组路由
func SetApiGroupRoutes(router *gin.RouterGroup) {
	router.GET("/ping", func(c *gin.Context) {
		c.String(http.StatusOK, "pong")
	})

	router.GET("/test", func(c *gin.Context) {
		time.Sleep(5 * time.Second)

		c.String(http.StatusOK, "success")
	})

	// 注册认证和用户相关的路由
	SetAuthGroupRoutes(router)

	// 注册 Mod 相关的路由
	SetModGroupRoutes(router)
}
