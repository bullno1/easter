.PHONY: doc

MARKDOWN:=$(wildcard doc/*.md)
HTML:=$(MARKDOWN:doc/%.md=html-doc/%.html)
STYLESHEET:=http://s3.jfh.me/css/john-full.css

doc: $(HTML) | html-doc/

html-doc/index.html: doc/index.md README.md Makefile | html-doc/
	@ echo "$< -> $@"
	@ cat README.md doc/index.md \
	| sed 's/\([[(]\)doc\//\1/g' \
	| sed 's/\(\[[^]]*\]\)(\([^.]*\)\.md\([^)]*\))/\1(\2.html\3)/g' \
	| pandoc -c $(STYLESHEET) -f markdown -t html -s -o $@

html-doc/%.html: doc/%.md Makefile | html-doc/
	@ echo "$< -> $@"
	@ cat $< \
	| sed 's/\(\[[^]]*\]\)(\([^.]*\)\.md\([^)]*\))/\1(\2.html\3)/g' \
	| pandoc -c $(STYLESHEET) -f markdown -t html -s -o $@

%/:
	mkdir -p $@
