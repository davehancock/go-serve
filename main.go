package main

import (
	"net/http"
	"os"
	"fmt"
)

const port = ":8085"
const version = "1.0"

func main() {

	fmt.Println("Starting go-serve...")

	http.HandleFunc("/stuff", handleStuff)
	http.ListenAndServe(port, nil)
}

func handleStuff(w http.ResponseWriter, r *http.Request) {

	var content = "Current version is: " + version + ", " +
		"App Env: " + os.Getenv("SERVE_ENV") + ", " +
		"Running on host: " + os.Getenv("HOSTNAME")

	w.WriteHeader(http.StatusOK)
	w.Write([]byte(content))
}
