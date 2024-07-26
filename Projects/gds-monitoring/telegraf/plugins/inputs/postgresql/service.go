package postgresql

import (
	"database/sql"
	"fmt"
	"net"
	"net/url"
	"regexp"
	"sort"
	"strings"
	"time"

	"go.uber.org/zap"
	"go.uber.org/zap/zapcore"
	"gopkg.in/natefinch/lumberjack.v2"

	"github.com/jackc/pgx/v4"
	"github.com/jackc/pgx/v4/stdlib"

	"github.com/influxdata/telegraf"
	"github.com/influxdata/telegraf/config"
)

// pulled from lib/pq
// ParseURL no longer needs to be used by clients of this library since supplying a URL as a
// connection string to sql.Open() is now supported:
//
//	sql.Open("postgres", "postgres://bob:secret@1.2.3.4:5432/mydb?sslmode=verify-full")
//
// It remains exported here for backwards-compatibility.
//
// ParseURL converts a url to a connection string for driver.Open.
// Example:
//
//	"postgres://bob:secret@1.2.3.4:5432/mydb?sslmode=verify-full"
//
// converts to:
//
//	"user=bob password=secret host=1.2.3.4 port=5432 dbname=mydb sslmode=verify-full"
//
// A minimal example:
//
//	"postgres://"
//
// This will be blank, causing driver.Open to use all of the defaults
func parseURL(uri string) (string, error) {
	u, err := url.Parse(uri)
	if err != nil {
		return "", err
	}

	if u.Scheme != "postgres" && u.Scheme != "postgresql" {
		return "", fmt.Errorf("invalid connection protocol: %s", u.Scheme)
	}

	var kvs []string
	escaper := strings.NewReplacer(` `, `\ `, `'`, `\'`, `\`, `\\`)
	accrue := func(k, v string) {
		if v != "" {
			kvs = append(kvs, k+"="+escaper.Replace(v))
		}
	}

	if u.User != nil {
		v := u.User.Username()
		accrue("user", v)

		v, _ = u.User.Password()
		accrue("password", v)
	}

	if host, port, err := net.SplitHostPort(u.Host); err != nil {
		accrue("host", u.Host)
	} else {
		accrue("host", host)
		accrue("port", port)
	}

	if u.Path != "" {
		accrue("dbname", u.Path[1:])
	}

	q := u.Query()
	for k := range q {
		accrue(k, q.Get(k))
	}

	sort.Strings(kvs) // Makes testing easier (not a performance concern)
	return strings.Join(kvs, " "), nil
}

// Service common functionality shared between the postgresql and postgresql_extensible
// packages.
type Service struct {
	Address       string
	OutputAddress string
	MaxIdle       int
	MaxOpen       int
	MaxLifetime   config.Duration
	DB            *sql.DB
	IsPgBouncer   bool `toml:"-"`

	LogFilePath string
	LogDebug    bool

	Logger *zap.Logger
}

func (p *Service) setupLogger() {
	// https://github.com/uber-go/zap/blob/master/FAQ.md#does-zap-support-log-rotation
	w := zapcore.AddSync(&lumberjack.Logger{
		Filename:   p.LogFilePath,
		MaxSize:    10, // megabytes
		MaxBackups: 1,
		MaxAge:     4, //days
		Compress:   false,
	})

	encoderCfg := zap.NewProductionEncoderConfig()
	encoderCfg.TimeKey = "timestamp"
	encoderCfg.EncodeTime = zapcore.ISO8601TimeEncoder // 2021-01-15T13:36:42.978-0800

	logLevel := zap.InfoLevel
	if p.LogDebug {
		logLevel = zap.DebugLevel
	}
	core := zapcore.NewCore(
		zapcore.NewJSONEncoder(encoderCfg),
		w,
		logLevel,
	)
	p.Logger = zap.New(core, zap.AddStacktrace(zap.ErrorLevel))
}

var socketRegexp = regexp.MustCompile(`/\.s\.PGSQL\.\d+$`)

// Start starts the ServiceInput's service, whatever that may be
func (p *Service) Start(telegraf.Accumulator) (err error) {
	p.setupLogger()

	const localhost = "host=localhost sslmode=disable"

	if p.Address == "" || p.Address == "localhost" {
		p.Address = localhost
	}

	connConfig, err := pgx.ParseConfig(p.Address)
	if err != nil {
		return err
	}

	// Remove the socket name from the path
	connConfig.Host = socketRegexp.ReplaceAllLiteralString(connConfig.Host, "")

	// Specific support to make it work with PgBouncer too
	// See https://github.com/influxdata/telegraf/issues/3253#issuecomment-357505343
	if p.IsPgBouncer {
		// Remove DriveConfig and revert it by the ParseConfig method
		// See https://github.com/influxdata/telegraf/issues/9134
		connConfig.PreferSimpleProtocol = true
	}

	host, errS := p.SanitizedAddress()
	if errS != nil {
		host = "unknown"
	}
	p.Logger.Info("connecting", zap.String("server", host))

	connectionString := stdlib.RegisterConnConfig(connConfig)
	if p.DB, err = sql.Open("pgx", connectionString); err != nil {
		return err
	}

	p.DB.SetMaxOpenConns(p.MaxOpen)
	p.DB.SetMaxIdleConns(p.MaxIdle)
	p.DB.SetConnMaxLifetime(time.Duration(p.MaxLifetime))

	return nil
}

// Stop stops the services and closes any necessary channels and connections
func (p *Service) Stop() {
	// Ignore the returned error as we cannot do anything about it anyway
	//nolint:errcheck,revive
	p.DB.Close()
}

var kvMatcher, _ = regexp.Compile(`(password|sslcert|sslkey|sslmode|sslrootcert)=\S+ ?`)

// SanitizedAddress utility function to strip sensitive information from the connection string.
func (p *Service) SanitizedAddress() (sanitizedAddress string, err error) {
	var (
		canonicalizedAddress string
	)

	if p.OutputAddress != "" {
		return p.OutputAddress, nil
	}

	if strings.HasPrefix(p.Address, "postgres://") || strings.HasPrefix(p.Address, "postgresql://") {
		if canonicalizedAddress, err = parseURL(p.Address); err != nil {
			return sanitizedAddress, err
		}
	} else {
		canonicalizedAddress = p.Address
	}

	sanitizedAddress = kvMatcher.ReplaceAllString(canonicalizedAddress, "")

	return sanitizedAddress, err
}
