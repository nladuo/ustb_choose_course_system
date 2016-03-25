package main

import (
	"github.com/gin-gonic/gin"
	// "github.com/jinzhu/gorm"
	"net/http"
)

func main() {
	router := gin.Default()

	router.Static("/css", "./public/css")
	router.Static("/js", "./public/js")
	router.Static("/imgs", "./public/imgs")
	router.Static("/downloads", "./public/downloads")
	router.StaticFile("/", "./public")
	router.GET("/app_list", ginHandleAppList)
	router.GET("/comment_list", ginHandleCommentList)
	router.Run(":3000")
}

func ginHandleAppList(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"code": "0",
		"data": "",
	})
}
func ginHandleCommentList(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"code": "0",
		"data": "",
	})
}
