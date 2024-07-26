package main

import (
	"daas-config-updater/internal/aws"
	"daas-config-updater/internal/cu"
	"daas-config-updater/internal/daas"
	"daas-config-updater/internal/k8s"
	"go.uber.org/zap"
	"go.uber.org/zap/zapcore"
	"gopkg.in/natefinch/lumberjack.v2"
	"os"
	"strings"
	"time"
)

func newConfigUpdater() *cu.ConfigUpdater {
	cu := new(cu.ConfigUpdater)

	cu.Kube = new(k8s.Kube)
	cu.Kube.Ns = os.Getenv("CONFIG_UPDATER_NAMESPACE")
	cu.Kube.InitK8sClientset()

	cu.RDS = new(aws.AWSRDS)
	cu.RDS.Region = os.Getenv("CONFIG_UPDATER_AWS_REGION")
	cu.RDS.InitAWSService()

	// Starting with an empty map will force to begin deploying
	cu.Servers = []daas.Server{}

	cu.Excluded = make(map[string]struct{})
	for _, server := range strings.Split(os.Getenv("CONFIG_UPDATER_EXCLUDED_DBS"), ",") {
		cu.Excluded[server] = struct{}{}
	}

	return cu
}

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
	cu := newConfigUpdater()
	for {
		cu.UpdateConfigOnChanges() // never panics, auto recovers
		// Note: If AWS API call frequency increases, communicate
		// to the conveyor team on change. The rationale is that
		// our account can be API rate limited if we exceed a
		// threshold, so we need to be aware of what contributes.
		zap.L().Info("sleeping", zap.Duration("seconds", 60*time.Second))
		time.Sleep(60 * time.Second)
	}
}
