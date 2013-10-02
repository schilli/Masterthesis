DOCUMENT=masterthesis

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

clean:
	rm -f $(DOCUMENT).aux \
		  $(DOCUMENT).log \
		  $(DOCUMENT).nav \
		  $(DOCUMENT).out \
		  $(DOCUMENT).snm \
		  $(DOCUMENT).toc \
		  $(DOCUMENT).bbl \
		  $(DOCUMENT).blg
