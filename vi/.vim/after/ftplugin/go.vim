set shiftwidth=2 tabstop=2 softtabstop=2 noexpandtab autoindent smartindent
setlocal path=.,**,$GOROOT/src
setlocal include=^\\s*import\\s*[\"']\\zs[^\"']*
setlocal keywordprg=$HOME/profile.d/util/vimk.sh

