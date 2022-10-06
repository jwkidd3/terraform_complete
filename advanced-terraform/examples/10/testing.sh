#!/bin/bash

while true; do curl http://$(terraform output -raw alb_dns_name)/; sleep 1; done