default:	html

.PHONY: clean

BIBINPUTS += ".:$(BIBS):$(LATEX_TEMPLATES)"
#TEXINPUTS = ".:~/templates:"$(shell find . -name "??-*" -type d | xargs printf "%s:")$(shell find . -name "??-*" -type l | xargs printf "%s:")
#TEXINPUTS = ".:$(HOME)/LaTeX_templates:"$(shell find . -name "??-*" -type d | xargs printf "%s:")$(shell find . -name "??-*" -type l | xargs printf "%s:")
TEXINPUTS = ".:$(LATEX_TEMPLATES):"

index.html:	texput.tex $(TEX_DEPS)
	make -C graphics
	(export TEXINPUTS=${TEXINPUTS}; pdflatex index.tex)
	if ( grep "citation" index.aux > /dev/null); then	\
		(export BIBINPUTS=${BIBINPUTS}; bibtex index);	\
	fi
	makeglossaries index
	(export TEXINPUTS=${TEXINPUTS}; pdflatex index.tex)
	while ( grep "Rerun to get cross-references" 		\
                        index.log > /dev/null ); do		\
		makeglossaries index;				\
                (export TEXINPUTS=${TEXINPUTS}; latex --interaction errorstopmode index);	\
        done
	(export TEX4HTINPUTS=${TEXINPUTS}; export TEXINPUTS=${TEXINPUTS}; htlatex index.tex "math.cfg, charset=utf-8" " -cunihtf -utf8")
	#(export TEX4HTINPUTS=${TEXINPUTS}; export TEXINPUTS=${TEXINPUTS}; htlatex index.tex "math.cfg, index.cfg, 1, charset=utf-8" " -cunihtf -utf8")
	#(export TEX4HTINPUTS=${TEXINPUTS}; export TEXINPUTS=${TEXINPUTS}; make4ht -u -c mysec.cfg -c math.cfg index.tex)

html:	index.html

all:	html

clean:
	rm -f index.pdf index*.html index*.html *.log *.aux *.toc *.bbl *.blg *.idx *.4tc *.tmp *.css *.4ct *.lg *.xref *.out *.idv *.dvi index*.png *.bak *~ index*.png

git_clean:
	rm -f index.4ct index.4tc index.aux index.bbl index.blg index.dvi index.idv index.lg index.log index.out index.tmp index.toc index.xref index.pdf

mrproper:
	make clean

info:
	@echo "Tex subdirectories (TEXINPUTS):" $(TEXINPUTS)
	@echo
	@echo "Bib subdirectories (BININPUTS):" $(BIBINPUTS)
	@echo
	@echo "Tex dependecies (TEX_DEPS):" $(TEX_DEPS)
