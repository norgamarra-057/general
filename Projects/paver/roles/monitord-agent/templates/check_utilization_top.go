package main

import (
    "bytes"
    "log"
    "os/exec"
    "strconv"
    "strings"
//    "os"   
    "encoding/json"    
     "fmt"
//     "io/ioutil"
    "net/http"
    "crypto/tls"
)

type Process struct {
    Pid int          
    Size string      
    Res string 
    Command_name string
}

func main() {
    cmd := exec.Command("top", "-b")
    var out bytes.Buffer
    cmd.Stdout = &out
    err := cmd.Run()
    if err != nil {
        log.Fatal(err)
    }
    processes := make([]*Process, 0)
    mycounter :=0
    for {
         line, err := out.ReadString('\n') 
         if err!=nil {
            break;
        }    
        if mycounter < 2 {
           mycounter++
           continue;
        }
        tokens := strings.Split(line, " ")
        ft := make([]string, 0)
        for _, t := range(tokens) {
           if t!="" && t!="\t" { 
              ft = append(ft, t)
            }
        }
 
        pid, err := strconv.Atoi(ft[0])
        if err!=nil {
            continue
        }
        size := ft[5]
        res := ft[6]
        command_name :=ft[10]

        processes = append(processes, &Process{pid,size,res,command_name})   
 }

    
    for _, p := range(processes) {
       //log.Println("Process ", p.Pid, " Size ",p.Size," Res ",p.Res," Name ",p.Command_name)

    
    sz :=len(p.Command_name)
    if sz > 0 && p.Command_name[sz-1] == '\n' {
    p.Command_name = p.Command_name[:sz-1]
    }
     
     m := &Process{
          Pid: p.Pid,
          Size: p.Size,
          Res: p.Res,
          Command_name: p.Command_name}

      b, err :=json.Marshal(m)
      if err!=nil {
           log.Fatal(err)
      }

    // os.Stdout.Write(b)
		in := strings.NewReader(string(b))

		req, err := http.NewRequest("POST", 
"https://10.20.98.116:43191/module/httptrap/0ba700b4-cd0f-4dd1-9eda-04121fc2d72b/mys3cr3t2222", in)
		
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

