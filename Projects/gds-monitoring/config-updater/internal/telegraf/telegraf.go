package telegraf

import (
	"daas-config-updater/internal/daas"
	"fmt"
	"io/ioutil"
	"os"
	"strconv"
	"strings"
)

func GetMysqlEndpointStrings(servers []daas.Server) (res []string) {
	for _, server := range servers {
		a := server.Host + ":" + strconv.Itoa(server.Port)
		serverString := "checkmk_mon:" + server.Password + "@tcp(" + a + ")/?tls=false"
		res = append(res, strconv.Quote(serverString))
	}
	return
}

func GetPostgresqlAddress(s daas.Server) string {
	return fmt.Sprintf("host=%v port=%v user=checkmk_mon password=%v sslmode=disable dbname=postgres",
		s.Host, s.Port, s.Password)
}

func MysqlInputConf(servers []daas.Server) string {
	if len(servers) == 0 {
		return "# no servers\n"
	}
	serverStrings := GetMysqlEndpointStrings(servers)
	tplFile, err := os.Open("/etc/config-updater/telegraf-mysql/telegraf.mysql.conf")
	if err != nil {
		panic(err)
	}
	defer tplFile.Close()
	byteValue, _ := ioutil.ReadAll(tplFile)
	tlpString := string(byteValue[:])
	return strings.Replace(tlpString, "SERVERS", "["+strings.Join(serverStrings, ",")+"]", 1)
}

func PostgresInputConf(servers []daas.Server) string {
	tplPath := "/etc/config-updater/telegraf-postgresql/telegraf.postgresql.conf"
	return postgresInputConfFromTemplate(servers, tplPath)
}

func PostgresExtensibleInputConf(servers []daas.Server) string {
	tplPath := "/etc/config-updater/telegraf-postgresql-extensible/telegraf.postgresql.extensible.conf"
	return postgresInputConfFromTemplate(servers, tplPath)
}

func postgresInputConfFromTemplate(servers []daas.Server, tplPath string) string {
	if len(servers) == 0 {
		return "# no servers\n"
	}
	tplFile, err := os.Open(tplPath)
	if err != nil {
		panic(err)
	}
	defer tplFile.Close()
	byteValue, _ := ioutil.ReadAll(tplFile)
	tlpString := string(byteValue[:])

	var sb strings.Builder
	for _, s := range servers {
		conf := tlpString
		conf = strings.Replace(conf, "ADDRESS", GetPostgresqlAddress(s), 1)
		conf = strings.Replace(conf, "SERVER", s.Host, 1)
		sb.WriteString(conf)
		sb.WriteString("\n")
	}
	return sb.String()
}
