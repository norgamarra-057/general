package raas

type Server struct {
	Host               string
	Port               int
	Engine             string
	ReplicationGroupId string
	Password           string
	Resque             bool
	ResqueNs           string
}

