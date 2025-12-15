Q4-2025-Newfi-Prod-infra-inspector-scan_Pre-Patch-Scan

Bayview-cd-demo-infra-inspector-

Hi Team,
Maintenance is in progress. The DBA team has requested to stop the Mongo service on the following IPs: 10.210.84.58, 10.210.84.99
Please proceed.

zx5c5ngtgu3q   newfibroker-prod_discovery            replicated   1/1        965092108885.dkr.ecr.us-west-2.amazonaws.com/finexp/finexpdiscovery:2025-11-10      *:8761->8761/tcp
30k78i0cckxe   newfibroker-prod_discoveryII          replicated   1/1        965092108885.dkr.ecr.us-west-2.amazonaws.com/finexp/finexpdiscovery:2025-11-10      *:8762->8761/tcp
qle9ror99354   newfibroker-prod_finexpapigateway     replicated   2/2        965092108885.dkr.ecr.us-west-2.amazonaws.com/finexp/finexpapigateway:2025-11-24
umvhjbakxukl   newfibroker-prod_finexpbrokermngmt    replicated   2/2        965092108885.dkr.ecr.us-west-2.amazonaws.com/finexp/finexpbrokermgmt:2025-11-10
xz3kfrochzbw   newfibroker-prod_finexpconfigserver   replicated   2/2        965092108885.dkr.ecr.us-west-2.amazonaws.com/finexp/finexpconfigserver:2025-11-10   *:8090->8090/tcp
4kwi20re0jgw   newfibroker-prod_finexploan           replicated   2/2        965092108885.dkr.ecr.us-west-2.amazonaws.com/finexp/finexploan:2025-11-10
ibi8ne78q9bu   newfibroker-prod_finexpnotification   replicated   2/2        965092108885.dkr.ecr.us-west-2.amazonaws.com/finexp/finexpnotification:2025-11-10
hqhnjyox6xs3   newfibroker-prod_finexppricing        replicated   2/2        965092108885.dkr.ecr.us-west-2.amazonaws.com/finexp/finexppricing:2025-11-10
s8wtzn407lsw   newfibroker-prod_finexpproxy          replicated   3/3        965092108885.dkr.ecr.us-west-2.amazonaws.com/finexp/finexpproxy:2025-11-10          *:9090->9090/tcp
ts7z26sc0pqr   newfibroker-prod_finexpuiapp          replicated   2/2        965092108885.dkr.ecr.us-west-2.amazonaws.com/finexp/finexpuiapp:2025-11-24          *:9010->9010/tcp
s0m2c29rlwen   newfibroker-prod_finexpusermgmt       replicated   2/2        965092108885.dkr.ecr.us-west-2.amazonaws.com/finexp/finexpusermgmt:2025-11-10


I want all the above services to be scaled back to their original state in the following order: discovery, config, proxy, uiapp, API Gateway, and mortgage. Each of these services should have a 3-minute delay before scaling the next one. All remaining services should scale immediately after these. Please run this in nohup mode. and add which service its scaling and after service do docker service ls



docker service scale newfibroker-prod_discovery=1