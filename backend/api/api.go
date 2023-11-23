package api

import (
    "github.com/gin-gonic/gin"
    "github.com/jinzhu/gorm"
    _ "github.com/mattn/go-sqlite3"
)

func InitDb() *gorm.DB {
    // Ouverture du fichier
    db, err := gorm.Open("sqlite3", "./data.db")
    db.LogMode(true)

    // Création de la table
    if !db.HasTable(&Notes{}) {
        db.CreateTable(&Notes{})
        db.Set("gorm:table_options", "ENGINE=InnoDB").CreateTable(&Notes{})
    }

    // Erreur de chargement
    if err != nil {
        panic(err)
    }

    return db
}

func Handlers() *gin.Engine {
    r := gin.Default()
	r.Use(Cors())

    v1Notes := r.Group("api/v1/notes")
    {
        v1Notes.POST("", PostNote)
        v1Notes.GET("", GetNotes)
        v1Notes.GET(":id", GetNote)
        v1Notes.PUT(":id", EditNote)
        v1Notes.DELETE(":id", DeleteNote)
		v1Notes.DELETE("", DeleteNotes) // POST
    }

    return r
}

// Activation du CORS
func Cors() gin.HandlerFunc {
	return func(c *gin.Context) {
		c.Writer.Header().Add("Access-Control-Allow-Origin", "*")
		c.Next()
	}
}