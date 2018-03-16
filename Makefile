

watch:
	fswatch -r js-templates/*.html  | xargs -I{} make build	

build: js-dist/templates.js

js-dist/templates.js: $(wildcard js-templates/*.html)
	./scripts/jsify_html.sh

clean:
	@rm -rf js-dist/

reset-vendor:
	@rm -rf js-vendor/

js-vendor:
	./scripts/get_vendor_libs.sh

all:
	@make js-vendor
	@make build

.PHONY: watch all clean reset-vendor js-vendor