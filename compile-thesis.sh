#!/bin/bash
# A script to compile the PhD Thesis - Krishna Kumar 
# Distributed under GPLv2.0 License

#!/usr/bin/env bash
set -euo pipefail

MAIN="${1:-thesis.tex}"
ACTION="${2:-build}"

cd "$(dirname "$0")"

if [[ "$ACTION" == "clean" ]]; then
  latexmk -C "$MAIN"
  rm -f "${MAIN%.tex}.bbl" "${MAIN%.tex}.bcf" "${MAIN%.tex}.run.xml" || true
  echo "Cleaned."
  exit 0
fi

# Run pdflatex once to generate the .bcf file for biber
pdflatex -interaction=nonstopmode -synctex=1 "$MAIN"

# Run biber for references
biber "${MAIN%.tex}"

# Run pdflatex two more times to resolve references
pdflatex -interaction=nonstopmode -synctex=1 "$MAIN"
pdflatex -interaction=nonstopmode -synctex=1 "$MAIN"

echo "✅ Done! Output: ${MAIN%.tex}.pdf"




# OLD version below


#compile="compile";
#clean="clean";

#if test -z "$2"
#then
#if [ $1 = $clean ]; then
#	rm -f *~
#	rm -rf *.aux
#	rm -rf *.bbl
#	rm -rf *.fls
#	rm -rf *.ilg
#	rm -rf *.ind
#	rm -rf *.toc*
#	rm -rf *.lot*
#	rm -rf *.lof*
#	rm -rf *.log
#	rm -rf *.idx
#	rm -rf *.out*
#	rm -rf *.nlo
#	rm -rf *.nls
#	rm -rf $filename.pdf
#	rm -rf $filename.ps
#	rm -rf $filename.dvi
#	rm -rf *#* 
#	echo "Cleaning complete!"
#	exit
#else
#	echo "Shell script for compiling the PhD Thesis"
#	echo "Usage: sh ./compile-thesis.sh [OPTIONS] [filename]"
#	echo "[option]  compile: Compiles the PhD Thesis"
#	echo "[option]  clean: removes temporary files no filename required"
#	exit
#fi
#fi

#filename=$2;

#if [ $1 = $clean ]; then
#	echo "Cleaning please wait ..."
#	rm -f *~
#	rm -rf *.aux
#	rm -rf *.bbl
#	rm -rf *.blg
#	rm -rf *.d
#	rm -rf *.fls
#	rm -rf *.ilg
#	rm -rf *.ind
#	rm -rf *.toc*
#	rm -rf *.lot*
#	rm -rf *.lof*
#	rm -rf *.log
#	rm -rf *.idx
#	rm -rf *.out*
#	rm -rf *.nlo
#	rm -rf $filename.pdf
#	rm -rf $filename.dvi
#	rm -rf *#* 
#	echo "Cleaning complete!"
#	exit
##	echo "Compiling your PhD Thesis...please wait...!"
#	pdflatex -interaction=nonstopmode $filename.tex
#	bibtex $filename.aux 	
#	makeindex $filename.aux
#	makeindex $filename.idx
#	makeindex $filename.nlo -s nomencl.ist -o $filename.nls
#	pdflatex -interaction=nonstopmode $filename.tex
#	makeindex $filename.nlo -s nomencl.ist -o $filename.nls
#	pdflatex -interaction=nonstopmode $filename.tex
#	echo "Success!"
#	exit
#fi


#if test -z "$3"
#then
#	exit
#fi
