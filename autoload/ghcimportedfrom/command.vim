function! s:buffer_path(force) "{{{
  let l:path = expand('%:p')
  if empty(l:path)
    call ghcimportedfrom#util#print_warning("current version of ghcimportedfrom.vim doesn't support running on an unnamed buffer.")
    return ''
  endif

  if &l:modified
    let l:msg = 'ghcimportedfrom.vim: the current buffer has been modified but not written'
    if a:force
      call ghcimportedfrom#util#print_warning(l:msg)
    else
      call ghcimportedfrom#util#print_error(l:msg)
      return ''
    endif
  endif

  return l:path
endfunction "}}}

function! ghcimportedfrom#command#opendoc(fexp, force) "{{{
  let l:path = s:buffer_path(a:force)
  if empty(l:path)
    return
  endif
  let l:fexp = a:fexp
  if empty(l:fexp)
    let l:fexp = ghcimportedfrom#getHaskellIdentifier()
  end

  let l:line = line('.')
  let l:col = col('.')

  let l:doc_url = ghcimportedfrom#get_doc_url(l:path, ghcimportedfrom#detect_module(), l:fexp, l:line, l:col)

  if l:doc_url =~ '^http' || l:doc_url =~ '^file'
    if exists('g:ghcimportedfrom_browser')
        execute 'silent !' . g:ghcimportedfrom_browser . ' ' . l:doc_url . ' >& /dev/null &'
        execute ':redraw!'
        " FIXME does not handle Linux/OSX/Windows cases.
    else
      if has("win32")
        execute 'silent !start cmd /c start ' . l:doc_url . ' &'
      endif

      if has("unix")
        if system('uname')=~'Darwin'
          " Redirect output to /dev/null? Untested!
          execute "silent !open " . l:doc_url
        else
          execute "silent !xdg-open " . l:doc_url . ' >& /dev/null'
        endif

        execute ':redraw!'
      endif
    endif
  else
    call ghcimportedfrom#util#print_error("ghcimportedfrom#get_doc_url: could not guess Haddock url for symbol: " . l:fexp . "\n" . l:doc_url)
  endif
endfunction "}}}

function! ghcimportedfrom#command#echo_doc_url(fexp, force) "{{{
  let l:path = s:buffer_path(a:force)
  if empty(l:path)
    return
  endif
  let l:fexp = a:fexp
  if empty(l:fexp)
    let l:fexp = ghcimportedfrom#getHaskellIdentifier()
  end

  let l:line = line('.')
  let l:col = col('.')

  let l:doc_url = ghcimportedfrom#get_doc_url(l:path, ghcimportedfrom#detect_module(), l:fexp, l:line, l:col)

  if l:doc_url =~ '^http' || l:doc_url =~ '^file'
    echo l:doc_url
  else
    call ghcimportedfrom#util#print_error("ghcimportedfrom#get_doc_url: could not guess Haddock url for symbol: " . l:fexp . "\n" . l:doc_url)
  endif
endfunction "}}}

" vim: set ts=2 sw=2 et fdm=marker:
