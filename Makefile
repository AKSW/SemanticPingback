default:
        #@echo "..."
	cwm namespace.n3 --rdf >namespace.rdf

install:
	cwm namespace.n3 --rdf >namespace.rdf
	owcli -m http://purl.org/net/pingback/ -e model:drop model:create model:add -i namespace.rdf

