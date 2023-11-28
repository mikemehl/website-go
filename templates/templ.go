package templates

import (
	_ "embed"
	"html/template"
)

//go:embed education.html
var education string

//go:embed experience.html
var experience string

//go:embed index.html
var index string

//go:embed intro.html
var intro string

//go:embed skills.html
var skills string

//go:embed music.html
var music string

func create(name, def string) *template.Template {
	return template.Must(template.New(name).Parse(def))
}

var Templates = map[string]*template.Template{
	"/education/":  create("education", education),
	"/experience/": create("experience", experience),
	"/index/":      create("index", index),
	"/intro/":      create("intro", intro),
	"/skills/":     create("skills", skills),
	"/music/":      create("music", music),
}
