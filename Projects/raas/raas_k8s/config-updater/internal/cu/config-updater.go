package cu

import (
	"config-updater/internal/aws"
	"config-updater/internal/k8s"
	"config-updater/internal/raas"
	"config-updater/internal/terraform_repo"
	"encoding/json"
	"go.uber.org/zap"
	"io/ioutil"
	"os"
	"reflect"
	"strings"
)

type ConfigUpdater struct {
	Kube       *k8s.Kube
	Ec         *aws.AWSElastiCache
	Servers    []raas.Server
	TfRedisUrl string
}

func (cu *ConfigUpdater) LoadPasswords(filePath string) (clusterPasswordMap map[string]string) {
	jsonFile, err := os.Open(filePath)
	if err != nil {
		panic(err)
	}
	defer jsonFile.Close()
	byteValue, _ := ioutil.ReadAll(jsonFile)
	json.Unmarshal([]byte(byteValue), &clusterPasswordMap)
	return
}

func (cu *ConfigUpdater) SetPasswords(clusterPasswordMap map[string]string, servers []raas.Server) {
	// use index, because we're modifying the array
	for i := range servers {
		if password, found := clusterPasswordMap[servers[i].ReplicationGroupId]; found {
			servers[i].Password = password
		}
	}
}

func (cu *ConfigUpdater) SetResque(resque map[string]string, servers []raas.Server) {
	// use index, because we're modifying the array
	for i := range servers {
		if servers[i].Engine != "redis" {
			continue
		}
		// example: foo-staging
		tmp := servers[i].ReplicationGroupId
		// example: foo
		resource_name := tmp[0:strings.LastIndex(tmp, "-")]
		if ns, found := resque[resource_name]; found {
			servers[i].Resque = true
			servers[i].ResqueNs = ns
		}
	}
}

// prevents panic
func (cu *ConfigUpdater) AutoRecover() {
	if r := recover(); r != nil {
		zap.L().Error("ConfigUpdater.AutoRecover")
	}
}

func (cu *ConfigUpdater) UpdateConfigOnChanges() {
	defer cu.AutoRecover() // prevents panic on main loop
	zap.L().Info("ConfigUpdater.UpdateConfigOnChanges")
	passwords := cu.LoadPasswords("/etc/bast/config.json")
	resque := terraform_repo.FetchResqueClustersWithNs(cu.TfRedisUrl)
	servers := cu.Ec.QueryServers()
	cu.SetPasswords(passwords, servers)
	cu.SetResque(resque, servers)
	if reflect.DeepEqual(servers, cu.Servers) {
		zap.L().Info("servers", zap.Bool("changes", false))
	} else {
		zap.L().Info("servers", zap.Bool("changes", true))
		cu.Kube.DeployTelegraf(servers)
		cu.Servers = servers
	}
	ioutil.WriteFile("/tmp/config-updater.touched-when-healthy", nil, 0644)
}
