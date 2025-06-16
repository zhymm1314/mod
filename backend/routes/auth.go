package routes

import (
	"gin-web/app/common/request"
	app "gin-web/app/controllers"
	"gin-web/app/middleware"
	"gin-web/app/services"
	"net/http"

	"github.com/gin-gonic/gin"
)

// SetAuthGroupRoutes 定义认证和用户相关的路由
func SetAuthGroupRoutes(router *gin.RouterGroup) {
	router.POST("/user/register", func(c *gin.Context) {
		var form request.Register
		if err := c.ShouldBindJSON(&form); err != nil {
			c.JSON(http.StatusOK, gin.H{
				"error": request.GetErrorMsg(form, err),
			})
			return
		}
		c.JSON(http.StatusOK, gin.H{
			"message": "success",
		})
	})

	router.POST("/auth/register", app.Register)
	router.POST("/auth/login", app.Login)

	authRouter := router.Group("").Use(middleware.JWTAuth(services.AppGuardName))
	{
		authRouter.POST("/auth/info", app.Info)
		authRouter.POST("/auth/logout", app.Logout)
	}
}
