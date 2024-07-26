package main

import (
	"config-updater/internal/aws"
	"log"
	"os"
)

func main() {
  log.SetOutput(os.Stdout)
  log.Printf("I, starting")

  ec := aws.AWSElastiCache {Region: "us-west-2"}
  ec.InitAWSElastiCacheService()

  servers := ec.QueryServers()
	log.Printf("I, servers=%v", servers)
}
