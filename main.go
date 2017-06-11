package main

import (
	"net/http"
	"os"
	"fmt"
	"io/ioutil"
)

const port = ":8085"
const version = "1.3"

func main() {

	fmt.Println("Starting go-serve...")

	http.HandleFunc("/stuff", handleStuff)
	http.ListenAndServe(port, nil)
}

func handleStuff(w http.ResponseWriter, r *http.Request) {

	var content = "Current version is: " + version + ", " +
		"App Env: " + os.Getenv("SERVE_ENV") + ", " +
		"Running on host: " + resolveHostname()

	w.WriteHeader(http.StatusOK)
	w.Write([]byte(content))
}

// Mini hack to get hostname from EC2 Instance Metadata from within a container, just to demonstrate
func resolveHostname() string {

	resp, err := http.Get("http://169.254.169.254/latest/meta-data/hostname")
	if err != nil {
		fmt.Println("error reaching metadata service: " + err.Error())
		return "Unknown"
	}
	defer resp.Body.Close()

	hostname, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		fmt.Println("error reading body: " + err.Error())
		return "Unknown"
	}

	resolvedHostname := string(hostname)
	fmt.Println("Resolved Hostname was: " + resolvedHostname)

	return resolvedHostname
}
