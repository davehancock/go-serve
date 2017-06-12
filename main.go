package main

import (
	"net/http"
	"os"
	"fmt"
	"io/ioutil"
)

const port = ":8085"
const version = "1.4.1"

func main() {

	fmt.Println("Starting go-serve...")

	http.HandleFunc("/", handleStuff)
	http.ListenAndServe(port, nil)
}

func handleStuff(w http.ResponseWriter, r *http.Request) {

	var content = "Current version is: " + version + "\n" +
		"App Env: " + os.Getenv("SERVE_ENV") + "\n" +
		"Running on host: " + resolveHostname() + "\n" +
		"Within Availabilty Zone: " + resolveAvailabilityZone()

	w.WriteHeader(http.StatusOK)
	w.Write([]byte(content))
}

// Mini hack to get hostname from EC2 Instance Metadata from within a container, just to demonstrate
func resolveHostname() string {
	return retrieveMetaData("/hostname")
}

func resolveAvailabilityZone() string {
	return retrieveMetaData("/placement/availability-zone/")
}

func retrieveMetaData(path string) string {

	resp, err := http.Get("http://169.254.169.254/latest/meta-data" + path)
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

	resolvedMetadataValue := string(hostname)
	fmt.Println("Resolved metadata value was: " + resolvedMetadataValue)

	return resolvedMetadataValue

	//http://169.254.169.254/latest/meta-data/placement/availability-zone/
}
