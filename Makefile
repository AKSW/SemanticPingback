rdf:
	cwm namespace.n3 --rdf >namespace.rdf

html:
	xsltproc namespace.xsl namespace.rdf >namespace.html

install: rdf
	owcli -m http://purl.org/net/pingback/ -e model:drop model:create model:add -i namespace.rdf
