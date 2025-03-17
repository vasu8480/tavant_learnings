docker service ls --format '{{.Name}}' | grep 'bayview-nondel-qa_' | while read SERVICE; do
  docker service scale "$SERVICE"=0
done


docker service ls --format '{{.Name}}' | while read SERVICE; do
  docker service scale "$SERVICE"=0
done


docker service ls --format '{{.Name}}' | while read SERVICE; do
  docker service scale "$SERVICE"=0
done



discovery,config,uiapp,proxy,apigtway , mortage, then any
in this order scale all =1  usigng ID
zqsc8umzhtgg   bayview-nondel-qa_finexpapigateway         replicated   0/0        600427762251.dkr.ecr.us-east-2.amazonaws.com/finexp/finexpapigateway:latest-qa         *:9020->9020/tcp
stl47591xf96   bayview-nondel-qa_finexpauthorization      replicated   0/0        600427762251.dkr.ecr.us-east-2.amazonaws.com/finexp/finexpauthorization:latest-qa      *:9001->9001/tcp
of3yc9xfwoey   bayview-nondel-qa_finexpbrokermgmt         replicated   0/0        600427762251.dkr.ecr.us-east-2.amazonaws.com/finexp/finexpbrokermgmt:latest-qa         *:8060->8060/tcp
z1u9vw3x2bg9   bayview-nondel-qa_finexpconfigserver       replicated   0/0        600427762251.dkr.ecr.us-east-2.amazonaws.com/finexp/finexpconfigserver:latest-qa       *:8090->8090/tcp
bgkqs5zso12n   bayview-nondel-qa_finexpdiscovery          replicated   0/0        600427762251.dkr.ecr.us-east-2.amazonaws.com/finexp/finexpdiscovery:latest-qa          *:8761->8761/tcp
okqj3o9b2ty3   bayview-nondel-qa_finexploan               replicated   0/0        600427762251.dkr.ecr.us-east-2.amazonaws.com/finexp/finexploan:latest-qa               *:7070->7070/tcp
2ycxw138caqd   bayview-nondel-qa_finexpmortgageservices   replicated   0/0        600427762251.dkr.ecr.us-east-2.amazonaws.com/finexp/finexpmortgageservices:latest-qa   *:9025->9025/tcp
77kuhps28hc4   bayview-nondel-qa_finexpnotification       replicated   0/0        600427762251.dkr.ecr.us-east-2.amazonaws.com/finexp/finexpnotification:latest-qa       *:9031->9031/tcp
r56cogxnqvyg   bayview-nondel-qa_finexppricing            replicated   0/0        600427762251.dkr.ecr.us-east-2.amazonaws.com/finexp/finexppricing:latest-qa            *:7170->7170/tcp
nxdkl2l8yw3o   bayview-nondel-qa_finexpproxy              replicated   0/0        600427762251.dkr.ecr.us-east-2.amazonaws.com/finexp/finexpproxy:latest-qa              *:9090->9090/tcp
4uujiq89ht16   bayview-nondel-qa_finexpschedulerservice   replicated   0/0        600427762251.dkr.ecr.us-east-2.amazonaws.com/finexp/finexpschedulerservice:latest-qa   *:9030->9030/tcp
6c3l7t79pmjt   bayview-nondel-qa_finexpuiapp              replicated   0/0        600427762251.dkr.ecr.us-east-2.amazonaws.com/finexp/finexpuiapp:latest-qa              *:9010->9010/tcp
52fq9ybd1oa1   bayview-nondel-qa_finexpusermgmt           replicated   0/0        600427762251.dkr.ecr.us-east-2.amazonaws.com/finexp/finexpusermgmt:latest-qa           *:9091->9091/tcp






start all the


cayyr7b8idwi   bayview_lo_demo_finexpapigateway         replicated   1/1        187189592310.dkr.ecr.us-east-1.amazonaws.com/finexp/finexpapigateway:latest-uat         *:9021->9021/tcp
vgo1g8hftl16   bayview_lo_demo_finexpconfigserver       replicated   1/1        187189592310.dkr.ecr.us-east-1.amazonaws.com/finexp/finexpconfigserver:latest-uat       *:8091->8091/tcp
q62vy4t1y45z   bayview_lo_demo_finexpdiscovery          replicated   1/1        187189592310.dkr.ecr.us-east-1.amazonaws.com/finexp/finexpdiscovery:latest-uat          *:8761->8761/tcp
qzqp4b9azytk   bayview_lo_demo_finexpleadmgmt           replicated   1/1        187189592310.dkr.ecr.us-east-1.amazonaws.com/finexp/finexpleadmgmt:latest-uat           *:9061->9061/tcp
dz7jmu1rso29   bayview_lo_demo_finexploan               replicated   1/1        187189592310.dkr.ecr.us-east-1.amazonaws.com/finexp/finexploan:latest-uat               *:7071->7071/tcp
d09npzlf8367   bayview_lo_demo_finexpmortgageservice    replicated   1/1        187189592310.dkr.ecr.us-east-1.amazonaws.com/finexp/finexpmortgageservice:latest-uat    *:9001->9001/tcp
eleu1mcwqbq9   bayview_lo_demo_finexpnotification       replicated   1/1        187189592310.dkr.ecr.us-east-1.amazonaws.com/finexp/finexpnotification:latest-uat       *:9031->9031/tcp
nyyivw2u3d05   bayview_lo_demo_finexpntbservice         replicated   1/1        187189592310.dkr.ecr.us-east-1.amazonaws.com/finexp/finexpntbservice:latest-uat         *:9051->9051/tcp
s6fvustaskw2   bayview_lo_demo_finexpoauth              replicated   1/1        187189592310.dkr.ecr.us-east-1.amazonaws.com/finexp/finexp-oauth-service:latest-uat     *:8081->8081/tcp
pj6o7jfh8fkx   bayview_lo_demo_finexppricing            replicated   1/1        187189592310.dkr.ecr.us-east-1.amazonaws.com/finexp/finexppricing:latest-uat            *:7171->7171/tcp
y7grnls3vngg   bayview_lo_demo_finexpproxy              replicated   1/1        187189592310.dkr.ecr.us-east-1.amazonaws.com/finexp/finexpproxy:latest-uat              *:9091->9091/tcp
nh5wd3k9gxea   bayview_lo_demo_finexpretaillomgmt       replicated   1/1        187189592310.dkr.ecr.us-east-1.amazonaws.com/finexp/finexpretaillomgmt:latest-uat       *:8061->8061/tcp
ufm9fan3h1ta   bayview_lo_demo_finexpschedulerservice   replicated   1/1        187189592310.dkr.ecr.us-east-1.amazonaws.com/finexp/finexpschedulerservice:latest-uat   *:9041->9041/tcp
scnrolih6xx4   bayview_lo_demo_finexpuiapp              replicated   1/1        187189592310.dkr.ecr.us-east-1.amazonaws.com/finexp/finexpuiapp:latest-uat              *:9011->9011/tcp
w0ud6vac5678   bayview_lo_demo_finexpusermgmt           replicated   1/1        187189592310.dkr.ecr.us-east-1.amazonaws.com/finexp/finexpusermgmt:latest-uat           *:7091->7091/tcp