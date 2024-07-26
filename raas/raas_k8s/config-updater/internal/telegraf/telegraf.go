package telegraf

import (
	"io/ioutil"
	"os"
	"path/filepath"
	"strconv"
	"strings"
	"config-updater/internal/raas"
)


func RedisInputConf(servers []raas.Server) string {
	tplPath := filepath.Join(os.Getenv("CONF_TPL_PARENT_DIR"),"telegraf-redis-conf-tpl/redis.conf.tpl")
	var sections []string
	chunkSize := 100
	for i := 0; i < len(servers); i += chunkSize {
		end := i + chunkSize
	    if end > len(servers) {
	        end = len(servers)
	    }
		serverStrings := GetRedisServerStrings(servers[i:end])
	    sections = append(sections, ToTelegrafInputConf(tplPath, serverStrings))
	}
	return strings.Join(sections, "\n")
}
func RedisLatencyInputConf(servers []raas.Server) string {
	serverStrings := GetRedisServerStrings(servers)
	tplPath := filepath.Join(os.Getenv("CONF_TPL_PARENT_DIR"),"telegraf-redis-latency-conf-tpl/redis_latency.conf.tpl")
	return ToTelegrafInputConf(tplPath, serverStrings)
}
func MemcachedInputConf(servers []raas.Server) string {
	serverStrings := GetMemcachedServerStrings(servers)
	tplPath := filepath.Join(os.Getenv("CONF_TPL_PARENT_DIR"),"telegraf-memcached-conf-tpl/memcached.conf.tpl")
	return ToTelegrafInputConf(tplPath, serverStrings)
}
func MemcachedLatencyInputConf(servers []raas.Server) string {
	serverStrings := GetMemcachedServerStrings(servers)
	tplPath := filepath.Join(os.Getenv("CONF_TPL_PARENT_DIR"),"telegraf-memcached-latency-conf-tpl/memcached_latency.conf.tpl")
	return ToTelegrafInputConf(tplPath, serverStrings)
}

func GetRedisServerStrings(servers []raas.Server) (res []string) {
	for _, server := range servers {
		if server.Engine != "redis" {
			continue
		}
		pre := "tcp://"
		if server.Password != "" {
			pre = "tls-tcp://:" + server.Password + "@"
		}
		serverString := pre + server.Host + ":" + strconv.Itoa(server.Port)
		if server.Resque {
			serverString = serverString + "?resque=true"
			if server.ResqueNs != "" {
				serverString = serverString + "&resque_namespace=" + server.ResqueNs
			}
		}
		res = append(res, strconv.Quote(serverString))
	}
	return
}

func GetMemcachedServerStrings(servers []raas.Server) (res []string) {
	for _, server := range servers {
		if server.Engine != "memcached" {
			continue
		}
		serverString := strconv.Quote(server.Host + ":" + strconv.Itoa(server.Port))
		res = append(res, serverString)
	}
	return
}

func ToTelegrafInputConf(tplPath string, serverStrings []string) string {
	if len(serverStrings) == 0 {
		return "# no servers\n"
	}
	tplFile, err := os.Open(tplPath)
	if err != nil {
		panic(err)
	}
	defer tplFile.Close()
	byteValue, _ := ioutil.ReadAll(tplFile)
	tlpString := string(byteValue[:])
	return strings.Replace(tlpString, "SERVERS", strings.Join(serverStrings, ","), 1)
}
