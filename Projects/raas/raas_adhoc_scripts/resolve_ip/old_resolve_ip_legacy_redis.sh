# https://groupondev.atlassian.net/browse/RAAS-8?focusedCommentId=5432105

cat > ~/resolve_ip.py <<EOT
#!/usr/local/bin/env python

import socket
import sys

try:
    print(socket.gethostbyaddr(sys.argv[1])[0])
except:
    print(sys.argv[1])
EOT

chmod +x ~/resolve_ip.py

for x in `{ sudo cat /var/log/messages; sudo zcat /var/log/messages*.gz; } | grep 'redis-' | egrep -o '10\.[0-9.]+' | sort | uniq`; do ./resolve_ip.py $x; done



