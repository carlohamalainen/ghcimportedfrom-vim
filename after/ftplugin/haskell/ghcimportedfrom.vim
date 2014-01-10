if exists('b:did_ftplugin_ghcimportedfrom') && b:did_ftplugin_ghcimportedfrom
  finish
endif
let b:did_ftplugin_ghcimportedfrom = 1

if !exists('s:has_ghc_imported_from')
  let s:has_ghc_imported_from = 0

  if !executable('ghc-imported-from')
    call ghcimportedfrom#util#print_error('ghcimportedfrom: ghc-imported-from is not executable!')
    finish
  endif

  let s:has_ghc_imported_from = 1
endif

if !s:has_ghc_imported_from
  finish
endif

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' | '
else
  let b:undo_ftplugin = ''
endif

command! -buffer -nargs=? -bang GhcImportedFromOpenHaddock  call ghcimportedfrom#command#opendoc(<q-args>, <bang>0)
command! -buffer -nargs=? -bang GhcImportedFromEchoUrl      call ghcimportedfrom#command#echo_doc_url(<q-args>, <bang>0)
let b:undo_ftplugin .= join(map([
      \ 'GhcImportedFromOpenHaddock',
      \ 'GhcImportedFromEchoUrl',
      \ ], '"delcommand " . v:val'), ' | ')
let b:undo_ftplugin .= ' | unlet b:did_ftplugin_ghcimportedfrom'

" Ensure syntax highlighting for ghcimportedfrom#detect_module()
syntax sync fromstart

" vim: set ts=2 sw=2 et fdm=marker:
