let g:pathZerbyDicoPlugin = expand('<sfile>:p:h')

function! ZerbyRemoveDiacritics(word)
  let diacs = 'áâãàçéêíóôõüú'
  let repls = 'aaaaceeiooouu'
  let diacs .= toupper(diacs)
  let repls .= toupper(repls)
  return tr(a:word, diacs, repls)
endfunction

function! ZerbyDico()
    let result = 0
    let wordUnderCursor = expand("<cword>")
    if wordUnderCursor == ""
        echom "Aucun mot sélectionné."
        return 0
    endif
    let wordUnderCursor = ZerbyRemoveDiacritics(wordUnderCursor)
    let dictionary = readfile(g:pathZerbyDicoPlugin."/../dictionary/fr-utf8.csv")
    for lineDictionary in dictionary
        let listLineDictionary = split(lineDictionary, ",")
        let wordDictionary = join(listLineDictionary[0:0])
        let wordDictionary = wordDictionary[1:-2] 
        if  wordDictionary == wordUnderCursor
            let result = 1
            let defDictionary = join(listLineDictionary[1:])
            let defDictionary = defDictionary[1:-2] 
            let listDefDictionary = split(defDictionary,'\\n')
            for lineDefDictionary in listDefDictionary
                echom lineDefDictionary
            endfor 
        endif
    endfor
    if result == 0
        echom "Ce mot n'a pas été trouvé dans le dictionnaire"
    endif
endfunction
