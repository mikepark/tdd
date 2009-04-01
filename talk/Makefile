
.SUFFIXES:

.SUFFIXES: .tex .fig .dvi .pdf .eps .ps .nlo .nls

.PHONEY : default dvi ps pdf disp xpdf gv wps html all post bu ssh clean clobber

REPORT = tdd_talk tdd_handout

SHOW = tdd_talk

FIGS = 
EPSS = $(FIGS:%=%.eps)
PDFS = $(EPSS:%.eps=%.pdf)

$(REPORT:%=%.pdf): $(PDFS) $(REPORT:%=%.tex)
$(REPORT:%=%.ps): $(EPSS) $(REPORT:%=%.tex)

LATEX = env TEXINPUTS=.:elsarticle:packages: latex
PDFLATEX = env TEXINPUTS=.:elsarticle:packages: pdflatex
BIBTEX = env BSTINPUTS=.:elsarticle: bibtex

default: pdf

pdf: $(REPORT:%=%.pdf)

ps: $(REPORT:%=%.ps)

#mikepark_phd_thesis.pdf : mikepark_phd_thesis.nls

#mikepark_phd_thesis.nlo :
#	$(PDFLATEX) $*

.nlo.nls :
	makeindex -s nomencl.ist -o $*.nls $*.nlo

.tex.dvi:
	$(LATEX) $*
	grep 'There were undefined citations' $*.log > /dev/null && \
	   $(BIBTEX) $* && $(LATEX) $* || true
	grep 'No file' $*.log > /dev/null && $(LATEX) $* || true
	grep Rerun $*.log > /dev/null && $(LATEX) $* || true
	grep Rerun $*.log > /dev/null && $(LATEX) $* || true

.tex.pdf: 
	$(PDFLATEX) $*
	grep 'There were undefined citations' $*.log > /dev/null && \
	   $(BIBTEX) $* && $(PDFLATEX) $* || true
	grep 'No file' $*.log > /dev/null && $(PDFLATEX) $* || true
	grep Rerun $*.log > /dev/null && $(PDFLATEX) $* || true
	grep Rerun $*.log > /dev/null && $(PDFLATEX) $* || true

.pdf.ps:
	pdf2ps $*.pdf $*.ps

.eps.pdf:
	epstopdf $*.eps

.fig.eps:
	fig2dev -L eps $*.fig > $*.eps

xpdf: pdf
	xpdf -z page $(SHOW).pdf < /dev/null > /dev/null &

gv: ps
	gv -w $(SHOW).ps &

wps: ps
	@echo watching \'$(SHOW).tex\' to run \'$(MAKE) ps\'
	@ruby -e "files = '*.tex'" \
	      -e "command = '$(MAKE) ps'" \
	      -e "lm = Hash.new" \
	      -e "Dir[files].each do |file|" \
	      -e " lm[file] = File.mtime(file)" \
	      -e "end" \
	      -e "while true do" \
	      -e " run_now = false" \
	      -e " Dir[files].each do |file|" \
	      -e "  modified = File.mtime(file)" \
	      -e "  last_modified = lm[file]" \
	      -e "  if last_modified.nil? || (modified>last_modified)" \
	      -e "   lm[file] = modified" \
	      -e "   run_now = true" \
	      -e "  end" \
	      -e " end" \
	      -e " system(command) if run_now" \
	      -e " sleep 0.25" \
	      -e "end"

wpdf: pdf
	@echo watching \'$(SHOW).tex\' to run \'$(MAKE) pdf\'
	@ruby -e "files = '*.tex'" \
	      -e "command = '$(MAKE) pdf'" \
	      -e "lm = Hash.new" \
	      -e "Dir[files].each do |file|" \
	      -e " lm[file] = File.mtime(file)" \
	      -e "end" \
	      -e "while true do" \
	      -e " run_now = false" \
	      -e " Dir[files].each do |file|" \
	      -e "  modified = File.mtime(file)" \
	      -e "  last_modified = lm[file]" \
	      -e "  if last_modified.nil? || (modified>last_modified)" \
	      -e "   lm[file] = modified" \
	      -e "   run_now = true" \
	      -e "  end" \
	      -e " end" \
	      -e " system(command) if run_now" \
	      -e " sleep 0.25" \
	      -e "end"

bu:
	@echo `find . -name '*~'`
	@rm -f `find . -name '*~'`

clean:
	rm -rf $(REPORT:%=%.aux) $(REPORT:%=%.bbl) $(REPORT:%=%.blg)
	rm -rf $(REPORT:%=%.log) $(REPORT:%=%.toc) $(REPORT:%=%.dvi)
	rm -rf $(REPORT:%=%.lof) $(REPORT:%=%.lot)
	rm -rf $(REPORT:%=%.ind) $(REPORT:%=%.ilg) $(REPORT:%=%.nls)
	rm -rf $(REPORT:%=%.nlo) $(REPORT:%=%.out)
	rm -rf $(EPSS) $(PDFS)
	rm -rf version.tex version.aux
	rm -rf delta.tex
	rm -rf  $(PARTS:%=%.aux)

clobber: clean
	rm -rf $(REPORT:%=%.ps) $(REPORT:%=%.pdf)

