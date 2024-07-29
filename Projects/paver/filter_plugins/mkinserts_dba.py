class FilterModule(object):
    def filters(self):
        return {
            'mkinserts_dba': self.mkinserts_dba,
        }

    def mkinserts_dba(self, d, instance_name, hostname, tablename='access_dba'):
        """ Generates  INSERT SQL statements from instance dict """
        if not isinstance(d, dict):
            raise Exception("incorrect instance def")
        found = {}
        for i in ('dba_src_cidrs', 'dbnames', 'type'):
           if d.get(i, None) == None:
               print("WARNING: no {0} key found in instance def".format(i))
               found[i] = ''
               continue
           found[i] = d[i]
        sql = ''
        ips = found.get('dba_src_cidrs', None)
        if ips == None:
            return None
        for ip in ips:
            s = ("INSERT INTO {0} ({1}, {2}, {3}, {4} , {5}) "
                 "VALUES ('{6}', '{7}', '{8}', '{9}', '{10}');\n").format(tablename,
                                                                         'hostname',
                                                                         'instance_name',
                                                                         'type',
                                                                         'dbnames',
                                                                         'ip',
                                                                         hostname,
                                                                         instance_name,
                                                                         found['type'],
                                                                         ','.join(found['dbnames']),
                                                                         ip)
            sql = sql + s
        return sql

