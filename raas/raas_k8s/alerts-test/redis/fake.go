package main

import (
	"io"
	"io/ioutil"
	"log"
	"net"
	"os"
	"strconv"
	"strings"
	"time"
)

func handleConnection(c net.Conn, duration time.Duration) {
	defer c.Close()
	fake_nic_out := 0
	fake_cpu_user := 0
	for {
		if uptime() > duration {
			log.Println("E, time is up")
			return
		}
		buf := make([]byte, 23) // "info all" command is 23 bytes long
		_, errReadFull := io.ReadFull(c, buf)
		if errReadFull != nil {
			log.Println("E, ReadFull:", errReadFull)
			return
		}

		cmd := strings.TrimSpace(string(buf))
		if !strings.Contains(strings.ToLower(cmd), "info\r\n$3\r\nall") {
			log.Println("E, unhandled command:", cmd)
			return
		}
		log.Println("I, received INFO ALL")

		res, errReadFile := ioutil.ReadFile("/etc/alerts-test/res.tpl")
		if errReadFile != nil {
			log.Println("E, ReadFile:", errReadFile)
			return
		}
		result := string(res)

		_, minutes, _ := time.Now().Clock()

		// max = 416MB -> will recover every 10 minutes
		fake_used_mem := 400000000 + (minutes%10)*30000000
		result = strings.Replace(result, "FAKE_USED_MEM", strconv.Itoa(fake_used_mem), -1)

		// Alerts if expires/keys < 0.5 && keys > 100
		// Therefore it will recover every 10 minutes
		fake_keys := 10 + (minutes%10)*30000000
		result = strings.Replace(result, "FAKE_KEYS", strconv.Itoa(fake_keys), -1)
		fake_expires := (minutes%10)*1000000
		result = strings.Replace(result, "FAKE_EXPIRES", strconv.Itoa(fake_expires), -1)

		// max = 0.5Gbps -> will recover every 10 minutes
		fake_nic_out += 60 * (minutes % 10) * 63000000 // 63M = 1G/8/2
		result = strings.Replace(result, "FAKE_NIC_OUT", strconv.Itoa(fake_nic_out), -1)

		// max = 2.8 -> will recover every 10 minutes
		fake_cpu_user += 60 * (minutes % 10)
		result = strings.Replace(result, "FAKE_CPU_USER", strconv.Itoa(fake_cpu_user), -1)


		// redis protocol:
		result = strings.Replace(result, "\n", "\r\n", -1)
		c.Write([]byte("$" + strconv.Itoa(len(result)-2) + "\r\n"))
		c.Write([]byte(result))

		log.Println("I, response length:", len(result))
	}
}

var startTime time.Time

func init() {
	startTime = time.Now()
}

func uptime() time.Duration {
	return time.Since(startTime)
}

func main() {
	log.SetOutput(os.Stdout)
	go fake(6379, 20*time.Minute)
	fake(6380, 10*time.Minute) // run in the main goroutine
}

func fake(port int, duration time.Duration) {
	log.Printf("I, starting fake redis server listening on port: %d", port)
	ln, err := net.Listen("tcp", ":"+strconv.Itoa(port))
	if err != nil {
		log.Println("E, Listen:", err)
		return
	}

	for {
		conn, err := ln.Accept()
		if err != nil {
			log.Println("E, Accept:", err)
			return
		}
		go handleConnection(conn, duration)
	}

}
