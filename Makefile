rdf:
	rapper -i turtle -o rdfxml-abbrev namespace.ttl >namespace.rdf

html: rdf
	xsltproc namespace.xsl namespace.rdf >namespace.html

install: rdf
	owcli -m http://purl.org/net/pingback/ -e model:drop model:create model:add -i namespace.rdf

clean:
	rm namespace.rdf
	rm namespace.html

