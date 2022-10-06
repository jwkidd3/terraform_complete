#!/bin/bash

cat > index.html <<EOF
<h1>${server_text}!</h1>
EOF

nohup busybox httpd -f -p ${server_port} &