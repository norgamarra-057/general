package main

import (
	"daas-config-updater/internal/aws"
	"log"
	"os"
)

func main() {
	log.SetOutput(os.Stdout)
	log.Printf("I, starting")

	ec := aws.AWSRDS{Region: "us-west-2"}
	ec.InitAWSService()

	servers := ec.QueryServers()
	log.Printf("I, servers=%v", servers)
}
