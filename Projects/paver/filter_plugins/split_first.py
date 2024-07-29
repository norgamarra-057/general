####################################
# split_first.py
#
# Description: Returns the first value of a space-delimited string
#
####################################

def split_first(self):
    data = self
   
    if data:
       [ var_name, var_value ] = data.split()
       return var_name
    else:
       return "Undefined"

class FilterModule(object):
    def filters(self):
        return { 'split_first': split_first }

