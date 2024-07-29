####################################
# conv_values.py
#
# Description:  Converts values such as: from 2000M or 2G to 2097152000, for example,
#               and from ON to 1 and OFF to 0.
#
# Notes:  It checks the end of the value for K,M or G.
#           If none found, it simple returns the value as is.
#         String values, such as REPEATABLE-READ are returned as is.
#         If the value is empty or undefined, it returns "Unknown".
#
# Bugs:   If a value is non-numeric, but ends with K,M or G (such as 'This-Value-is-WronG') 
#           it will error out.
####################################

def conv_values(self):
    data = self
   
    if data:
       [ var_name, var_value ] = data.split()
      
       if var_value == "ON":
          var_value = "1"
       elif var_value == "OFF":
          var_value = "0"
       elif var_value.rfind('K') != -1:
          multiply = 1024
          var_value = var_value.replace("K","") 
          var_value = (int(var_value) * multiply)
       elif var_value.rfind('M') != -1:
          multiply = 1024 * 1024
          var_value = var_value.replace("M","") 
          var_value = (int(var_value) * multiply)
       elif var_value.rfind('G') != -1:
          multiply = 1024 * 1024 * 1024
          var_value = var_value.replace("G","") 
          var_value = (int(var_value) * multiply)
       else:
          return var_value
    else:
       return "Unknown"

    return var_value
 
class FilterModule(object):
    def filters(self):
        return { 'conv_values': conv_values }

