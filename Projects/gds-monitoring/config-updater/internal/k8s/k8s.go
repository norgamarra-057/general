package k8s

import (
	"context"
	"go.uber.org/zap"
	"os"
	"time"

	appsv1 "k8s.io/api/apps/v1"
	"k8s.io/api/core/v1"
	"k8s.io/apimachinery/pkg/api/errors"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	utilyaml "k8s.io/apimachinery/pkg/util/yaml"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/rest"

	"daas-config-updater/internal/daas"
	"daas-config-updater/internal/telegraf"
)

type Kube struct {
	clientset *kubernetes.Clientset
	Ns        string
}

// Creates a K8s configmap with a telegraf configs
// Used when creating a K8s Deployment
func (kube *Kube) CreateInputConfigMap(data map[string]string) *v1.ConfigMap {
	zap.L().Info("Kube.CreateInputConfigMap")
	cmapName := "cmap-telegrafd-v" + time.Now().Format("2006-01-02.15.04.05")

	// https://godoc.org/k8s.io/api/core/v1#ConfigMap
	// https://sourcegraph.com/github.com/kubernetes/api/-/blob/core/v1/types.go#L5008:6=&tab=references:external
	// https://sourcegraph.com/github.com/yliaog/kubernetes@f0e8790261ca76f3872d20f4856e35f579dbb5fc/-/blob/pkg/apis/componentconfig/helpers.go#L91:1
	// https://github.com/kubernetes/client-go/blob/master/kubernetes/typed/core/v1/configmap.go
	cm, err := kube.clientset.CoreV1().ConfigMaps(kube.Ns).Create(context.Background(), &v1.ConfigMap{
		ObjectMeta: metav1.ObjectMeta{
			Name:      cmapName,
			Namespace: kube.Ns,
		},
		Data: data,
	}, metav1.CreateOptions{})
	if err != nil {
		zap.L().Error(err.Error())
		panic(err.Error())
	}
	zap.L().Info("CreateInputConfigMap", zap.String("cm_name", cm.ObjectMeta.Name))
	return cm
}

func (kube *Kube) ParseYamlTelegrafDeployment() (deployment *appsv1.Deployment) {
	f, err := os.Open("/etc/config-updater/telegraf-daas-deployment.yml")
	if err != nil {
		zap.L().Error(err.Error())
		panic(err.Error())
	}
	defer f.Close()

	err = utilyaml.NewYAMLOrJSONDecoder(f, 4096).Decode(&deployment)
	if err != nil {
		zap.L().Error(err.Error())
		panic(err.Error())
	}
	return
}

// Must be called before calling the K8s' API
func (kube *Kube) InitK8sClientset() {
	zap.L().Info("Kube.InitK8sClientset")
	// InClusterConfig reads the pod's dir:
	// /var/run/secrets/kubernetes.io/serviceaccount/
	// which is automatically created when using
	// serviceAccountName: config-updater
	config, err := rest.InClusterConfig()
	if err != nil {
		zap.L().Error(err.Error())
		panic(err.Error())
	}
	kube.clientset, err = kubernetes.NewForConfig(config)
	if err != nil {
		zap.L().Error(err.Error())
		panic(err.Error())
	}
}

func (kube *Kube) SetTelegrafConfigMapName(d *appsv1.Deployment, name string) {
	// fill in the configMap's name. See telegraf-daas-deployment.yml:
	// volumes:
	// - name: vol-etc-telegrafd
	//   configMap:
	//     name: xxxxxx
	for _, vol := range d.Spec.Template.Spec.Volumes {
		if vol.Name == "vol-etc-telegrafd" {
			vol.ConfigMap.Name = name
		}
	}
}

func (kube *Kube) Filter(servers []daas.Server, engine string) (ret []daas.Server) {
	for _, server := range servers {
		if server.Engine == engine {
			ret = append(ret, server)
		}
	}
	return
}

func (kube *Kube) CreateInputConfigMapData(servers []daas.Server) map[string]string {
	data := map[string]string{
		"mysql_input.conf":               telegraf.MysqlInputConf(kube.Filter(servers, "aurora-mysql")),
		"postgres_input.conf":            telegraf.PostgresInputConf(kube.Filter(servers, "postgres")),
		"postgres_extensible_input.conf": telegraf.PostgresExtensibleInputConf(kube.Filter(servers, "postgres")),
	}
	return data
}

func (kube *Kube) NewTelegrafDeployment(servers []daas.Server) *appsv1.Deployment {
	zap.L().Info("Kube.NewTelegrafDeployment")
	data := kube.CreateInputConfigMapData(servers)
	cm := kube.CreateInputConfigMap(data)
	deployment := kube.ParseYamlTelegrafDeployment()
	kube.SetTelegrafConfigMapName(deployment, cm.ObjectMeta.Name)
	return deployment
}

func (kube *Kube) DeployTelegraf(servers []daas.Server) {
	zap.L().Info("Kube.DeployTelegraf")
	deployment := kube.NewTelegrafDeployment(servers)
	// https://github.com/kubernetes/client-go/blob/master/kubernetes/typed/apps/v1/deployment.go
	deploymentsClient := kube.clientset.AppsV1().Deployments(kube.Ns)
	zap.L().Info("deployment.Update")
	result, err := deploymentsClient.Update(context.Background(), deployment, metav1.UpdateOptions{})
	if errors.IsNotFound(err) {
		zap.L().Info("deployment.Create")
		result, err = deploymentsClient.Create(context.Background(), deployment, metav1.CreateOptions{})
	}
	if err != nil {
		zap.L().Error(err.Error())
		panic(err)
	}
	zap.L().Info("deployment", zap.String("deployment_name", result.GetObjectMeta().GetName()))
}
