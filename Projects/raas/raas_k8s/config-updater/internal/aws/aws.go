package aws

import (
	"config-updater/internal/raas"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/elasticache"
	"go.uber.org/zap"
	"strings"
	"time"
)

type AWSElastiCache struct {
	Region string
	svc    *elasticache.ElastiCache
}

// Must be called before calling AWS's API
func (ec *AWSElastiCache) InitAWSElastiCacheService() {
	zap.L().Info("AWSElastiCache.InitAWSElastiCacheService")
	sess, err := session.NewSession(&aws.Config{Region: aws.String(ec.Region)})
	if err != nil {
		panic(err.Error())
	}
	zap.L().Info("got_aws_session")
	ec.svc = elasticache.New(sess)
}

func (ec *AWSElastiCache) QueryServers() (res []raas.Server) {
	zap.L().Info("AWSElastiCache.QueryServers")
	var server raas.Server
	var pageMarker *string
	for { // loop through paginated results
		input := &elasticache.DescribeCacheClustersInput{
			ShowCacheNodeInfo: aws.Bool(true),
			Marker:            pageMarker,
		}
		result, err := ec.svc.DescribeCacheClusters(input)
		if err != nil {
			zap.L().Error("DescribeCacheClusters", zap.String("error", err.Error()))
			panic(err.Error())
		}
		zap.L().Info("cache_clusters", zap.Int("count", len(result.CacheClusters)))
		for _, element := range result.CacheClusters {
			if *element.Engine != "memcached" && *element.Engine != "redis" {
				zap.L().Warn("unknown", zap.String("engine", *element.Engine))
				continue
			}
			if !strings.HasPrefix(*element.CacheSubnetGroupName, "raas") {
				zap.L().Warn("non-raas", zap.String("CacheCluster", *element.CacheClusterId))
				continue
			}
			for _, node := range element.CacheNodes {
				var endpoint *elasticache.Endpoint = node.Endpoint
				// log.Printf("I, engine=%v cluster=%v address=%v:%v",
				// 	*element.Engine,
				// 	*element.CacheClusterId,
				// 	*endpoint.Address,
				// 	*endpoint.Port)
				server = raas.Server{}
				server.Host = *endpoint.Address
				server.Port = int(*endpoint.Port)
				server.Engine = *element.Engine
				// memcached clusters don't have ReplicationGroupId
				// and could cause a SIGSEGV if not handled properly:
				if element.ReplicationGroupId != nil {
					server.ReplicationGroupId = *element.ReplicationGroupId
				}
				res = append(res, server)
			}
		}
		pageMarker = result.Marker
		if pageMarker == nil {
			zap.L().Info("no more pages")
			break
		} else {
			// prevent wrong non-nil pageMarker creating an infinite loop of quick API calls
			zap.L().Info("getting next page in 1s", zap.String("pageMarker", *pageMarker))
			time.Sleep(1 * time.Second)
		}
	}
	return
}
