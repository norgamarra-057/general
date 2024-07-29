package main

import (
	"crypto/tls"
	"database/sql"
	"encoding/json"
	"fmt"
	_ "github.com/lib/pq"
	"net/http"
	"strconv"
	"strings"
)

func main() {

	var db *sql.DB
	var err error
	var query string
	var callsOld int
	var callsNew int
	callsOld = 0
	callsNew = 0
	
	db, err = sql.Open("postgres", "user=pgsql dbname=test host=localhost port=6432 sslmode=disable")

	if err != nil {
		fmt.Printf("sql.Open error: %v\n", err)
		return
	}

	defer db.Close()

	statement := "select substring(query,0,50 ) as query, sum(calls) as calls from pg_stat_statements group by query order by 2 desc limit 10"
	var stmt *sql.Stmt

	stmt, err = db.Prepare(statement)
	if err != nil {
		fmt.Printf("db.Prepare error: %v\n", err)
		return
	}

	var rows *sql.Rows

	rows, err = stmt.Query()
	if err != nil {
		fmt.Printf("stmt.Query error: %v\n", err)
		return
	}

	defer stmt.Close()

	for rows.Next() {

		err = rows.Scan(&query, &callsNew)
		if err != nil {
			fmt.Printf("rows.Scan error: %v\n", err)
			return
		}

		callsNew = callsNew - callsOld
		callsOld = callsNew
		sendJson(query, callsNew)
	}

}

func sendJson(query string, calls int) error {

	type StatementsStruct struct {
		query int
	}
	var m string

	m = `{ " ` + string(query) + `" ` + `:` + ` {` + `"` + "calls" + `"` + `:` + strconv.Itoa(calls) + `}}`

	if isJSON(m) != true {
		fmt.Printf("Invalid Json format : %v\n", m)
		return nil
	}

	fmt.Printf("%v", m)

	in := strings.NewReader(string(m))

	req, err := http.NewRequest("POST", "https://10.20.98.116:43191/module/httptrap/7b327225-ec02-4f05-9661-f5aad65eb765/testmetricspgstat", in)
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

	return nil
}

func isJSON(s string) bool {
	var js map[string]interface{}
	return json.Unmarshal([]byte(s), &js) == nil

}
