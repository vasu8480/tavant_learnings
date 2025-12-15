disc , config, proxy uiapp, ApiGateway,  mortage ...any 



I want all the above services to be scaled back to their original state in the following order: discovery, config, proxy, uiapp, API Gateway, and mortgage. Each of these services should have a 3-minute delay before scaling the next one. All remaining services should scale immediately after these. Please run this in nohup mode. and add which service its scaling and after service do docker service ls
