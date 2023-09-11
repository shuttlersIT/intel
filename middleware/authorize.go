package middleware

import (
	"net/http"

	"github.com/gin-gonic/contrib/sessions"
	"github.com/gin-gonic/gin"
)

// AuthorizeRequest is used to authorize a request for a certain end-point group.
/*
func AuthorizeRequest() gin.HandlerFunc {
	return func(c *gin.Context) {
		session := sessions.Default(c)
		v := session.Get("user_id")
		if v == nil {
			c.HTML(http.StatusUnauthorized, "login.html", gin.H{"message": "Please login."})
			c.Abort()
		}
		c.Next()
	}
}*/

func AuthorizeRequest() gin.HandlerFunc {
	return func(c *gin.Context) {
		session := sessions.Default(c)
		var count int
		v := session.Get("count")
		if v == nil {
			count = 0
			c.HTML(http.StatusUnauthorized, "login.html", gin.H{"message": "Please login."})
			c.Abort()
		} else {
			count = v.(int)
			count += 1
		}
		session.Set("count", count)
		session.Save()
		c.JSON(200, gin.H{"count": count})
		c.Next()
	}
}
