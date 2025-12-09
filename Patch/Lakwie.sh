docker service ls --format '{{.Name}}' | grep 'bayview-nondel-qa_' | xargs -I {} docker service scale {}=0


ordered_services=("bayview-nondel-qa_finexpdiscovery" "bayview-nondel-qa_finexpconfigserver" "bayview-nondel-qa_finexpproxy" "bayview-nondel-qa_finexpuiapp" "bayview-nondel-qa_finexpapigateway" "bayview-nondel-qa_finexpmortgageservices"); for svc in "${ordered_services[@]}"; do docker service scale "$svc"=1; sleep 120; done; remaining=$(docker service ls --format '{{.Name}}' | grep bayview-nondel-qa_ | grep -v -e finexpdiscovery -e finexpconfigserver -e finexpproxy -e finexpuiapp -e finexpapigateway -e finexpmortgageservices); for r in $remaining; do docker service scale "$r"=1; done



