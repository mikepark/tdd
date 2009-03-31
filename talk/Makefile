
SHOW = tdd_talk
ALL = tdd_handout tdd_talk

.SUFFIXES:

.SUFFIXES: .pdf .tex .dvi .ps

.PHONEY: default dvi ps pdf disp gv wps post clean clobber

default: pdf

dvi: $(ALL:%=%.dvi)

ps: $(ALL:%=%.ps)

pdf: $(ALL:%=%.pdf)

LATEX_OPTIONS = -interaction=nonstopmode

.tex.dvi:
	latex ${LATEX_OPTIONS} $* && rm $*.aux $*.log

.dvi.ps:
	dvips -o $*.ps $*

.tex.pdf:
	pdflatex $*.tex

disp: $(SHOW).dvi
	( ( uname -n | grep mit.edu > /dev/null && \
	    ( xdvi -expert -keep -s 7 $(SHOW).dvi || true ) )  || \
	    xdvi -expert -keep -s 3 $(SHOW).dvi    ) &

gv: ps
	gv -w $(SHOW).ps &

wps: ps
	@echo watching \'$(SHOW).tex\' to run \'$(MAKE) ps\'
	@ruby -e "file = '$(SHOW).tex'" \
	      -e "command = '$(MAKE) ps'" \
	      -e "lm = File.mtime file" \
	      -e "while true do" \
	      -e " m = File.mtime file" \
	      -e " system command unless m==lm" \
	      -e " lm = m" \
	      -e " sleep 0.25" \
	      -e "end"

post: pdf
	scp $(NOTE:%=%.pdf) $(PDF) shiner:www/thesis

clean:
	rm -rf $(NOTE:%=%.aux) $(NOTE:%=%.bbl) $(NOTE:%=%.blg)
	rm -rf $(NOTE:%=%.log) $(NOTE:%=%.toc) $(NOTE:%=%.dvi)

clobber: clean
	rm -rf $(NOTE:%=%.ps) $(NOTE:%=%.pdf) $(PDF)
