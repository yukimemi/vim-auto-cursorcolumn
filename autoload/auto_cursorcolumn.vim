" When CursorMoved,CursorMovedI occurs, it substitutes s:cursor into s:status.
" And when WinEnter, it substitutes s:window into s:status.
"
" NOTE: When you enter in a new window, WinEnter AND CursorMoved events occur
" some time. So cursor_moved() does nothing when s:status == s:window, that
" is, win_enter() has been called. When you move the cursor after that, it
" sets 'nocursorcolumn' at the first time.

let s:disabled = 0
let s:cursor = 1
let s:window = 2
let s:status = s:disabled
let s:timer_id = 0

function! auto_cursorcolumn#cursor_moved() abort
  if auto_cursorcolumn#is_disabled()
    return
  endif
  if s:status == s:window
    let s:status = s:cursor
    return
  endif
  call auto_cursorcolumn#timer_stop()
  call auto_cursorcolumn#timer_start()
  if s:status == s:cursor
    setlocal nocursorcolumn
    let s:status = s:disabled
  endif
endfunction

function! auto_cursorcolumn#win_enter() abort
  if auto_cursorcolumn#is_disabled()
    return
  endif
  setlocal cursorcolumn
  let s:status = s:window
  call auto_cursorcolumn#timer_stop()
endfunction

function! auto_cursorcolumn#win_leave() abort
  if auto_cursorcolumn#is_disabled()
    return
  endif
  setlocal nocursorcolumn
  call auto_cursorcolumn#timer_stop()
endfunction

function! auto_cursorcolumn#timer_start() abort
  let s:timer_id = timer_start(g:auto_cursorcolumn_wait_ms, 'auto_cursorcolumn#enable')
endfunction

function! auto_cursorcolumn#timer_stop() abort
  if s:timer_id
    call timer_stop(s:timer_id)
    let s:timer_id = 0
  endif
endfunction

function! auto_cursorcolumn#enable(timer_id) abort
  setlocal cursorcolumn
  let s:status = s:cursor
  let s:timer_id = 0
endfunction

function! auto_cursorcolumn#is_disabled() abort
  return &buftype ==# 'terminal' || get(b:, 'auto_cursorcolumn_disabled', 0)
endfunction
