package main

import (
	"daas-config-updater/internal/cu"
	"daas-config-updater/internal/daas"
	"go.uber.org/zap"
	"go.uber.org/zap/zapcore"
	"gopkg.in/natefinch/lumberjack.v2"
	"os"
	"strings"
)

func setupLogger() {
	// https://github.com/uber-go/zap/blob/master/FAQ.md#does-zap-support-log-rotation
	w := zapcore.AddSync(&lumberjack.Logger{
		Filename:   os.Getenv("LOGS_DIR") + "config-updater.log",
		MaxSize:    10, // megabytes
		MaxBackups: 1,
		MaxAge:     4, //days
		Compress:   false,
	})

	encoderCfg := zap.NewProductionEncoderConfig()
	encoderCfg.TimeKey = "timestamp"
	encoderCfg.EncodeTime = zapcore.ISO8601TimeEncoder // 2021-01-15T13:36:42.978-0800

	core := zapcore.NewCore(
		zapcore.NewJSONEncoder(encoderCfg),
		w,
		zap.InfoLevel,
	)
	logger := zap.New(core, zap.AddStacktrace(zap.ErrorLevel))
	// make zap.L() use our lumberjack logger:
	zap.ReplaceGlobals(logger)
}

func main() {
	setupLogger()
	zap.L().Info("starting")
	cu := new(cu.ConfigUpdater)

	cu.Excluded = make(map[string]struct{})
	for _, server := range strings.Split(os.Getenv("CONFIG_UPDATER_EXCLUDED_DBS"), ",") {
		cu.Excluded[server] = struct{}{}
	}

	var servers []daas.Server
	var server daas.Server
	server = daas.Server{}
	server.Host = "test1"
	server.Port = 3306
	server.Engine = "myengine"
	servers = append(servers, server)

	zap.L().Info("before", zap.Int("servers", len(servers)))
	servers = cu.RemoveExcluded(servers)
	zap.L().Info("after", zap.Int("servers", len(servers)))

}
