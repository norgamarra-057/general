package main

import (
    "bytes"
    "log"
    "os/exec"
    "strconv"
    "strings"
    "os"   
    "encoding/json"    
    
)

type Utilization struct {
    Utilization int          
}


func main() {
    cmd := exec.Command("vmstat", "1", "2")
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
     
     m := &Utilization{
          Utilization: p.utilization }
  




        b, err :=json.Marshal(m)
        if err!=nil {
            log.Fatal(err)
        }

     os.Stdout.Write(b)

}
}