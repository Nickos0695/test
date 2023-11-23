package api

import (
    "github.com/gin-gonic/gin"
)

type Notes struct {
    Id   int    `gorm:"AUTO_INCREMENT" form:"id" json:"id"`
    Title string `gorm:"not null" form:"title" json:"title"`
	Text  string `gorm:"not null" form:"text" json:"text"`
}

// Ajouter une note
func PostNote(c *gin.Context) {
    db := InitDb()
    defer db.Close()

    var json Notes
    c.Bind(&json)

    // Si les champs sont bien saisies
    if json.Title != "" && json.Text != "" {
        // INSERT INTO "notes" (name) VALUES (json.Title, json.Text);
        db.Create(&json)
        // Affichage des données saisies
        c.JSON(201, gin.H{"success": json})
    } else {
        // Affichage de l'erreur
        c.JSON(422, gin.H{"error": "Fields are empty"})
    }
}

// Récupérer la liste des notes
func GetNotes(c *gin.Context) {
	db := InitDb()
	defer db.Close()

	var notes []Notes
	// SELECT * FROM notes;
	db.Find(&notes)

	// Affichage des notes
	c.JSON(200, notes)
}

// Récupérer une note
func GetNote (c *gin.Context) {
	db := InitDb()
	defer db.Close()

	id := c.Params.ByName("id")
	var note Notes
	// SELECT * FROM notes WHERE id = 1;
	db.First(&note, id)

	// Affichage de la note
	c.JSON(200, note)
}

// Modifier une note
func EditNote (c *gin.Context) {
	db := InitDb()
	defer db.Close()

	id := c.Params.ByName("id")
	var note Notes
	// SELECT * FROM notes WHERE id = 1;
	db.First(&note, id)

	var json Notes
	c.Bind(&json)

	// Si les champs sont bien saisies
	if json.Title != "" && json.Text != "" {
		// UPDATE "notes" SET title="json.Title", text="json.Text" WHERE id = note.Id;
		db.Model(&note).Update("Title", json.Title)
		db.Model(&note).Update("Text", json.Text)
		// Affichage des données saisies
		c.JSON(200, gin.H{"success": note})
	} else {
		// Affichage de l'erreur
		c.JSON(422, gin.H{"error": "Fields are empty"})
	}
}

// Supprimer une note
func DeleteNote (c *gin.Context) {
	db := InitDb()
	defer db.Close()

	id := c.Params.ByName("id")
	var note Notes
	// SELECT * FROM notes WHERE id = 1;
	db.First(&note, id)

	// DELETE FROM notes WHERE id = note.Id;
	db.Delete(&note)

	// Affichage des données
	c.JSON(200, gin.H{"success": "Note #" + id + " deleted"})
}

// Supprimer toutes les notes
func DeleteNotes (c *gin.Context) {
	db := InitDb()
	defer db.Close()

	// DELETE FROM notes;
	db.Delete(&Notes{})

	// Affichage des données
	c.JSON(200, gin.H{"success": "All notes deleted"})
}