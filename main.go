package main

import (
	"fmt"
	"net/http"

	"github.com/charmbracelet/log"

	"github.com/mikemehl/website/templates"
)

func main() {
	log.Info("Starting server...")
	http.HandleFunc("/", route)
	http.ListenAndServe(":8080", nil)
}

func route(w http.ResponseWriter, req *http.Request) {
	path := req.URL.JoinPath("./")
	log.Info("Request handling", "path", path)
	if templ := templates.Templates[path.Path]; templ != nil {
		w.WriteHeader(404)
		fmt.Fprintf(w, "Found yr template tho")
	} else {
		w.WriteHeader(404)
		fmt.Fprintf(w, "404 Not Found")
	}
}
