package routes

import (
	app "gin-web/app/controllers"

	"github.com/gin-gonic/gin"
)

// SetModGroupRoutes 定义 Mod 相关的路由
func SetModGroupRoutes(router *gin.RouterGroup) {
	modController := &app.ModController{}
	{
		router.GET("/mods/search", modController.Search)         // 搜索mod
		router.GET("/mods/:id", modController.Detail)            // 获取mod详情
		router.GET("/mods/:id/download", modController.Download) // 下载mod
		router.GET("/games", modController.Games)                // 获取游戏列表
		router.GET("/categories", modController.Categories)      // 获取分类列表
	}
}
