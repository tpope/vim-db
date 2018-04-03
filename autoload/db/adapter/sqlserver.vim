if exists('g:autoloaded_db_adapter_sqlserver')
  finish
endif
let g:autoloaded_db_adapter_sqlserver = 1

function! db#adapter#sqlserver#canonicalize(url) abort
  let url = a:url
  if url =~# ';.*=' && url !~# '?'
    let url = tr(substitute(substitute(url, ';', '?', ''), ';$', '', ''), ';', '&')
  endif
  return db#url#absorb_params(url, {
        \ 'user': 'user',
        \ 'userName': 'user',
        \ 'password': 'password',
        \ 'server': 'host',
        \ 'serverName': 'host',
        \ 'port': 'port',
        \ 'portNumber': 'port',
        \ 'database': 'database',
        \ 'databaseName': 'database'})
endfunction

function! db#adapter#sqlserver#interactive(url) abort
  let url = db#url#parse(a:url)
  return 'sqlcmd' .
        \ ' -S ' . get(url, 'host', 'localhost') .
        \ (has_key(url, 'port') ? ',' . url.port : '') .
        \ (has_key(url, 'user') ? '' : ' -E') .
        \ db#url#as_args(url, '', '', '', '-U ', '-P ', '-d ')
endfunction

function! db#adapter#sqlserver#input_flag() abort
  return '-i '
endfunction
