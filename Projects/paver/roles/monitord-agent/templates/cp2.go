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

	db, err = sql.Open("postgres", "user=pgsql dbname=test host=localhost port=6432 sslmode=disable")

	if err != nil {
		fmt.Printf("sql.Open error: %v\n", err)
		return
	}

	defer db.Close()

	statement := "select substring(query,0,50 ) as query, sum(calls) as calls, sum(total_time) as time, sum(rows) as rows, sum(shared_blks_hit) as shared_blks_hit, sum(shared_blks_read) as shared_blks_read, sum(shared_blks_dirtied) as shared_blks_dirtied, sum(shared_blks_written) as shared_blks_written, sum(local_blks_hit) as local_blks_hit, sum(local_blks_read) as local_blks_read, sum(local_blks_dirtied) as local_blks_dirtied, sum(local_blks_written) as local_blks_written, sum(temp_blks_read) as temp_blks_read, sum(temp_blks_written) as temp_blks_written, sum(blk_read_time) as blk_read_time, sum(blk_write_time) as blk_write_time from pg_stat_statements group by query order by 2 desc limit 10"
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
		var query string
		var calls int
		var time float64
		var total_rows int
		var shared_blks_hit int
		var shared_blks_read int
		var shared_blks_dirtied int
		var shared_blks_written int
		var local_blks_hit int
		var local_blks_read int
		var local_blks_dirtied int
		var local_blks_written int
		var temp_blks_read int
		var temp_blks_written int
		var blk_read_time float64
		var blk_write_time float64

		err = rows.Scan(&query, &calls, &time, &total_rows, &shared_blks_hit, &shared_blks_read, &shared_blks_dirtied, &shared_blks_written, &local_blks_hit, &local_blks_read, &local_blks_dirtied, &local_blks_written, &temp_blks_read, &temp_blks_written, &blk_read_time, &blk_write_time )
		if err != nil {
			fmt.Printf("rows.Scan error: %v\n", err)
			return
		}

		sendJson(query, calls, time, total_rows, shared_blks_hit, shared_blks_read, shared_blks_dirtied, shared_blks_written, local_blks_hit, local_blks_read, local_blks_dirtied, local_blks_written, temp_blks_read, temp_blks_written, blk_read_time, blk_write_time)
	}

}

func sendJson(query string, calls int, time float64, total_rows int, shared_blks_hit int, shared_blks_read int, shared_blks_dirtied int, shared_blks_written int, local_blks_hit int, local_blks_read int, local_blks_dirtied int, local_blks_written int, temp_blks_read int, temp_blks_written int, blk_read_time float64, blk_write_time float64) error {

	type StatementsStruct struct {
		query int
	}
	var m string

	m = `{ " ` + string(query) + `" ` + `:` + ` {` + `"` + "calls" + `"` + `:` + strconv.Itoa(calls) + `,` + `"` + "time" + `"` + `:` + strconv.FormatFloat(time, 'f', 6, 64) + `,` + `"` + "rows" + `"` + `:` + strconv.Itoa(total_rows)  + `,` + `"` + "shared_blks_hit" + `"` + `:` + strconv.Itoa(shared_blks_hit) + `,`  + `"` + "shared_blks_read" + `"` + `:` + strconv.Itoa(shared_blks_read) + `,` + `"` + "shared_blks_dirtied" + `"` + `:` + strconv.Itoa(shared_blks_dirtied) + `,` + `"` + "shared_blks_written" + `"` + `:` + strconv.Itoa(shared_blks_written) + `,`  + `"` + "local_blks_hit" + `"` + `:` + strconv.Itoa(local_blks_hit) + `,`  + `"` + "local_blks_read" + `"` + `:` + strconv.Itoa(local_blks_read) + `,`  + `"` + "local_blks_dirtied" + `"` + `:` + strconv.Itoa(local_blks_dirtied) + `,`  + `"` + "local_blks_written" + `"` + `:` + strconv.Itoa(local_blks_written) + `,`  + `"` + "blk_read_time" + `"` + `:` + strconv.FormatFloat(blk_read_time, 'f', 6, 64) + `,` + `"` + "blk_write_time" + `"` + `:` + strconv.FormatFloat(blk_write_time, 'f', 6, 64) + `}}`

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
