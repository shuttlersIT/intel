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

func SetCredentials() Credentials {
	var Creds Credentials
	file, err := ioutil.ReadFile("creds/creds.json")
	if err != nil {
		log.Printf("File error: %v\n", err)
		os.Exit(1)
	}
	json.Unmarshal(file, &Creds)
	fmt.Println(Creds.Cid)
	return Creds
}
