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

function! ghcimportedfrom#get_visual_selection()
  " Why is this not a built-in Vim script function?!
  " http://stackoverflow.com/a/6271254
  let [lnum1, col1] = getpos("'<")[1:2]
  let [lnum2, col2] = getpos("'>")[1:2]
  let lines = getline(lnum1, lnum2)
  let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
  let lines[0] = lines[0][col1 - 1:]
  return join(lines, "\n")
endfunction

function! ghcimportedfrom#get_doc_url(path, module, fexp, line, col) "{{{
  " Call ghc-imported-from to get the haddock url, if possible.

  let l:cmd = ['ghc-imported-from', 'haddock-url', a:path, a:module, a:fexp, a:line, a:col]

  " GHC options
  if exists('b:ghcimportedfrom_ghc_options')
    let l:opts = b:ghcimportedfrom_ghc_options
  else
    let l:opts = get(g:, 'ghcimportedfrom_ghc_options', [])
  endif
  if l:opts != []
    for l:opt in l:opts
      call extend(l:cmd, ['--ghc-options'])
      call extend(l:cmd, [l:opt])
    endfor
  endif

  " ghc-pkg options
  if exists('b:ghcimportedfrom_ghcpkg_options')
    let l:opts = b:ghcimportedfrom_ghcpkg_options
  else
    let l:opts = get(g:, 'ghcimportedfrom_ghcpkg_options', [])
  endif
  if l:opts != []
    for l:opt in l:opts
      call extend(l:cmd, ['--ghc-pkg-options'])
      call extend(l:cmd, [l:opt])
    endfor
  endif

  " Debugging:
  " echo l:cmd
  " return

  let l:output = s:system(l:cmd)
  let l:lines = split(l:output, '\n')
  let l:lastline = l:lines[-1]

  if l:lastline =~ "^SUCCESS.*"
    return split(l:lastline, ' ')[1]
  else
    return l:output
  endif
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
