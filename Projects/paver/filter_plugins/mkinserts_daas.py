class FilterModule(object):
    def filters(self):
        return {
            'mkinserts_daas': self.mkinserts_daas,
        }

    def mkinserts_daas(self, d, instance_name, hostname, tablename='access'):
        """ Generates  INSERT SQL statements from instance dict """
        if not isinstance(d, dict):
            raise Exception("incorrect instance def")
        found = {}
        for i in ('firewall_permitted_src_cidrs', 'dbnames', 'type'):
           if d.get(i, None) == None:
               print("WARNING: no {0} key found in instance def".format(i))
               found[i] = ''
               continue
           found[i] = d[i]
        sql = ''
        ips = found.get('firewall_permitted_src_cidrs', None)
        if ips == None:
            return None
        for ip in ips:
            s = ("INSERT INTO {0} ({1}, {2}, {3}, {4} , {5}, {6}) "
                 "VALUES ('{7}', '{8}', '{9}', '{10}', '{11}', '{12}');\n").format(tablename,
                                                                         'hostname',
                                                                         'instance_name',
                                                                         'type',
                                                                         'dbnames',
                                                                         'ip',
                                                                         'is_dba',
                                                                         hostname,
                                                                         instance_name,
                                                                         found['type'],
                                                                         ','.join(found['dbnames']),
                                                                         ip,
                                                                         'f')
            sql = sql + s
        return sql

