package main

import (
	"crypto/tls"
	"database/sql"
	"encoding/json"
	"fmt"
	_ "github.com/lib/pq"
	"net/http"
	"os"
	"strings"
	"time"
	//	"strconv"
)

type BaseJSON struct {
	Type  string `json:"_type"`
	Value []int  `json:"_value"`
}

type CallsJSON struct {
	Calls               BaseJSON `json:"calls"`
	TotalTime           BaseJSON `json:"totaltime"`
	Rows                BaseJSON `json:"rows"`
	SharedBlocksHit     BaseJSON `json:"sharedblockshit"`
	SharedBlocksRead    BaseJSON `json:"sharedblocksread"`
	SharedBlocksDirtied BaseJSON `json:"sharedblocksdirtied"`
	SharedBlocksWritten BaseJSON `json:"sharedblockswritten"`
	LocalBlocksHit      BaseJSON `json:"localblockshit"`
	LocalBlocksRead     BaseJSON `json:"localblocksread"`
	LocalBlocksDirtied  BaseJSON `json:"localblocksdirtied"`
	LocalBlocksWritten  BaseJSON `json:"localblockswritten"`
	TempBlocksRead      BaseJSON `json:"tempblocksread"`
	TempBlocksWritten   BaseJSON `json:"tempblockswritten"`
	BlocksReadTime      BaseJSON `json:"blocksreadtime"`
	BlocksWrittenTime   BaseJSON `json:"blockswrittentime"`
}

type ListQueries struct {
	Query               string
	Calls               []int
	TotalTime           []int
	Rows                []int
	SharedBlocksHit     []int
	SharedBlocksRead    []int
	SharedBlocksDirtied []int
	SharedBlocksWritten []int
	LocalBlocksHit      []int
	LocalBlocksRead     []int
	LocalBlocksDirtied  []int
	LocalBlocksWritten  []int
	TempBlocksRead      []int
	TempBlocksWritten   []int
	BlocksReadTime      []int
	BlocksWrittenTime   []int
}

var Queries []ListQueries

func main() {

	var db *sql.DB
	var err error

	db, err = sql.Open("postgres", "user=pgsql dbname=test host=localhost port=6432 sslmode=disable")

	if err != nil {
		fmt.Printf("sql.Open error: %v\n", err)
		return
	}

	defer db.Close()
	var second int = 0

	var query string
	var calls int
	var totalTime int
	var rowstab int
	var sharedBlocksHit int
	var sharedBlocksRead int
	var sharedBlocksDirtied int
	var sharedBlocksWritten int
	var localBlocksHit int
	var localBlocksRead int
	var localBlocksDirtied int
	var localBlocksWritten int
	var tempBlocksRead int
	var tempBlocksWritten int
	var blocksReadTime int
	var blocksWrittenTime int

	//	assembledMap := map[string]CallsJSON{query: callsStruct}

	for {
		statement := "select substring(query,0,236 ) as query,sum(calls) as calls,sum(total_time)::bigint as totaltime, sum(rows) as rowstab,sum(shared_blks_hit) as shared_blks_hit, sum(shared_blks_read) as shared_blks_read, sum(shared_blks_dirtied) as shared_blks_dirtied, sum(shared_blks_written) as shared_blks_written, sum(local_blks_hit) as local_blks_hit, sum(local_blks_read) as local_blks_read, sum(local_blks_dirtied) as local_blks_dirtied, sum(local_blks_written) as local_blks_written,  sum(temp_blks_read) as temp_blks_read,   sum(temp_blks_written) as temp_blks_written,sum(blk_read_time)::bigint as blk_read_time,  sum(blk_write_time)::bigint as blk_write_time from pg_stat_statements group by query order by 2 desc limit 10"
		var stmt *sql.Stmt

		stmt, err = db.Prepare(statement)
		if err != nil {
			fmt.Printf("db.Prepare error: %v\n", err)
			return
		}

		var rows *sql.Rows

		found := 0
		j := 0
		//		sz := 0
		rows, err = stmt.Query()
		if err != nil {
			fmt.Printf("stmt.Query error: %v\n", err)
			return
		}

		defer stmt.Close()
		var cont int = 0
		var tempCallsInt []int
		var tempTotalTimeInt []int
		var tempRowsInt []int
		var tempSharedBlocksHitInt []int
		var tempSharedBlocksReadInt []int
		var tempSharedBlocksDirtiedInt []int
		var tempSharedBlocksWrittenInt []int
		var tempLocalBlocksHitInt []int
		var tempLocalBlocksReadInt []int
		var tempLocalBlocksDirtiedInt []int
		var tempLocalBlocksWrittenInt []int
		var tempTempBlocksReadInt []int
		var tempTempBlocksWrittenInt []int
		var tempBlocksReadTimeInt []int
		var tempBlocksWrittenTimeInt []int

		for rows.Next() {

			err = rows.Scan(&query, &calls, &totalTime, &rowstab, &sharedBlocksHit, &sharedBlocksRead, &sharedBlocksDirtied, &sharedBlocksWritten, &localBlocksHit, &localBlocksRead, &localBlocksDirtied, &localBlocksWritten, &tempBlocksRead, &tempBlocksWritten, &blocksReadTime, &blocksWrittenTime)
			if err != nil {
				fmt.Printf("rows.Scan error: %v\n", err)
				return
			}
			cont++

			for newi, listquery := range Queries {
				if listquery.Query == query {
					found = 1
					Queries[newi].Calls = AppendInt(Queries[newi].Calls, calls)
					Queries[newi].TotalTime = AppendInt(Queries[newi].TotalTime, totalTime)

					Queries[newi].Rows = AppendInt(Queries[newi].Rows, rowstab)
					Queries[newi].SharedBlocksHit = AppendInt(Queries[newi].SharedBlocksHit, sharedBlocksHit)
					Queries[newi].SharedBlocksRead = AppendInt(Queries[newi].SharedBlocksRead, sharedBlocksRead)
					Queries[newi].SharedBlocksDirtied = AppendInt(Queries[newi].SharedBlocksDirtied,
						sharedBlocksDirtied)
					Queries[newi].SharedBlocksWritten = AppendInt(Queries[newi].SharedBlocksWritten,
						sharedBlocksWritten)
					Queries[newi].LocalBlocksHit = AppendInt(Queries[newi].LocalBlocksHit, localBlocksHit)
					Queries[newi].LocalBlocksRead = AppendInt(Queries[newi].LocalBlocksRead, localBlocksRead)
					Queries[newi].LocalBlocksDirtied = AppendInt(Queries[newi].LocalBlocksDirtied,
						localBlocksDirtied)
					Queries[newi].LocalBlocksWritten = AppendInt(Queries[newi].LocalBlocksWritten,
						localBlocksWritten)
					Queries[newi].TempBlocksRead = AppendInt(Queries[newi].TempBlocksRead, tempBlocksRead)
					Queries[newi].TempBlocksWritten = AppendInt(Queries[newi].TempBlocksWritten, tempBlocksWritten)
					Queries[newi].BlocksReadTime = AppendInt(Queries[newi].BlocksReadTime, blocksReadTime)
					Queries[newi].BlocksWrittenTime = AppendInt(Queries[newi].BlocksWrittenTime, blocksWrittenTime)

					break
				}
			}

			if found == 0 {
				for j = 0; j < second; j++ {
					tempCallsInt = AppendInt(tempCallsInt, 0)
					tempTotalTimeInt = AppendInt(tempTotalTimeInt, 0)
					tempRowsInt = AppendInt(tempRowsInt, 0)
					tempSharedBlocksHitInt = AppendInt(tempSharedBlocksHitInt, 0)
					tempSharedBlocksReadInt = AppendInt(tempSharedBlocksReadInt, 0)
					tempSharedBlocksDirtiedInt = AppendInt(tempSharedBlocksDirtiedInt, 0)
					tempSharedBlocksWrittenInt = AppendInt(tempSharedBlocksWrittenInt, 0)
					tempLocalBlocksHitInt = AppendInt(tempLocalBlocksHitInt, 0)
					tempLocalBlocksReadInt = AppendInt(tempLocalBlocksReadInt, 0)
					tempLocalBlocksDirtiedInt = AppendInt(tempLocalBlocksDirtiedInt, 0)
					tempLocalBlocksWrittenInt = AppendInt(tempLocalBlocksWrittenInt, 0)
					tempTempBlocksReadInt = AppendInt(tempTempBlocksReadInt, 0)
					tempTempBlocksWrittenInt = AppendInt(tempTempBlocksWrittenInt, 0)
					tempBlocksReadTimeInt = AppendInt(tempBlocksReadTimeInt, 0)
					tempBlocksWrittenTimeInt = AppendInt(tempBlocksWrittenTimeInt, 0)
				}
				tmpQuery := ListQueries{
					Query:     query,
					Calls:     AppendInt(tempCallsInt, calls),
					TotalTime: AppendInt(tempTotalTimeInt, totalTime),

					Rows:                AppendInt(tempRowsInt, rowstab),
					SharedBlocksHit:     AppendInt(tempSharedBlocksHitInt, sharedBlocksHit),
					SharedBlocksRead:    AppendInt(tempSharedBlocksReadInt, sharedBlocksRead),
					SharedBlocksDirtied: AppendInt(tempSharedBlocksDirtiedInt, sharedBlocksDirtied),
					SharedBlocksWritten: AppendInt(tempSharedBlocksWrittenInt, sharedBlocksWritten),
					LocalBlocksHit:      AppendInt(tempLocalBlocksHitInt, localBlocksHit),
					LocalBlocksRead:     AppendInt(tempLocalBlocksReadInt, localBlocksRead),
					LocalBlocksDirtied:  AppendInt(tempLocalBlocksDirtiedInt, localBlocksDirtied),
					LocalBlocksWritten:  AppendInt(tempLocalBlocksWrittenInt, localBlocksWritten),
					TempBlocksRead:      AppendInt(tempTempBlocksReadInt, tempBlocksRead),
					TempBlocksWritten:   AppendInt(tempTempBlocksWrittenInt, tempBlocksWritten),
					BlocksReadTime:      AppendInt(tempBlocksReadTimeInt, blocksReadTime),
					BlocksWrittenTime:   AppendInt(tempBlocksWrittenTimeInt, blocksWrittenTime),
				}
				Queries = AppendQuery(Queries, tmpQuery)
				tempCallsInt = tempCallsInt[:0]
				tempTotalTimeInt = tempTotalTimeInt[:0]

				tempRowsInt = tempRowsInt[:0]
				tempSharedBlocksHitInt = tempSharedBlocksHitInt[:0]
				tempSharedBlocksReadInt = tempSharedBlocksReadInt[:0]
				tempSharedBlocksDirtiedInt = tempSharedBlocksDirtiedInt[:0]
				tempSharedBlocksWrittenInt = tempSharedBlocksWrittenInt[:0]
				tempLocalBlocksHitInt = tempLocalBlocksHitInt[:0]
				tempLocalBlocksReadInt = tempLocalBlocksReadInt[:0]
				tempLocalBlocksDirtiedInt = tempLocalBlocksDirtiedInt[:0]
				tempLocalBlocksWrittenInt = tempLocalBlocksWrittenInt[:0]
				tempTempBlocksReadInt = tempTempBlocksReadInt[:0]
				tempTempBlocksWrittenInt = tempTempBlocksWrittenInt[:0]
				tempBlocksReadTimeInt = tempBlocksReadTimeInt[:0]
				tempBlocksWrittenTimeInt = tempBlocksWrittenTimeInt[:0]
			}

			//fmt.Printf("QUERY: %v	CALLS: %d \n", query, calls)
		}

		time.Sleep(1 * time.Second)
		second++
		found = 0
		fmt.Printf("%v \n", second)

		if second == 60 {
			sendJson(Queries)
			tempCallsInt = tempCallsInt[:0]
			tempTotalTimeInt = tempTotalTimeInt[:0]

			tempRowsInt = tempRowsInt[:0]
			tempSharedBlocksHitInt = tempSharedBlocksHitInt[:0]
			tempSharedBlocksReadInt = tempSharedBlocksReadInt[:0]
			tempSharedBlocksDirtiedInt = tempSharedBlocksDirtiedInt[:0]
			tempSharedBlocksWrittenInt = tempSharedBlocksWrittenInt[:0]
			tempLocalBlocksHitInt = tempLocalBlocksHitInt[:0]
			tempLocalBlocksReadInt = tempLocalBlocksReadInt[:0]
			tempLocalBlocksDirtiedInt = tempLocalBlocksDirtiedInt[:0]
			tempLocalBlocksWrittenInt = tempLocalBlocksWrittenInt[:0]
			tempTempBlocksReadInt = tempTempBlocksReadInt[:0]
			tempTempBlocksWrittenInt = tempTempBlocksWrittenInt[:0]
			tempBlocksReadTimeInt = tempBlocksReadTimeInt[:0]
			tempBlocksWrittenTimeInt = tempBlocksWrittenTimeInt[:0]

			second = 0
			Queries = Queries[:0]

		}

	}

}

func sendJson(queries []ListQueries) error {

	sz := 0
	sumCalls := 0
	sumTotalTime := 0
	sumRows := 0
	sumSharedBlocksHit := 0
	sumSharedBlocksRead := 0
	sumSharedBlocksDirtied := 0
	sumSharedBlocksWritten := 0
	sumLocalBlocksHit := 0
	sumLocalBlocksRead := 0
	sumLocalBlocksDirtied := 0
	sumLocalBlocksWritten := 0
	sumTempBlocksRead := 0
	sumTempBlocksWritten := 0
	sumBlocksReadTime := 0
	sumBlocksWrittenTime := 0

	for it := 0; it < len(queries); it++ {
		sz = 0
		callsStruct := CallsJSON{
			Calls:               BaseJSON{Type: "n", Value: []int{}},
			TotalTime:           BaseJSON{Type: "n", Value: []int{}},
			Rows:                BaseJSON{Type: "n", Value: []int{}},
			SharedBlocksHit:     BaseJSON{Type: "n", Value: []int{}},
			SharedBlocksRead:    BaseJSON{Type: "n", Value: []int{}},
			SharedBlocksDirtied: BaseJSON{Type: "n", Value: []int{}},
			SharedBlocksWritten: BaseJSON{Type: "n", Value: []int{}},
			LocalBlocksHit:      BaseJSON{Type: "n", Value: []int{}},
			LocalBlocksRead:     BaseJSON{Type: "n", Value: []int{}},
			LocalBlocksDirtied:  BaseJSON{Type: "n", Value: []int{}},
			LocalBlocksWritten:  BaseJSON{Type: "n", Value: []int{}},
			TempBlocksRead:      BaseJSON{Type: "n", Value: []int{}},
			TempBlocksWritten:   BaseJSON{Type: "n", Value: []int{}},
			BlocksReadTime:      BaseJSON{Type: "n", Value: []int{}},
			BlocksWrittenTime:   BaseJSON{Type: "n", Value: []int{}},
		}

		sz = len(queries[it].Calls)
		var tempCallsInt []int
		var tempTotalTimeInt []int
		var tempRowsInt []int
		var tempSharedBlocksHitInt []int
		var tempSharedBlocksReadInt []int
		var tempSharedBlocksDirtiedInt []int
		var tempSharedBlocksWrittenInt []int
		var tempLocalBlocksHitInt []int
		var tempLocalBlocksReadInt []int
		var tempLocalBlocksDirtiedInt []int
		var tempLocalBlocksWrittenInt []int
		var tempTempBlocksReadInt []int
		var tempTempBlocksWrittenInt []int
		var tempBlocksReadTimeInt []int
		var tempBlocksWrittenTimeInt []int

		//sum = 0

		for x := 0; x < sz-1; x++ {

			if x == 0 {
				tempCallsInt = AppendInt(tempCallsInt, queries[it].Calls[x])
				tempTotalTimeInt = AppendInt(tempTotalTimeInt, queries[it].TotalTime[x])

				tempRowsInt = AppendInt(tempRowsInt, queries[it].Rows[x])
				tempSharedBlocksHitInt = AppendInt(tempSharedBlocksHitInt, queries[it].SharedBlocksHit[x])
				tempSharedBlocksReadInt = AppendInt(tempSharedBlocksReadInt, queries[it].SharedBlocksRead[x])
				tempSharedBlocksDirtiedInt = AppendInt(tempSharedBlocksDirtiedInt, queries[it].SharedBlocksDirtied[x])
				tempSharedBlocksWrittenInt = AppendInt(tempSharedBlocksWrittenInt, queries[it].SharedBlocksWritten[x])
				tempLocalBlocksHitInt = AppendInt(tempLocalBlocksHitInt, queries[it].LocalBlocksHit[x])
				tempLocalBlocksReadInt = AppendInt(tempLocalBlocksReadInt, queries[it].LocalBlocksRead[x])
				tempLocalBlocksDirtiedInt = AppendInt(tempLocalBlocksDirtiedInt, queries[it].LocalBlocksDirtied[x])
				tempLocalBlocksWrittenInt = AppendInt(tempLocalBlocksWrittenInt, queries[it].LocalBlocksWritten[x])
				tempTempBlocksReadInt = AppendInt(tempTempBlocksReadInt, queries[it].TempBlocksRead[x])
				tempTempBlocksWrittenInt = AppendInt(tempTempBlocksWrittenInt, queries[it].TempBlocksWritten[x])
				tempBlocksReadTimeInt = AppendInt(tempBlocksReadTimeInt, queries[it].BlocksReadTime[x])
				tempBlocksWrittenTimeInt = AppendInt(tempBlocksWrittenTimeInt, queries[it].BlocksWrittenTime[x])

			}

			tempCallsInt = AppendInt(tempCallsInt, queries[it].Calls[x+1]-queries[it].Calls[x])
			tempTotalTimeInt = AppendInt(tempTotalTimeInt, queries[it].TotalTime[x+1]-queries[it].TotalTime[x])

			tempRowsInt = AppendInt(tempRowsInt, queries[it].Rows[x+1]-queries[it].Rows[x])
			tempSharedBlocksHitInt = AppendInt(tempSharedBlocksHitInt, queries[it].SharedBlocksHit[x+1]-queries[it].SharedBlocksHit[x])
			tempSharedBlocksReadInt = AppendInt(tempSharedBlocksReadInt, queries[it].SharedBlocksRead[x+1]-queries[it].SharedBlocksRead[x])
			tempSharedBlocksDirtiedInt = AppendInt(tempSharedBlocksDirtiedInt, queries[it].SharedBlocksDirtied[x+1]-queries[it].SharedBlocksDirtied[x])
			tempSharedBlocksWrittenInt = AppendInt(tempSharedBlocksWrittenInt, queries[it].SharedBlocksWritten[x+1]-queries[it].SharedBlocksWritten[x])
			tempLocalBlocksHitInt = AppendInt(tempLocalBlocksHitInt, queries[it].LocalBlocksHit[x+1]-queries[it].LocalBlocksHit[x])
			tempLocalBlocksReadInt = AppendInt(tempLocalBlocksReadInt, queries[it].LocalBlocksRead[x+1]-queries[it].LocalBlocksRead[x])
			tempLocalBlocksDirtiedInt = AppendInt(tempLocalBlocksDirtiedInt, queries[it].LocalBlocksDirtied[x+1]-queries[it].LocalBlocksDirtied[x])
			tempLocalBlocksWrittenInt = AppendInt(tempLocalBlocksWrittenInt, queries[it].LocalBlocksWritten[x+1]-queries[it].LocalBlocksWritten[x])
			tempTempBlocksReadInt = AppendInt(tempTempBlocksReadInt, queries[it].TempBlocksRead[x+1]-queries[it].TempBlocksRead[x])
			tempTempBlocksWrittenInt = AppendInt(tempTempBlocksWrittenInt, queries[it].TempBlocksWritten[x+1]-queries[it].TempBlocksWritten[x])
			tempBlocksReadTimeInt = AppendInt(tempBlocksReadTimeInt, queries[it].BlocksReadTime[x+1]-queries[it].BlocksReadTime[x])
			tempBlocksWrittenTimeInt = AppendInt(tempBlocksWrittenTimeInt, queries[it].BlocksWrittenTime[x+1]-queries[it].BlocksWrittenTime[x])

			if x > 0 {
				sumCalls = sumCalls + tempCallsInt[x]
				sumTotalTime = sumTotalTime + tempTotalTimeInt[x]

				sumRows = sumRows + tempRowsInt[x]
				sumSharedBlocksHit = sumSharedBlocksHit + tempSharedBlocksHitInt[x]
				sumSharedBlocksRead = sumSharedBlocksRead + tempSharedBlocksReadInt[x]
				sumSharedBlocksDirtied = sumSharedBlocksDirtied + tempSharedBlocksDirtiedInt[x]
				sumSharedBlocksWritten = sumSharedBlocksWritten + tempSharedBlocksWrittenInt[x]
				sumLocalBlocksHit = sumLocalBlocksHit + tempLocalBlocksHitInt[x]
				sumLocalBlocksRead = sumLocalBlocksRead + tempLocalBlocksReadInt[x]
				sumLocalBlocksDirtied = sumLocalBlocksDirtied + tempLocalBlocksDirtiedInt[x]
				sumLocalBlocksWritten = sumLocalBlocksWritten + tempLocalBlocksWrittenInt[x]
				sumTempBlocksRead = sumTempBlocksRead + tempTempBlocksReadInt[x]
				sumTempBlocksWritten = sumTempBlocksWritten + tempTempBlocksWrittenInt[x]
				sumBlocksReadTime = sumBlocksReadTime + tempBlocksReadTimeInt[x]
				sumBlocksWrittenTime = sumBlocksWrittenTime + tempBlocksWrittenTimeInt[x]

			}
		}

		tempCallsInt[0] = (sumCalls / (sz - 1))
		tempTotalTimeInt[0] = (sumTotalTime / (sz - 1))

		tempRowsInt[0] = (sumRows / (sz - 1))
		tempSharedBlocksHitInt[0] = (sumSharedBlocksHit / (sz - 1))
		tempSharedBlocksReadInt[0] = (sumSharedBlocksRead / (sz - 1))
		tempSharedBlocksDirtiedInt[0] = (sumSharedBlocksDirtied / (sz - 1))
		tempSharedBlocksWrittenInt[0] = (sumSharedBlocksWritten / (sz - 1))
		tempLocalBlocksHitInt[0] = (sumLocalBlocksHit / (sz - 1))
		tempLocalBlocksReadInt[0] = (sumLocalBlocksRead / (sz - 1))
		tempLocalBlocksDirtiedInt[0] = (sumLocalBlocksDirtied / (sz - 1))
		tempLocalBlocksWrittenInt[0] = (sumLocalBlocksWritten / (sz - 1))
		tempTempBlocksReadInt[0] = (sumTempBlocksRead / (sz - 1))
		tempTempBlocksWrittenInt[0] = (sumTempBlocksWritten / (sz - 1))
		tempBlocksReadTimeInt[0] = (sumBlocksReadTime / (sz - 1))
		tempBlocksWrittenTimeInt[0] = (sumBlocksWrittenTime / (sz - 1))

		queries[it].Calls = tempCallsInt
		queries[it].TotalTime = tempTotalTimeInt

		queries[it].Rows = tempRowsInt
		queries[it].SharedBlocksHit = tempSharedBlocksHitInt
		queries[it].SharedBlocksRead = tempSharedBlocksReadInt
		queries[it].SharedBlocksDirtied = tempSharedBlocksDirtiedInt
		queries[it].SharedBlocksWritten = tempSharedBlocksWrittenInt
		queries[it].LocalBlocksHit = tempLocalBlocksHitInt
		queries[it].LocalBlocksRead = tempLocalBlocksReadInt
		queries[it].LocalBlocksDirtied = tempLocalBlocksDirtiedInt
		queries[it].LocalBlocksWritten = tempLocalBlocksWrittenInt
		queries[it].TempBlocksRead = tempTempBlocksReadInt
		queries[it].TempBlocksWritten = tempTempBlocksWrittenInt
		queries[it].BlocksReadTime = tempBlocksReadTimeInt
		queries[it].BlocksWrittenTime = tempBlocksWrittenTimeInt

		callsStruct.Calls.Value = queries[it].Calls
		callsStruct.TotalTime.Value = queries[it].TotalTime

		callsStruct.Rows.Value = queries[it].Rows
		callsStruct.SharedBlocksHit.Value = queries[it].SharedBlocksHit
		callsStruct.SharedBlocksRead.Value = queries[it].SharedBlocksRead
		callsStruct.SharedBlocksDirtied.Value = queries[it].SharedBlocksDirtied
		callsStruct.SharedBlocksWritten.Value = queries[it].SharedBlocksWritten
		callsStruct.LocalBlocksHit.Value = queries[it].LocalBlocksHit
		callsStruct.LocalBlocksRead.Value = queries[it].LocalBlocksRead
		callsStruct.LocalBlocksDirtied.Value = queries[it].LocalBlocksDirtied
		callsStruct.LocalBlocksWritten.Value = queries[it].LocalBlocksWritten
		callsStruct.TempBlocksRead.Value = queries[it].TempBlocksRead
		callsStruct.TempBlocksWritten.Value = queries[it].TempBlocksWritten
		callsStruct.BlocksReadTime.Value = queries[it].BlocksReadTime
		callsStruct.BlocksWrittenTime.Value = queries[it].BlocksWrittenTime

		assembledMap := map[string]CallsJSON{queries[it].Query: callsStruct}

		jsonMarshal, err := json.Marshal(assembledMap)
		if err != nil {
			panic(err)
		}
		tempCallsInt = tempCallsInt[:0]
		tempTotalTimeInt = tempTotalTimeInt[:0]
		tempRowsInt = tempRowsInt[:0]
		tempSharedBlocksHitInt = tempSharedBlocksHitInt[:0]
		tempSharedBlocksReadInt = tempSharedBlocksReadInt[:0]
		tempSharedBlocksDirtiedInt = tempSharedBlocksDirtiedInt[:0]
		tempSharedBlocksWrittenInt = tempSharedBlocksWrittenInt[:0]
		tempLocalBlocksHitInt = tempLocalBlocksHitInt[:0]
		tempLocalBlocksReadInt = tempLocalBlocksReadInt[:0]
		tempLocalBlocksDirtiedInt = tempLocalBlocksDirtiedInt[:0]
		tempLocalBlocksWrittenInt = tempLocalBlocksWrittenInt[:0]
		tempTempBlocksReadInt = tempTempBlocksReadInt[:0]
		tempTempBlocksWrittenInt = tempTempBlocksWrittenInt[:0]
		tempBlocksReadTimeInt = tempBlocksReadTimeInt[:0]
		tempBlocksWrittenTimeInt = tempBlocksWrittenTimeInt[:0]

		os.Stdout.Write(jsonMarshal)

		in := strings.NewReader(string(jsonMarshal))

		req, err := http.NewRequest("POST", "https://10.20.131.188:43191/module/httptrap/9becb8d9-0409-4dd3-adb3-a393d92056b7/mys3cr3tIhopeitworks", in)
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
	}
	return nil
}

func AppendInt(slice []int, data ...int) []int {
	m := len(slice)
	n := m + len(data)
	if n > cap(slice) {
		newSlice := make([]int, n+1)
		copy(newSlice, slice)
		slice = newSlice
	}
	slice = slice[0:n]
	copy(slice[m:n], data)
	return slice
}

func AppendQuery(slice []ListQueries, data ...ListQueries) []ListQueries {
	m := len(slice)
	n := m + len(data)
	if n > cap(slice) {
		newSlice := make([]ListQueries, n+1)
		copy(newSlice, slice)
		slice = newSlice
	}
	slice = slice[0:n]
	copy(slice[m:n], data)
	return slice
}
