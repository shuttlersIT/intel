package creds

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"os"

	"github.com/shuttlersIT/intel/structs"
)

type Credentials structs.Credentials

var Creds Credentials

func SetCredentials() Credentials {
	// Open our jsonFile
	jsonFile, err := os.Open("creds.json")
	// if we os.Open returns an error then handle it
	if err != nil {
		fmt.Println(err)
	}
	fmt.Println("Successfully Creds")
	// defer the closing of our jsonFile so that we can parse it later on
	defer jsonFile.Close()

	file, err := ioutil.ReadAll(jsonFile)
	if err != nil {
		log.Printf("File error: %v\n", err)
		os.Exit(1)
	}
	if err := json.Unmarshal(file, &Creds); err != nil {
		log.Println("unable to marshal data")
	}

	return Creds
}
