class FilterModule(object):
    def filters(self):
        return {
            'update': self.update,
        }

    def update(self, d1, d2):
        """ Parses out key:value pairs from stdout_lines """
        if not isinstance(d1, dict) or not isinstance(d2, dict):
            raise Exception("update operates on dict")
        d1.update(d2)
        return d1
