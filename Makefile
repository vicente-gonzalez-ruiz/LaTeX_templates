default:	html

.PHONY: clean

BIBINPUTS += ".:$(BIBS):$(LATEX_TEMPLATES)"
#TEXINPUTS = ".:~/templates:"$(shell find . -name "??-*" -type d | xargs printf "%s:")$(shell find . -name "??-*" -type l | xargs printf "%s:")
#TEXINPUTS = ".:$(HOME)/LaTeX_templates:"$(shell find . -name "??-*" -type d | xargs printf "%s:")$(shell find . -name "??-*" -type l | xargs printf "%s:")
TEXINPUTS = ".:$(LATEX_TEMPLATES):"
DEPS := $(wildcard *.tex)

index.pdf:	texput.tex $(DEPS) ~/repos/bibs
	@echo $(DEPS)
	@echo -e "\e[91mCompiling index.tex\e[0m"
	if [ -d "graphics" ]; \
	then \
		make -C graphics; \
	fi
	(export TEXINPUTS=${TEXINPUTS}; pdflatex index.tex) # index.tex is in LaTeX_templates
	if ( grep "citation" index.aux > /dev/null); then	\
		(export BIBINPUTS=${BIBINPUTS}; bibtex index);	\
	fi
	makeglossaries index
	(export TEXINPUTS=${TEXINPUTS}; pdflatex index.tex)
	while ( grep "Rerun to get cross-references" 		\
                        index.log > /dev/null ); do		\
		makeglossaries index;				\
                (export TEXINPUTS=${TEXINPUTS}; pdflatex --interaction errorstopmode index);	\
        done

# htlatex filename "options for tex4ht.sty" "options for tex4ht" "options for t4ht" "LaTeX options"
# https://github.com/michal-h21/helpers4ht/wiki/tex4ht-tutorial

index.html:	index.pdf
	(export TEX4HTINPUTS=${TEXINPUTS}; export TEXINPUTS=${TEXINPUTS}; make4ht index.tex "xhtml,mathjax" --config MyConfig.cfg)
	#(export TEX4HTINPUTS=${TEXINPUTS}; export TEXINPUTS=${TEXINPUTS}; htlatex index.tex "footnotes_in.cfg,xhtml,html5,mathjax,charset=utf-8" " -cunihtf -utf8")
	#(export TEX4HTINPUTS=${TEXINPUTS}; export TEXINPUTS=${TEXINPUTS}; make4ht index.tex "mathjax")
	#(export TEX4HTINPUTS=${TEXINPUTS}; export TEXINPUTS=${TEXINPUTS}; make4ht -sc myconfig.cfg index.tex "0,mathjax,p-indent,charset=utf-8" " -cunihtf -utf8")

	###(export TEX4HTINPUTS=${TEXINPUTS}; export TEXINPUTS=${TEXINPUTS}; make4ht index.tex -f html5+mathjax)
	#(export TEX4HTINPUTS=${TEXINPUTS}; export TEXINPUTS=${TEXINPUTS}; make4ht -f html5 index.tex)
	#(export TEX4HTINPUTS=${TEXINPUTS}; export TEXINPUTS=${TEXINPUTS}; make4ht index.tex)

	# Math as PNG
	#(export TEX4HTINPUTS=${TEXINPUTS}; export TEXINPUTS=${TEXINPUTS}; htlatex index.tex)
	#(export TEX4HTINPUTS=${TEXINPUTS}; export TEXINPUTS=${TEXINPUTS}; make4ht index.tex)

	# Math with mathml
	####(export TEX4HTINPUTS=${TEXINPUTS}; export TEXINPUTS=${TEXINPUTS}; htlatex index.tex "xhtml,mathml" " -cunihtf" "-cvalidate")

	# Rare fonts
	#(export TEX4HTINPUTS=${TEXINPUTS}; export TEXINPUTS=${TEXINPUTS}; htlatex index.tex "xhtml,mathml" " -cunihtf" "-cvalidate")
	#(export TEX4HTINPUTS=${TEXINPUTS}; export TEXINPUTS=${TEXINPUTS}; make4ht -uf html5 index.tex)
	#(export TEX4HTINPUTS=${TEXINPUTS}; export TEXINPUTS=${TEXINPUTS}; make4ht -uf html5+mathjax -c math.cfg index.tex)
	#(export TEX4HTINPUTS=${TEXINPUTS}; export TEXINPUTS=${TEXINPUTS}; htlatex index.tex "math2.cfg, charset=utf-8" " -cunihtf -utf8")
	#(export TEX4HTINPUTS=${TEXINPUTS}; export TEXINPUTS=${TEXINPUTS}; htlatex index.tex "math.cfg, charset=utf-8, mathjax" " -cunihtf -utf8")
	#(export TEX4HTINPUTS=${TEXINPUTS}; export TEXINPUTS=${TEXINPUTS}; htlatex index.tex "math.cfg, index.cfg, 1, charset=utf-8" " -cunihtf -utf8") # Este permite controlar el tamaño de las figuras
	#(export TEX4HTINPUTS=${TEXINPUTS}; export TEXINPUTS=${TEXINPUTS}; make4ht -u -c mysec.cfg -c math.cfg index.tex "mathjax")
	#(export TEX4HTINPUTS=${TEXINPUTS}; export TEXINPUTS=${TEXINPUTS}; htlatex index.tex "math.cfg, mathjax" " -cunihtf -utf8")

	# No refs
	#(export TEX4HTINPUTS=${TEXINPUTS}; export TEXINPUTS=${TEXINPUTS}; make4ht index.tex "math2.cfg, mathjax" " -cunihtf -utf8")
	#(export TEX4HTINPUTS=${TEXINPUTS}; export TEXINPUTS=${TEXINPUTS}; make4ht -u -c mysec.cfg -c math2.cfg index.tex "mathjax")
	rm -f index.4ct index.4tc index.acn index.acr index.alg index.bbl index.blg index.dvi index.idv index.idx index.lg index.log index.out index.tmp index.toc index.xdy index.xref

html:	index.html

all:	html

clean:
	rm -f index.pdf index*.html index*.html *.log *.aux *.toc *.bbl *.blg *.idx *.4tc *.tmp *.css *.4ct *.lg *.xref *.out *.idv *.dvi index*.png *.bak *~ index*.png *.acn *.acr *.alg *.xdy

git_clean:
	rm -f index.4ct index.4tc index.aux index.bbl index.blg index.dvi index.idv index.lg index.log index.out index.tmp index.toc index.xref index.pdf

mrproper:
	make clean

info:
	@echo "Tex subdirectories:" $(TEXINPUTS)
	@echo
	@echo "Bib subdirectories:" $(BIBINPUTS)
	@echo
	@echo "Dependecies:" $(DEPS)
