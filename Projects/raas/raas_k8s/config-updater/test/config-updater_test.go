package main

import (
	"config-updater/internal/cu"
	"config-updater/internal/raas"
	"reflect"
	"testing"
)

func TestLoadEmptyPasswordsFile(t *testing.T) {
	cu := new(cu.ConfigUpdater)
	got := cu.LoadPasswords("/dev/null")
	if len(got) != 0 {
		t.Errorf("got: %v", got)
	}
}

func TestLoadPasswordsFile(t *testing.T) {
	cu := new(cu.ConfigUpdater)
	got := cu.LoadPasswords("testdata/etc_bast_config.json")
	if len(got) != 2 {
		t.Errorf("expected 2 passwords, got: %v", got)
	}
}

func TestSetPasswordsToEmptyServers(t *testing.T) {
	cu := new(cu.ConfigUpdater)
	passwords := cu.LoadPasswords("testdata/etc_bast_config.json") // has passwords for "foo" and "bar"
	var servers []raas.Server
	cu.SetPasswords(passwords, servers)
	if len(servers) != 0 {
		t.Errorf("test %v", cu)
	}
}

func TestSetPasswords(t *testing.T) {
	cu := new(cu.ConfigUpdater)
	passwords := cu.LoadPasswords("testdata/etc_bast_config.json") // has passwords for "foo" and "bar"
	var servers, expected []raas.Server
	var server raas.Server

	server = raas.Server{ReplicationGroupId: "foo", Host: "testhostfoo", Port: 6379, Engine: "redis"}
	servers = append(servers, server)
	server = raas.Server{ReplicationGroupId: "foo2", Host: "testhostfoo2", Port: 6379, Engine: "redis"}
	servers = append(servers, server)
	// memcached clusters don't have ReplicationGroupId
	server = raas.Server{Host: "testhostfoo3", Port: 6379, Engine: "redis"}
	servers = append(servers, server)
	cu.SetPasswords(passwords, servers)

	server = raas.Server{ReplicationGroupId: "foo", Host: "testhostfoo", Port: 6379, Engine: "redis", Password: "foopassword"}
	expected = append(expected, server)
	server = raas.Server{ReplicationGroupId: "foo2", Host: "testhostfoo2", Port: 6379, Engine: "redis"}
	expected = append(expected, server)
	server = raas.Server{Host: "testhostfoo3", Port: 6379, Engine: "redis"}
	expected = append(expected, server)

	if !reflect.DeepEqual(servers, expected) {
		t.Errorf("unexpected: %v", servers)
	}
}
