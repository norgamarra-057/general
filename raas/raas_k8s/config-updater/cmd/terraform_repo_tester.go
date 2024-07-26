package main

import (
	"config-updater/internal/terraform_repo"
	"log"
	"os"
)

func main() {
  log.SetOutput(os.Stdout)
  log.Printf("I, starting")
	url := "https://raw.github.groupondev.com/data/raas_terraform_modules/master/source/redis_instances.yml"
	res := terraform_repo.FetchResqueClustersWithNs(url)
	log.Printf("I, clusters=%v", res)
}
