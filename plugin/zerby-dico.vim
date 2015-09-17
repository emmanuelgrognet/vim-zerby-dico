let g:pathZerbyDicoPlugin = expand('<sfile>:p:h')

function! ZerbyRemoveDiacritics(word)
  let diacs = 'áàâäãåçéèêëíìîïñóòôöõúùûüýÿ'
  let repls = 'aaaaaaceeeeiiiinooooouuuuyy'
  let diacs .= toupper(diacs)
  let repls .= toupper(repls)
  return tr(a:word, diacs, repls)
endfunction

function! ZerbyDico()
    let result = 0
    let resultThesaurus = 0
    let wordUnderCursor = expand("<cword>")
    if wordUnderCursor == ""
        echom "Aucun mot sélectionné."
        return 0
    endif
    let wordUnderCursor = ZerbyRemoveDiacritics(wordUnderCursor)
    let dictionary = readfile(g:pathZerbyDicoPlugin."/../dictionary/fr-utf8.csv")
    let thesaurus = readfile(g:pathZerbyDicoPlugin."/../dictionary/thesaurus_fr.csv")
    for lineDictionary in dictionary
        let listLineDictionary = split(lineDictionary, ",")
        let wordDictionary = join(listLineDictionary[0:0])
        let wordDictionary = wordDictionary[1:-2] 
        if  ZerbyRemoveDiacritics(wordDictionary) == wordUnderCursor
            let result = 1
            let defDictionary = join(listLineDictionary[1:])
            let defDictionary = defDictionary[1:-2] 
            let listDefDictionary = split(defDictionary,'\\n')
            for lineDefDictionary in listDefDictionary
                echom lineDefDictionary
            endfor 
        endif
    endfor
    echom " "
    let thesaurusFinal = []
    for lineThesaurus in thesaurus
        let listLineThesaurus = split(lineThesaurus, ";")
        let wordThesaurus = join(listLineThesaurus[1:1])
        if ZerbyRemoveDiacritics(wordThesaurus) == wordUnderCursor
            call add(thesaurusFinal, join(listLineThesaurus[2:]))
            let result = 1
            let resultThesaurus = 1
        endif
    endfor
    if resultThesaurus == 1
        let stringThesaurusFinal = ""
        let i = 0
        let wordsListThesaurusFinal = []
        for wordsThesaurus in thesaurusFinal
            let wordsListThesaurus = split(wordsThesaurus, ",")
            for wordThesaurus in wordsListThesaurus
                let i = i + 1
                call add(wordsListThesaurusFinal, wordThesaurus)
                let stringThesaurusFinal = stringThesaurusFinal.i.")".wordThesaurus." "
            endfor
        endfor
        echom "Synonyme(s) : ".stringThesaurusFinal
    endif
    let replaceWithWordThesaurus = input("Taper le chiffre du synonyme pour remplacer ou valider pour quitter : ")
        if replaceWithWordThesaurus != "" && replaceWithWordThesaurus > 0 && replaceWithWordThesaurus <= i 
        :exe 'normal! "_ciw'.join(wordsListThesaurusFinal[replaceWithWordThesaurus-1 : replaceWithWordThesaurus-1])
    endif
    if result == 0
        echo "Ce mot n'a pas été trouvé dans le dictionnaire"
    endif
endfunction
