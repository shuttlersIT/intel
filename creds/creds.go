package creds

import (
	"encoding/json"
	"io/ioutil"
	"log"
	"os"

	"github.com/shuttlersIT/intel/structs"
)

type Credentials structs.Credentials

var Creds Credentials

func SetCredentials() Credentials {
	file, err := ioutil.ReadFile("github.com/shuttlersIT/intel/creds/creds.json")
	if err != nil {
		log.Printf("File error: %v\n", err)
		os.Exit(1)
	}
	if err := json.Unmarshal(file, &Creds); err != nil {
		log.Println("unable to marshal data")
	}

	return Creds
}
