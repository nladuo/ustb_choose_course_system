//The Website BackEnd of ustb_choose_course_system
package main

import (
	_ "github.com/Go-SQL-Driver/MySQL"
	"github.com/gin-gonic/gin"
	"github.com/jinzhu/gorm"
	"net/http"
	"strconv"
	"time"
)

// database config
const (
	DB_USER   = "root"
	DB_PASSWD = "root"
	DB_HOST   = "localhost"
	DB_PORT   = "3306"
	DBNAME    = "ustb_choose_course"
)

const DEFAULT_POST = "DEFAULT_POST"

type App struct {
	Id         int     `json:"id"`
	TypeName   string  `json:"type_name"`
	AppName    string  `json:"app_name"`
	Version    float64 `json:"version"`
	Note       string  `json:"note"`
	UpdateNote string  `json:"update_note"`
}

type MessageBoard struct {
	Id          int       `json:"id"`
	ParentId    int       `json:"parent_id"`
	Nickname    string    `json:"nickname"`
	ReplyerName string    `json:"replyer_name"`
	Content     string    `json:"content"`
	Time        time.Time `json:"time"`
}

func main() {
	router := gin.Default()

	router.Static("/css", "./www/css")
	router.Static("/js", "./www/js")
	router.Static("/imgs", "./www/imgs")
	router.Static("/downloads", "./www/downloads")
	router.StaticFile("/", "./www")
	router.GET("/api/app_list", handleAppList)
	router.GET("/api/comment_list", handleCommentList)
	router.GET("/api/add", func(c *gin.Context) {
		c.Redirect(http.StatusOK, "/")
	})
	router.GET("download", handleDownload)
	router.GET("/update", handleCheckUpdate)
	router.POST("/api/add", handleAddComment)
	router.Run(":3000")
}

func handleDownload(c *gin.Context) {
	db, err := connectDB()
	if err != nil {
		responseErr(c)
	}
	id := c.Query("id")
	if len(id) == 0 {
		responseErr(c)
		return
	}
	app := App{}
	db.Where("id=?", id).First(&app)
	if app.Id == 0 {
		responseErr(c)
		return
	}
	c.Redirect(http.StatusFound, "/downloads/"+app.AppName)
	db.Close()
}

func handleCheckUpdate(c *gin.Context) {
	db, err := connectDB()
	if err != nil {
		responseErr(c)
		return
	}
	id := c.Query("id")
	if len(id) == 0 {
		responseErr(c)
		return
	}
	app := App{}
	db.Where("id=?", id).First(&app)
	c.JSON(http.StatusOK, gin.H{
		"id":          app.Id,
		"version":     app.Version,
		"app_name":    app.AppName,
		"update_note": app.UpdateNote,
	})
	db.Close()
}

func handleAddComment(c *gin.Context) {
	db, err := connectDB()
	if err != nil {
		c.Redirect(http.StatusFound, "/")
		return
	}
	parent_id := c.DefaultPostForm("parent_id", DEFAULT_POST)
	name := c.DefaultPostForm("name", DEFAULT_POST)
	comment := c.DefaultPostForm("comment", DEFAULT_POST)
	replyer_name := c.DefaultPostForm("replyer_name", DEFAULT_POST)
	if !(parent_id == DEFAULT_POST || name == DEFAULT_POST ||
		replyer_name == DEFAULT_POST || comment == DEFAULT_POST) {

		i_parent_id, err := strconv.ParseInt(parent_id, 10, 32)
		if err == nil {
			db.Create(&MessageBoard{
				ParentId:    int(i_parent_id),
				Nickname:    name,
				ReplyerName: replyer_name,
				Content:     comment,
				Time:        time.Now(),
			})
		}
	}
	db.Close()
	c.Redirect(http.StatusFound, "/")
}

func handleAppList(c *gin.Context) {
	db, err := connectDB()
	if err != nil {
		responseErr(c)
		return
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
		return
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
