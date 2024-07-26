package all

import (
	_ "github.com/influxdata/telegraf/plugins/inputs/cloudwatch"
	_ "github.com/influxdata/telegraf/plugins/inputs/internal"
	_ "github.com/influxdata/telegraf/plugins/inputs/mysql"
	_ "github.com/influxdata/telegraf/plugins/inputs/postgresql"
	_ "github.com/influxdata/telegraf/plugins/inputs/postgresql_extensible"
	_ "github.com/influxdata/telegraf/plugins/inputs/procstat"
	_ "github.com/influxdata/telegraf/plugins/inputs/snmp"
)
