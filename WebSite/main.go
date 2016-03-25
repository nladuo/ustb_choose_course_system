package main

import (
	_ "github.com/Go-SQL-Driver/MySQL"
	"github.com/gin-gonic/gin"
	"github.com/jinzhu/gorm"
	"net/http"
	"time"
)

const (
	DB_USER   = "root"
	DB_PASSWD = "root"
	DB_HOST   = "localhost"
	DB_PORT   = "3306"
	DBNAME    = "ustb_choose_course"
)

type App struct {
	Id         int
	TypeName   string
	AppName    string
	Version    float64
	Note       string
	UpdateNote string
}

type MessageBoard struct {
	Id          int
	ParentId    int
	Nickname    string
	ReplyerName string
	Content     string
	Time        time.Time
}

func main() {
	db, err := connectDB()
	if err != nil {
		panic(err)
	}
	var apps []App
	db.Find(&apps)

	router := gin.Default()

	router.Static("/css", "./public/css")
	router.Static("/js", "./public/js")
	router.Static("/imgs", "./public/imgs")
	router.Static("/downloads", "./public/downloads")
	router.StaticFile("/", "./public")
	router.GET("/app_list", handleAppList)
	router.GET("/comment_list", handleCommentList)
	router.POST("/add", handleAddComment)
	router.Run(":3000")
}

func handleAddComment(c *gin.Context) {

}

func handleAppList(c *gin.Context) {
	db, err := connectDB()
	if err != nil {
		responseErr(c)
	}
	apps := []App{}
	db.Find(&apps)
	responseSuccess(c, apps)
	db.Close()
}
func handleCommentList(c *gin.Context) {
	db, err := connectDB()
	if err != nil {
		responseErr(c)
	}
	msgs := []MessageBoard{}
	db.Find(&msgs)
	responseSuccess(c, msgs)
	db.Close()
}

func connectDB() (*gorm.DB, error) {
	return gorm.Open("mysql", DB_USER+":"+DB_PASSWD+"@tcp("+DB_HOST+":"+DB_PORT+")/"+DBNAME+"?charset=utf8&parseTime=True")
}

func responseErr(c *gin.Context) {
	c.JSON(http.StatusForbidden, gin.H{
		"code": "2",
	})
}

func responseSuccess(c *gin.Context, data interface{}) {
	c.JSON(http.StatusOK, gin.H{
		"code": "0",
		"data": data,
	})
}
