import md5

class FilterModule(object):
     def filters(self):
         return { 'mkhashdict': self.mkhashdict }

     def mkhashdict(self, keys, role, group):
         d = {}
         for i, k in list(enumerate(keys)):
             s = "{0}-{1}-{2}".format(role, k, group)
             m = md5.new()
             m.update(s)
             d[k] = m.hexdigest()
         return d

if __name__ == "__main__":
    f = FilterModule()
    from  pprint import pprint
    l = ['mysql1', 'mysql2', 'mysql3']
    pprint(f.mkhashdict(l, "reader", "cluster1"))
