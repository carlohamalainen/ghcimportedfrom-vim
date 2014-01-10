" Return the current haskell identifier
function! ghcimportedfrom#getHaskellIdentifier() "{{{
  let c = col ('.')-1
  let l = line('.')
  let ll = getline(l)
  let ll1 = strpart(ll,0,c)
  let ll1 = matchstr(ll1,"[a-zA-Z0-9_'.]*$")
  let ll2 = strpart(ll,c,strlen(ll)-c+1)
  let ll2 = matchstr(ll2,"^[a-zA-Z0-9_'.]*")
  return ll1.ll2
endfunction "}}}

function! ghcimportedfrom#get_doc_url(path, module, fexp, line, col) "{{{
  " Call ghc-imported-from to get the haddock url, if possible.
  " FIXME do we need add_autogen_dir when building the ghc-imported-from command?
  " FIXME We need to check for b:ghcmod_ghc_options and g:ghcmod_ghc_options
  " and append the arguments to ghc-imported-from. Do this once GHC options
  " parsing is fixed in ghc-imported-from.

  let l:cmd = ['ghc-imported-from', a:path, a:module, a:fexp, a:line, a:col]
  let l:output = s:system(l:cmd)
  let l:lines = split(l:output, '\n')
  let l:lastline = l:lines[-1]

  if l:lastline =~ "^SUCCESS.*"
    return split(l:lastline, ' ')[1]
  endif
  " FIXME if an error, tell the use something.
endfunction "}}}

function! ghcimportedfrom#detect_module() "{{{
  let l:regex = '^\C>\=\s*module\s\+\zs[A-Za-z0-9.]\+'
  for l:lineno in range(1, line('$'))
    let l:line = getline(l:lineno)
    let l:pos = match(l:line, l:regex)
    if l:pos != -1
      let l:synname = synIDattr(synID(l:lineno, l:pos+1, 0), 'name')
      if l:synname !~# 'Comment'
        return matchstr(l:line, l:regex)
      endif
    endif
    let l:lineno += 1
  endfor
  return 'Main'
endfunction "}}}

function! s:system(...) "{{{
  lcd `=ghcimportedfrom#basedir()`
  let l:ret = call('vimproc#system', a:000)
  lcd -
  return l:ret
endfunction "}}}

function! s:plineopen2(...) "{{{
  lcd `=ghcimportedfrom#basedir()`
  let l:ret = call('vimproc#plineopen2', a:000)
  lcd -
  return l:ret
endfunction "}}}

function! ghcimportedfrom#basedir() "{{{
  let l:use_basedir = get(g:, 'ghcimportedfrom_use_basedir', '')
  if empty(l:use_basedir)
    return s:find_basedir()
  else
    return l:use_basedir
  endif
endfunction "}}}

function! s:find_basedir() "{{{
  " search Cabal file
  if !exists('b:ghcimportedfrom_basedir')
    let l:ghcimportedfrom_basedir = expand('%:p:h')
    let l:dir = l:ghcimportedfrom_basedir
    for _ in range(6)
      if !empty(glob(l:dir . '/*.cabal', 0))
        let l:ghcimportedfrom_basedir = l:dir
        break
      endif
      let l:dir = fnamemodify(l:dir, ':h')
    endfor
    let b:ghcimportedfrom_basedir = l:ghcimportedfrom_basedir
  endif
  return b:ghcimportedfrom_basedir
endfunction "}}}

function! ghcimportedfrom#version() "{{{
  return [1, 0, 0]
endfunction "}}}

" vim: set ts=2 sw=2 et fdm=marker:
