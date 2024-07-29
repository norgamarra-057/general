package main

import (
	"bytes"
	"crypto/tls"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"os/exec"
	"strconv"
	"strings"
)

type Utilization struct {
	Utilization        int
	ProcRunQueue       int
	ProcBlockedQueue   int
	ProcRunnable       int
	MemAvm             int
	MemFree            int
	PagesFaults        int
	PagesReclaims      int
	PagesPagedIn       int
	PagesPagedOut      int
	PagesFreed         int
	PagesScanned       int
	FaultInt           int
	FaultSysCalls      int
	FaultContextSwitch int
	CpuUser            int
	CpuSystem          int
	CpuIdle            int
}

func main() {

	mycounter := 0
	cmd := exec.Command("vmstat", "1", "2")
	var out bytes.Buffer
	cmd.Stdout = &out
	err := cmd.Run()
	if err != nil {
		log.Fatal(err)
	}

	processes := make([]*Utilization, 0)

	for {
		line, err := out.ReadString('\n')
		if err != nil {
			break
		}

		if mycounter < 3 {
			mycounter++
			continue
		}
		sz := len(line)
		line = line[:sz-1]

		tokens := strings.Split(line, " ")
		ft := make([]string, 0)

		for _, t := range tokens {
			if t != "" && t != "\t" {
				ft = append(ft, t)
			}
		}

		procRunQueue, err := strconv.Atoi(ft[0])
		if err != nil {
			log.Fatal(err)
		}

		procBlockedQueue, err := strconv.Atoi(ft[1])
		if err != nil {
			log.Fatal(err)
		}

		procRunnable, err := strconv.Atoi(ft[2])
		if err != nil {
			log.Fatal(err)
		}

		memAvg, err := strconv.Atoi(ft[3])
		if err != nil {
			log.Fatal(err)
		}

		memFree, err := strconv.Atoi(ft[4])
		if err != nil {
			log.Fatal(err)
		}

		pagesFaults, err := strconv.Atoi(ft[5])
		if err != nil {
			log.Fatal(err)
		}

		pagesReclaims, err := strconv.Atoi(ft[6])
		if err != nil {
			log.Fatal(err)
		}

		pagesPagedIn, err := strconv.Atoi(ft[7])
		if err != nil {
			log.Fatal(err)
		}

		pagesPagedOut, err := strconv.Atoi(ft[8])
		if err != nil {
			log.Fatal(err)
		}

		pagesFreed, err := strconv.Atoi(ft[9])
		if err != nil {
			log.Fatal(err)
		}

		pagesScanned, err := strconv.Atoi(ft[10])
		if err != nil {
			log.Fatal(err)
		}

		faultInt, err := strconv.Atoi(ft[11])
		if err != nil {
			log.Fatal(err)
		}

		faultSysCalls, err := strconv.Atoi(ft[12])
		if err != nil {
			log.Fatal(err)
		}

		faultContextSwitch, err := strconv.Atoi(ft[13])
		if err != nil {
			log.Fatal(err)
		}

		user, err := strconv.Atoi(ft[16])
		if err != nil {
			log.Fatal(err)
		}

		sys, err := strconv.Atoi(ft[17])
		if err != nil {
			log.Fatal(err)
		}

		idle, err := strconv.Atoi(ft[18])
		if err != nil {
			log.Fatal(err)
		}

		utilization := user + sys

		processes = append(processes, &Utilization{utilization,procRunQueue,procBlockedQueue,procRunnable,memAvg,memFree,pagesFaults,pagesReclaims,pagesPagedIn,pagesPagedOut,pagesFreed,pagesScanned,faultInt,faultSysCalls,faultContextSwitch,user,sys,idle})
	}

	for _, p := range processes {

		m := &Utilization{
			Utilization:        p.Utilization,
			ProcRunQueue:       p.ProcRunQueue,
			ProcBlockedQueue:   p.ProcBlockedQueue,
			ProcRunnable:       p.ProcRunnable,
			MemAvm:             p.MemAvm,
			MemFree:            p.MemFree,
			PagesFaults:        p.PagesFaults,
			PagesReclaims:      p.PagesReclaims,
			PagesPagedIn:       p.PagesPagedIn,
			PagesPagedOut:      p.PagesPagedOut,
			PagesFreed:         p.PagesFreed,
			PagesScanned:       p.PagesScanned,
			FaultInt:           p.FaultInt,
			FaultSysCalls:      p.FaultSysCalls,
			FaultContextSwitch: p.FaultContextSwitch,
			CpuUser:            p.CpuUser,
			CpuSystem:          p.CpuSystem,
			CpuIdle:            p.CpuIdle}

		b, err := json.Marshal(m)
		if err != nil {
			log.Fatal(err)
		}

		in := strings.NewReader(string(b))

		os.Stdout.Write(b)

		req, err := http.NewRequest("POST", "https://10.20.98.116:43191/module/httptrap/afd07443-c29d-46cf-8e53-405255945510/mys3cr3t", in)
		//    req.Header.Set("X-Custom-Header", "myvalue")
		req.Header.Set("Content-Type", "application/json")

		tr := &http.Transport{
			TLSClientConfig: &tls.Config{InsecureSkipVerify: true},
		}
		client := &http.Client{Transport: tr}
		resp, err := client.Do(req)
		if err != nil {
			panic(err)
		}
		defer resp.Body.Close()

		fmt.Println("response Status:", resp.Status)
		fmt.Println("response Headers:", resp.Header)
		//    body, _ := ioutil.ReadAll(resp.Body)
		//    fmt.Println("response Body:", string(body))

	}
}
