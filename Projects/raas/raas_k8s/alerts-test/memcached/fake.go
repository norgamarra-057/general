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
	for {
		if uptime() > duration {
			log.Println("E, time is up")
			return
		}
		buf := make([]byte, 7) // "stats\r\n"
		_, errReadFull := io.ReadFull(c, buf)
		if errReadFull != nil {
			log.Println("E, ReadFull:", errReadFull)
			return
		}

		cmd := strings.TrimSpace(string(buf))
		if !strings.Contains(strings.ToLower(cmd), "stats") {
			log.Println("E, unhandled command:", cmd)
			return
		}
		log.Println("I, received stats command")

		res, errReadFile := ioutil.ReadFile("/etc/alerts-test/res.tpl")
		if errReadFile != nil {
			log.Println("E, ReadFile:", errReadFile)
			return
		}
		result := string(res)
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
	go fake(11211, 20*time.Minute)
	fake(11212, 10*time.Minute) // run in the main goroutine
}

func fake(port int, duration time.Duration) {
	log.Printf("I, starting fake memcached server listening on port: %d", port)
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
