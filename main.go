package main

import (
	"log"

	"github.com/gin-contrib/sessions"
	"github.com/gin-contrib/sessions/redis"

	//"github.com/gin-contrib/sessions/redis"
	"github.com/gin-gonic/gin"
	"github.com/shuttlersIT/intel/handlers"
	"github.com/shuttlersIT/intel/middleware"
)

func main() {

	//Dashboard APP
	router := gin.Default()
	token, err := handlers.RandToken(64)
	if err != nil {
		log.Fatal("unable to generate random token: ", err)
	}

	store, _ := redis.NewStore(10, "tcp", "127.0.0.1:6379", "", []byte(token))
	store.Options(sessions.Options{
		Path:   "/",
		MaxAge: 86400 * 7,
	})

	router.Use(gin.Logger())
	router.Use(gin.Recovery())
	router.Use(sessions.Sessions("portalsession", store))
	router.Static("/css", "templates/css")
	router.Static("/img", "templates/img")
	router.Static("/js", "templates/js")
	router.LoadHTMLGlob("templates/*.html")

	router.GET("/", handlers.IndexHandler)
	router.GET("/index", handlers.IndexHandler)
	router.GET("/login", handlers.LoginHandler)
	router.GET("/auth", handlers.AuthHandler)
	router.GET("/logout", handlers.LogoutHandler)

	authorized := router.Group("/")
	authorized.Use(middleware.AuthorizeRequest())
	{
		authorized.GET("/portal", handlers.PortalHandler)
		authorized.GET("/cx", handlers.CxHandler)
		authorized.GET("/sales", handlers.SalesHandler)
		authorized.GET("/home", handlers.PerformanceHandler)
		authorized.GET("/marketing", handlers.MarketingHandler)
		authorized.GET("/operations", handlers.OperationsHandler)
		authorized.GET("/driverscorecard", handlers.DriverHandler)
		authorized.GET("/feedbacktracker", handlers.FeedbackHandler)
		authorized.GET("/marshaldashboard", handlers.MarshalHandler)
		authorized.GET("/peopleandculture", handlers.PeopleHandler)
		authorized.GET("/seatoccupancy", handlers.SeatHandler)
		authorized.GET("/shuttlersqa", handlers.QaHandler)
		authorized.GET("/datarequest", handlers.RequestHandler)
	}
	//router.Use(static.Serve("/", static.LocalFile("./templates", true)))

	if err := router.Run(":9193"); err != nil {
		log.Fatal(err)
	}
}
