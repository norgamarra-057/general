//////////////////////////////////////////////////////////////////////////////////////////////////////////
//													//
// Nagios2nad												//
// 													//
// Objective : transform the output of the nagios check to NAD format					//
//													//
// Parameters : 											//
//													//
// 1 - checkname : The name of the check at NAD side.							//
// 2 - Nagios command : the full path of the check  with all the parameters.				//
//													//
//
// Author : Jose Finotto
//													//
//////////////////////////////////////////////////////////////////////////////////////////////////////////

import (
	"bytes"
	"fmt"
	"log"
	"os"
	"os/exec"
	"strings"
)

func main() {

	txtCmd := os.Args[1:]
	txtCheckName := txtCmd[0]
	txtTrat := txtCmd[1]
	txtParams := txtCmd[2:len(txtCmd)]

	cmd := exec.Command(txtTrat, txtParams...)
	var out bytes.Buffer
	cmd.Stdout = &out
	err := cmd.Run()
	if err != nil {
		log.Fatal(err)
	}
	for {
		line, err := out.ReadString('\n')
		if err != nil {
			break
		}

		if strings.ContainsAny(line, "|") {
			ind := strings.Index(line, "|")
			line = line[ind+1 : len(line)-1]
		}

		tokens := strings.Split(line, ";")

		ft := make([]string, 0)
		for _, t := range tokens {

			if t != "" {
				ft = append(ft, t)
			}
		}
		for _, x := range ft {

			if strings.ContainsAny(x, "=") {

				parts := strings.Split(x, "=")
				xpart := make([]string, 0)
				for _, x2 := range parts {
					if x2 != "" {
						xpart = append(xpart, x2)
					}
				}
				xName := strings.Trim(xpart[0], " ")
				xValue := strings.Trim(xpart[1], " ")
				fmt.Printf("nad_check.%v.%v    L       %v \n", txtCheckName, xName, xValue)
			}

		}

	}
}