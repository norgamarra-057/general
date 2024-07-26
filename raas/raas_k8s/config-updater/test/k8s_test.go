package main

import (
	"config-updater/internal/raas"
	"config-updater/internal/k8s"
	"io/ioutil"
	"os"
	"reflect"
	"testing"
)

func TestCreateInputConfigMapDataEmptyServers(t *testing.T) {
	k := new(k8s.Kube)
	var servers []raas.Server
	got := k.CreateInputConfigMapData(servers)
	if len(got) != 4 {
		t.Errorf("got: %v", got)
	}
	expected := map[string]string{
		"memcached_input.conf":         "# no servers\n",
		"memcached_latency_input.conf": "# no servers\n",
		"redis_input.conf":             "# no servers\n",
		"redis_latency_input.conf":     "# no servers\n",
	}
	if !reflect.DeepEqual(got, expected) {
		t.Errorf("unexpected: %v", got)
	}
}

func ReadConfigFile(filePath string) string {
	bytes, err := ioutil.ReadFile(filePath)
	if err != nil {
		panic(err)
	}
	return string(bytes)
}

func TestCreateInputConfigMapData(t *testing.T) {
	k := new(k8s.Kube)
	var servers []raas.Server
	var server raas.Server
	os.Setenv("CONF_TPL_PARENT_DIR", "testdata/templates")

	server = raas.Server{ReplicationGroupId: "foor1", Host: "testhostfoo1", Port: 6379, Engine: "redis"}
	servers = append(servers, server)
	server = raas.Server{ReplicationGroupId: "foor2", Host: "testhostfoo2", Port: 6379, Engine: "redis", Password: "foopassword"}
	servers = append(servers, server)
	server = raas.Server{ReplicationGroupId: "foom1", Host: "testhostfoo1", Port: 11211, Engine: "memcached"}
	servers = append(servers, server)
	server = raas.Server{ReplicationGroupId: "foom2", Host: "testhostfoo2", Port: 11211, Engine: "memcached"}
	servers = append(servers, server)

	got := k.CreateInputConfigMapData(servers)
	if len(got) != 4 {
		t.Errorf("got: %v", got)
	}
	expected := map[string]string{
		"memcached_input.conf":         ReadConfigFile("testdata/memcached_input.conf"),
		"memcached_latency_input.conf": ReadConfigFile("testdata/memcached_latency_input.conf"),
		"redis_input.conf":             ReadConfigFile("testdata/redis_input.conf"),
		"redis_latency_input.conf":     ReadConfigFile("testdata/redis_latency_input.conf"),
	}
	if !reflect.DeepEqual(got, expected) {
		t.Errorf("unexpected: %v", got)
	}
}
