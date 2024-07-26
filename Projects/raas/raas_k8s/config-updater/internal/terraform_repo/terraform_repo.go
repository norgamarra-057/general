package terraform_repo

import (
	"bufio"
	"bytes"
	"go.uber.org/zap"
	"net/http"
	"strings"
)

func FetchResqueClustersWithNs(url string) map[string]string {
	zap.L().Info("FetchResqueClustersWithNs", zap.String("url", url))
	resp, err := http.Get(url)
	if err != nil {
		panic(err)
	}
	defer resp.Body.Close()

	buf := new(bytes.Buffer)
	buf.ReadFrom(resp.Body)
	s := buf.String() // Does a complete copy of the bytes in the buffer.
	scanner := bufio.NewScanner(strings.NewReader(s))
	zap.L().Info("parsing yml file")
	res := make(map[string]string)
	for scanner.Scan() {
		line := scanner.Text()
		if icomment := strings.Index(line, "#"); icomment != -1 {
			line = line[0:icomment]
		}
		line = strings.TrimSpace(line)
		if len(line) == 0 {
			continue
		}
		parts := strings.Split(line, "{")
		if len(parts) != 2 {
			if line != "---" {
				zap.L().Warn("parse error", zap.String("line", line))
			}
			continue
		}
		cluster_name := strings.TrimSpace(strings.Split(parts[0], ":")[0])
		params := strings.Split(strings.TrimSuffix(parts[1], "}"), ",")
		resque := false
		resque_ns := ""
		for _, paramkv := range params {
			kv := strings.Split(paramkv, ":")
			if len(kv) != 2 { // skip if not "key: value" (example: arrays)
				continue;
			}
			k := strings.TrimSpace(kv[0])
			v := strings.TrimSpace(kv[1])
			if k == "resque" && v == "true" {
				resque = true
			}
			if k == "resque_ns" {
				resque_ns = v
			}
		}
		if resque {
			res[cluster_name] = resque_ns
		}
	}
	return res
}
