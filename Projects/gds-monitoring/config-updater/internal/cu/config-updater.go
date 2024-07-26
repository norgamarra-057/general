package cu

import (
	"daas-config-updater/internal/aws"
	"daas-config-updater/internal/daas"
	"daas-config-updater/internal/k8s"
	"encoding/json"
	"go.uber.org/zap"
	"io/ioutil"
	"os"
	"reflect"
)

type ConfigUpdater struct {
	Kube     *k8s.Kube
	RDS      *aws.AWSRDS
	Servers  []daas.Server
	Excluded map[string]struct{}
}

func (cu *ConfigUpdater) LoadMonPassword(filePath string) string {
	jsonFile, err := os.Open(filePath)
	if err != nil {
		panic(err)
	}
	defer jsonFile.Close()
	byteValue, _ := ioutil.ReadAll(jsonFile)
	var clusterPasswordMap map[string]string
	json.Unmarshal([]byte(byteValue), &clusterPasswordMap)
	return clusterPasswordMap["mon-password"]
}

func (cu *ConfigUpdater) SetPasswords(password string, servers []daas.Server) {
	// use index, because we're modifying the array
	for i := range servers {
		servers[i].Password = password
	}
}

func (cu *ConfigUpdater) RemoveExcluded(servers []daas.Server) (res []daas.Server) {
	for _, server := range servers {
		if _, ok := cu.Excluded[server.Host]; ok {
			zap.L().Info("excluding", zap.String("dbhost", server.Host))
		} else {
			res = append(res, server)
		}
	}
	return
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
	password := cu.LoadMonPassword("/etc/bast/config.json")
	servers := cu.RDS.QueryServers()
	servers = cu.RemoveExcluded(servers)
	cu.SetPasswords(password, servers)
	if reflect.DeepEqual(servers, cu.Servers) {
		zap.L().Info("servers", zap.Bool("changes_detected", false))
	} else {
		zap.L().Info("servers", zap.Bool("changes_detected", true))
		cu.Kube.DeployTelegraf(servers)
		cu.Servers = servers
	}
	ioutil.WriteFile("/tmp/config-updater.touched-when-healthy", nil, 0644)
}
