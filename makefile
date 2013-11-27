DOCUMENT=masterthesis
PRESENTATION=mastertalk
BARCELONA=barcelonatalk
POSTER=masterposter

final: $(DOCUMENT).tex
	pdflatex $(DOCUMENT).tex
	bibtex   $(DOCUMENT).aux
	pdflatex $(DOCUMENT).tex
	pdflatex $(DOCUMENT).tex


draft: $(DOCUMENT).tex
	pdflatex "\def\isdraft{1} \input{$(DOCUMENT).tex}"
	bibtex   $(DOCUMENT).aux
	pdflatex "\def\isdraft{1} \input{$(DOCUMENT).tex}"
	pdflatex "\def\isdraft{1} \input{$(DOCUMENT).tex}"

black: $(DOCUMENT).tex
	pdflatex "\def\black{1} \input{$(DOCUMENT).tex}"
	bibtex   $(DOCUMENT).aux
	pdflatex "\def\black{1} \input{$(DOCUMENT).tex}"
	pdflatex "\def\black{1} \input{$(DOCUMENT).tex}" 

partial: $(DOCUMENT)_part.tex
	pdflatex $(DOCUMENT)_part.tex
	bibtex   $(DOCUMENT)_part.aux
	pdflatex $(DOCUMENT)_part.tex
	pdflatex $(DOCUMENT)_part.tex 

talk: $(PRESENTATION).tex
	pdflatex $(PRESENTATION).tex
	bibtex   $(PRESENTATION).aux
	pdflatex $(PRESENTATION).tex
	pdflatex $(PRESENTATION).tex  

barcelona: $(BARCELONA).tex
	pdflatex $(BARCELONA).tex
	bibtex   $(BARCELONA).aux
	pdflatex $(BARCELONA).tex
	pdflatex $(BARCELONA).tex   

poster: $(POSTER).tex
	pdflatex $(POSTER).tex
#	bibtex   $(POSTER).aux
#	pdflatex $(POSTER).tex
	pdflatex $(POSTER).tex    

clean:
	rm -f *run.xml *-blx.bib\
	      $(DOCUMENT).aux \
		  $(DOCUMENT).log \
		  $(DOCUMENT).nav \
		  $(DOCUMENT).out \
		  $(DOCUMENT).snm \
		  $(DOCUMENT).toc \
		  $(DOCUMENT).bbl \
		  $(DOCUMENT).blg \
		  $(DOCUMENT)_part.aux \
		  $(DOCUMENT)_part.log \
		  $(DOCUMENT)_part.nav \
		  $(DOCUMENT)_part.out \
		  $(DOCUMENT)_part.snm \
		  $(DOCUMENT)_part.toc \
		  $(DOCUMENT)_part.bbl \
		  $(DOCUMENT)_part.blg \
 		  $(PRESENTATION).aux \
		  $(PRESENTATION).log \
		  $(PRESENTATION).nav \
		  $(PRESENTATION).out \
		  $(PRESENTATION).snm \
		  $(PRESENTATION).toc \
		  $(PRESENTATION).bbl \
		  $(PRESENTATION).blg \
  		  $(BARCELONA).aux \
		  $(BARCELONA).log \
		  $(BARCELONA).nav \
		  $(BARCELONA).out \
		  $(BARCELONA).snm \
		  $(BARCELONA).toc \
		  $(BARCELONA).bbl \
		  $(BARCELONA).blg \
  		  $(POSTER).aux \
		  $(POSTER).log \
		  $(POSTER).nav \
		  $(POSTER).out \
		  $(POSTER).snm \
		  $(POSTER).toc \
		  $(POSTER).bbl \
		  $(POSTER).blg    
