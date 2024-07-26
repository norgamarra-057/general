package aws

import (
	"daas-config-updater/internal/daas"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/rds"
	"go.uber.org/zap"
	"time"
)

type AWSRDS struct {
	Region string
	svc    *rds.RDS
}

// Must be called before calling AWS's API
func (a *AWSRDS) InitAWSService() {
	zap.L().Info("AWSRDS.InitAWSService")
	sess, err := session.NewSession(&aws.Config{Region: aws.String(a.Region)})
	if err != nil {
		panic(err.Error())
	}
	zap.L().Info("got_aws_session")
	a.svc = rds.New(sess)
}

func (a *AWSRDS) QueryServers() (res []daas.Server) {
	zap.L().Info("AWSRDS.QueryServers")
	var server daas.Server
	var pageMarker *string
	for { // loop through paginated results
		input := &rds.DescribeDBInstancesInput{
			Marker: pageMarker,
		}
		result, err := a.svc.DescribeDBInstances(input)
		if err != nil {
			zap.L().Error("DescribeDBInstances", zap.String("errormsg", err.Error()))
			panic(err.Error())
		}
		zap.L().Info("db_instances", zap.Int("count", len(result.DBInstances)))
		for _, element := range result.DBInstances {
			// element attributes: https://docs.aws.amazon.com/sdk-for-go/api/service/rds/#DBInstance
			server = daas.Server{}
			server.Host = *element.Endpoint.Address
			server.Port = int(*element.Endpoint.Port)
			server.Engine = *element.Engine
			res = append(res, server)
		}
		pageMarker = result.Marker
		if pageMarker == nil {
			zap.L().Info("no more pages")
			break
		} else {
			// prevent wrong non-nil pageMarker creating an infinite loop of quick API calls
			zap.L().Info("getting next page in 10s", zap.String("pageMarker", *pageMarker))
			time.Sleep(10 * time.Second)
		}
	}
	return
}
