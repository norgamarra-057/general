package main

import (
	"config-updater/internal/aws"
	"config-updater/internal/cu"
	"config-updater/internal/k8s"
	"config-updater/internal/raas"
	"go.uber.org/zap"
	"go.uber.org/zap/zapcore"
	"gopkg.in/natefinch/lumberjack.v2"
	"os"
	"time"
)

func newConfigUpdater() *cu.ConfigUpdater {
	cu := new(cu.ConfigUpdater)

	cu.Kube = new(k8s.Kube)
	cu.Kube.Ns = os.Getenv("CONFIG_UPDATER_NAMESPACE")
	cu.Kube.InitK8sClientset()

	cu.Ec = new(aws.AWSElastiCache)
	cu.Ec.Region = os.Getenv("CONFIG_UPDATER_AWS_REGION")
	cu.Ec.InitAWSElastiCacheService()

	// Starting with an empty map will force to begin deploying
	cu.Servers = []raas.Server{}

	cu.TfRedisUrl = os.Getenv("CONFIG_UPDATER_TF_REDIS_URL")
	return cu
}

func setupLogger() {
	// https://github.com/uber-go/zap/blob/master/FAQ.md#does-zap-support-log-rotation
	w := zapcore.AddSync(&lumberjack.Logger{
		Filename:   os.Getenv("LOGS_DIR")+"config-updater.log",
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
