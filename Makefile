SOURCES=$(shell python3 scripts/read-config.py --sources )
FAMILY=$(shell python3 scripts/read-config.py --family )
DRAWBOT_SCRIPTS=$(shell ls documentation/*.py)
DRAWBOT_OUTPUT=$(shell ls documentation/*.py | sed 's/\.py/.png/g')

help:
	@echo "###"
	@echo "# Build targets for $(FAMILY)"
	@echo "###"
	@echo
	@echo "  make build:  Builds the fonts and places them in the fonts/ directory"
	@echo "  make test:   Tests the fonts with fontbakery"
	@echo "  make proof:  Creates HTML proof documents in the proof/ directory"
	@echo "  make images: Creates PNG specimen images in the documentation/ directory"
	@echo

build: build.stamp

venv: venv/touchfile

venv-test: venv-test/touchfile

customize: venv
	. venv/bin/activate; python3 scripts/customize.py

build.stamp: venv sources/config.yaml $(SOURCES)
	rm -rf fonts
	(for config in sources/config*.yaml; do . venv/bin/activate; gftools builder $$config; done)  && touch build.stamp

venv/touchfile: requirements.txt
	test -d venv || python3 -m venv venv
	. venv/bin/activate; pip install -Ur requirements.txt
	touch venv/touchfile

venv-test/touchfile: requirements-test.txt
	test -d venv-test || python3 -m venv venv-test
	. venv-test/bin/activate; pip install -Ur requirements-test.txt
	touch venv-test/touchfile

test: venv-test build.stamp
	TOCHECK=$$(find fonts/variable -type f 2>/dev/null); if [ -z "$$TOCHECK" ]; then TOCHECK=$$(find fonts/ttf -type f 2>/dev/null); fi ; . venv-test/bin/activate; mkdir -p out/ out/fontbakery; fontbakery check-googlefonts -l WARN --full-lists --succinct --badges out/badges --html out/fontbakery/fontbakery-report.html --ghmarkdown out/fontbakery/fontbakery-report.md $$TOCHECK  || echo '::warning file=sources/config.yaml,title=Fontbakery failures::The fontbakery QA check reported errors in your font. Please check the generated report.'

proof: venv build.stamp
	TOCHECK=$$(find fonts/variable -type f 2>/dev/null); if [ -z "$$TOCHECK" ]; then TOCHECK=$$(find fonts/ttf -type f 2>/dev/null); fi ; . venv/bin/activate; mkdir -p out/ out/proof; diffenator2 proof $$TOCHECK -o out/proof

images: venv $(DRAWBOT_OUTPUT)

%.png: %.py build.stamp
	. venv/bin/activate; python3 $< --output $@

clean:
	rm -rf venv
	find . -name "*.pyc" -delete

update-project-template:
	npx update-template https://github.com/googlefonts/googlefonts-project-template/

update: venv venv-test
	venv/bin/pip install --upgrade pip-tools
	# See https://pip-tools.readthedocs.io/en/latest/#a-note-on-resolvers for
	# the `--resolver` flag below.
	venv/bin/pip-compile --upgrade --verbose --resolver=backtracking requirements.in
	venv/bin/pip-sync requirements.txt

	venv-test/bin/pip install --upgrade pip-tools
	venv-test/bin/pip-compile --upgrade --verbose --resolver=backtracking requirements-test.in
	venv-test/bin/pip-sync requirements-test.txt

	git commit -m "Update requirements" requirements.txt requirements-test.txt
	git push

regtest: test-result.pdf

test-result.pdf:
	rm -fr regtests/output
	mkdir regtests/output
	(cd regtests/; i=0; while read -r in; do i=$$(($$i+1)); sed -e s/foo/"$$in"/ regtest.tex > output/"$$i".tex; lualatex --interaction=nonstopmode --output-directory=output/ output/"$$i".tex; done < foo.lst)
	(cd regtests/output; rm -fr *.aux *.log *.tex)
	mkdir regtests/results
	(cd regtests/; i=0; j=0; while read in; do i=$$(($$i+1)); compare -metric phash baseline/"$$i".pdf output/"$$i".pdf results/"$$i".pdf || j=$$(($$j+$$?)); echo ""; done < foo.lst; gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -dPDFSETTINGS=/screen -sOutputFile=test-result.pdf results/*.pdf; cp test-result.pdf ../test-result.pdf; rm -fr results/; rm -fr output/; exit "$$j")

baseline:
	rm -fr regtests/baseline
	mkdir regtests/baseline
	(cd regtests/; i=0; while read -r in; do i=$$(($$i+1)); sed -e s/foo/"$$in"/ regtest.tex > baseline/"$$i".tex; lualatex --output-directory=baseline/ baseline/"$$i".tex; done < foo.lst)
	(cd regtests/baseline; rm -fr *.aux *.log *.tex)

