if exists('g:loaded_auto_cursorcolumn')
  finish
endif
let g:loaded_auto_cursorcolumn = 1

let s:save_cpo = &cpoptions
set cpoptions&vim

let g:auto_cursorcolumn_wait_ms = get(g:, 'auto_cursorcolumn_wait_ms', 1000)

augroup auto-cursorcolumn
  autocmd!
  autocmd CursorMoved,CursorMovedI * call auto_cursorcolumn#cursor_moved()
  autocmd WinEnter * call auto_cursorcolumn#win_enter()
  autocmd WinLeave * call auto_cursorcolumn#win_leave()
augroup END

let &cpoptions = s:save_cpo
unlet s:save_cpo
