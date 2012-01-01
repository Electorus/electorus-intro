L2H = latex2html
LATEX    = latex 
PDFLATEX = pdflatex
DVIPS = dvips
# Main input (w/o extension)
MAIN_FNAME=electorus
# Additional files the main input file depends on
ADDDEPS=

RERUN = "(There were undefined references|Rerun to get (cross-references|the bars) right)"

RERUNBIB = "No file.*\.bbl|Citation.*undefined"

GOALS = $(MAIN_FNAME).pdf 

DVIFILES = $(MAIN_FNAME).dvi

COPY = if test -r $*.toc; then cp $*.toc $*.toc.bak; fi
RM = /bin/rm -f

main:           $(DVIFILES)

all:            $(GOALS)

$(MAIN_FNAME).dvi: $(MAIN_FNAME).tex $(ADDDEPS) electro-input.eps ruelect.eps egolos.eps itogi.eps meeting1.eps meeting2.eps meeting3.eps meeting4.eps electorus-ex.eps stat1.eps stat2.eps stat3.eps
$(MAIN_FNAME).pdf: $(MAIN_FNAME).tex $(ADDDEPS) electro-input.pdf ruelect.png egolos.png itogi.png meeting1.png meeting2.png meeting3.png meeting4.png electorus-ex.pdf stat1.png stat2.png stat3.png

%.dvi:          %.tex
		$(COPY);$(LATEX) $<
		egrep -c $(RERUNBIB) $*.log && ($(BIBTEX) $*;$(COPY);$(LATEX) $<) ; true
		egrep $(RERUN) $*.log && ($(COPY);$(LATEX) $<) ; true
		$(COPY);$(LATEX) $< ; true
		if !(cmp -s $*.toc $*.toc.bak); then $(LATEX) $< ; fi
		$(RM) $*.toc.bak
# Display relevant warnings
		egrep -i "(Reference|Citation).*undefined" $*.log ; true 

%.png:  %.dot
	dot -Tpng -o$@ $<

%.eps:  %.dot
	dot -Teps -o$@ $<

%.png:  %.dia
	dia -e $@ $<

%.eps:  %.dia
	dia -e $@ $<

%.eps:  %.dot
	dot -Tps $< -o $@

%.eps: %.png
	convert $< $@

%.png: %.jpg
	convert $< $@

%.pdf:          %.tex
		$(COPY);$(PDFLATEX) $<
		egrep -c $(RERUNBIB) $*.log && ($(BIBTEX) $*;$(COPY);$(PDFLATEX) $<) ; true
		egrep $(RERUN) $*.log && ($(COPY);$(PDFLATEX) $<) ; true
#		egrep $(RERUN) $*.log && ($(COPY);$(PDFLATEX) $<) ; true
		$(COPY);$(PDFLATEX) $< ; true
		if !(cmp -s $*.toc $*.toc.bak); then $(PDFLATEX) $< ; fi
		$(RM) $*.toc.bak
# Display relevant warnings
		egrep -i "(Reference|Citation).*undefined" $*.log ; true 

clean:          
		$(RM) -f *.aux *.log *.bbl *.blg *.brf *.cb *.ind *.idx *.ilg electorus-ex.png  \
		electro-input.png meeting?.png *.inx *.ps *.dvi electorus.pdf *.toc *.out *.lot *.lof *.eps *.nav *.snm stat3.png

		
