default:	html

.PHONY: clean

BIBINPUTS += ".:$(HOME)/bibs:"
#TEXINPUTS = ".:~/templates:"$(shell find . -name "??-*" -type d | xargs printf "%s:")$(shell find . -name "??-*" -type l | xargs printf "%s:")
#TEXINPUTS = ".:$(HOME)/LaTeX_templates:"$(shell find . -name "??-*" -type d | xargs printf "%s:")$(shell find . -name "??-*" -type l | xargs printf "%s:")
TEXINPUTS = ".:$(HOME)/LaTeX_templates:"

index.html:	texput.tex
	(export TEXINPUTS=${TEXINPUTS}; pdflatex index.tex)
	if ( grep "citation" index.aux > /dev/null); then	\
		(export BIBINPUTS=${BIBINPUTS}; bibtex index);	\
	fi
	(export TEXINPUTS=${TEXINPUTS}; pdflatex index.tex)
	while ( grep "Rerun to get cross-references" 		\
                        index.log > /dev/null ); do		\
                (export TEXINPUTS=${TEXINPUTS}; pdflatex --interaction errorstopmode index);	\
        done
	(export TEX4HTINPUTS=${TEXINPUTS}; export TEXINPUTS=${TEXINPUTS}; htlatex index.tex "math.cfg, index.cfg charset=utf-8" " -cunihtf -utf8")

html:	index.html

all:	html

clean:
	rm -f index.pdf index*.html index*.html *.log *.aux *.toc *.bbl *.blg *.idx *.4tc *.tmp *.css *.4ct *.lg *.xref *.out *.idv *.dvi index*.png *.bak *~ index*.png

mrproper:
	make clean

info:
	@echo "Tex subdirectories (TEXINPUTS):" $(TEXINPUTS)
	@echo
	@echo "Bib subdirectories (BININPUTS):" $(BIBINPUTS)
	@echo
