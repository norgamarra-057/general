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
    "net/http"
    "crypto/tls"   
)

type Process struct {
    Pid int          
    Cpu float64      
    Command_name string 
}


func main() {
    cmd := exec.Command("ps", "aux")
    var out bytes.Buffer
    cmd.Stdout = &out
    err := cmd.Run()
    if err != nil {
        log.Fatal(err)
    }
    processes := make([]*Process, 0)
    for {
         line, err := out.ReadString('\n')
         if err!=nil {
            break;
        }
        tokens := strings.Split(line, " ")
        ft := make([]string, 0)
        for _, t := range(tokens) {
            //if t!="" && t!="\t" {
             if t!="" {  
              ft = append(ft, t)
            }
        }
 
        pid, err := strconv.Atoi(ft[1])
        if err!=nil {
            continue
        }
        cpu, err := strconv.ParseFloat(ft[2], 64)
        if err!=nil {
            log.Fatal(err)
        }
        command_name := ft[10]


         processes = append(processes, &Process{pid, cpu, command_name})
    }
 
    for _, p := range(processes) {


    
    sz :=len(p.Command_name)
    if sz > 0 && p.Command_name[sz-1] == '\n' {
    p.Command_name = p.Command_name[:sz-1]
    }
     
     m := &Process{
          Pid: p.Pid,
          Cpu: p.Cpu,
          Command_name: p.Command_name}
  




        b, err :=json.Marshal(m)
        if err!=nil {
            log.Fatal(err)
        }

//     os.Stdout.Write(b)
                in := strings.NewReader(string(b))

                req, err := http.NewRequest("POST",
"https://10.20.98.116:43191/module/httptrap/6b9eef66-d34f-4291-90b8-458f72ec1006/mys3cr3t222222", in)

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

