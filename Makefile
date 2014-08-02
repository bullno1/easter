.PHONY: doc

MARKDOWN:=$(wildcard doc/*.md)
HTML:=$(MARKDOWN:doc/%.md=html-doc/%.html)
STYLESHEET:=http://s3.jfh.me/css/john-full.css

doc: $(HTML) | html-doc/

html-doc/%.html: doc/%.md Makefile | html-doc/
	@ echo "$< -> $@"
	@ cat $< \
	| sed 's/\(\[[^]]*\]\)(\([^.]*\)\.md\([^)]*\))/\1(\2.html\3)/g' \
	| pandoc -c $(STYLESHEET) -f markdown -t html -s -o $@

%/:
	mkdir -p $@
