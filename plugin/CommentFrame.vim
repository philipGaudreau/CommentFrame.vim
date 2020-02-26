"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~{{{"
"                                 CommentFrame!                                "
"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
"~~~~~~~~~~~~~~~~~~~~~~~~~~~~ by cometsong <benjamin at cometsong dot net> ~~~~~


"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
" This is a simple plugin to generate fancy-looking comments/section dividers  "
" with centered titles and append them at the current cursor position.         "
"                                                                              "
" Also CommentRight => line of comment (customizable for diff langs) with      "
"      string arg put on right end of line.                                    "
"                                                                              "
" To customize further, unmapping of default keysets can be done, plus         "
" creating any new combinations of frame types by using the CommentFrame       "
" Custom and CustomRight function in your vimrc.
"                                                                              "
"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}}}"

"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~{{{"
"   from: makesd/makecsd by Chase Venters <chase.venters@chaseventers.com>     "
"         http://www.vim.org/scripts/script.php?script_id=3253                 "
"                                                                              "
"                      Public Domain, same license as Vim.                     "
"        see: http://vimdoc.sourceforge.net/htmldoc/uganda.html#license        "
"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}}}"

"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
"                          CommentFrame function                            {{{"
"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
" Syntax: CommentFrame(comment char to start line,
"            comment char to end the line,
"            width of line,
"            character to fill space in frame border (e.g. '*', '-', '=', ' '),
"            character to fill space in title line,
"            number of spaces to leave around title string
"            title string in center of line)
function! s:CommentFrame(start_str, end_str, line_width, frame_fill, title_fill, spacing, titlestring)
    " check and mod arg vars
    let l:title_fill = s:CheckNotEmpty(' ', a:title_fill)
    let l:frame_fill = s:CheckNotEmpty(' ', a:frame_fill)

    " prepend/append spacing
    let l:titlestr = repeat(' ', a:spacing) . a:titlestring . repeat(' ', a:spacing)

  " combine and count
    let l:middle_length=a:line_width - len(a:start_str . a:end_str)
    let l:title_left_length=((l:middle_length / 2) - (len(l:titlestr) / 2))
    let l:title_left = repeat(l:title_fill, l:title_left_length)
	let l:title_right_length=l:middle_length - len(l:title_left) - len(l:titlestr)
    let l:title_right = repeat(l:title_fill, l:title_right_length)
  
  " build border lines
	let l:border=a:start_str . repeat(l:frame_fill, l:middle_length) . a:end_str
  " build title_line
	let l:title_line=a:start_str . l:title_left . l:titlestr . l:title_right . a:end_str

  " add comment lines to doc
	call append(line('.'), l:border)
	call append(line('.'), l:title_line)
	call append(line('.'), l:border)
endfunction
"}}}

"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
"                          CommentFrame function                            {{{"
"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
" Syntax: CommentGrid(
"            width: grid width. default 2,
"            height: grid height. default 2,
"            cellWidth: Number of characters for cell width. default 1,
"            cellHeight: Number of characters for cell height. default 1,
"            cellFillChar: character to fill cell with. Default space.,
"            commentCharStart: comment char to start line. default nothing,
"            commentCharEnd: comment char to end the line. default nothing)
"
" ┏━┯━┓
" ┃ │ ┃
" ┠─┼─┨
" ┃ │ ┃
" ┗━┷━┛
function! s:CommentGrid(...)
    let l:width            = get(a:, 1, 2)
    let l:height           = get(a:, 2, 2)
    let l:cellWidth        = get(a:, 3, 1)
    let l:cellHeight       = get(a:, 4, 1)
    let l:cellFillChar     = get(a:, 5, ' ')
    let l:commentCharStart = get(a:, 6, '')
    let l:commentCharEnd   = get(a:, 7, '')

    let l:BORDER_TOP_LEFT     = '┏'
    let l:BORDER_SPACE        = '━'
    let l:BORDER_SPLIT_DOWN   = '┯'
    let l:BORDER_TOP_RIGHT    = '┓'
    let l:BORDER_ROW          = '┃'
    let l:BORDER_BOTTOM_LEFT  = '┗'
    let l:BORDER_SPLIT_UP     = '┷'
    let l:BORDER_BOTTOM_RIGHT = '┛'
    let l:CELL_VERT_SPLIT     = '│'
    let l:CELL_HORZ_SPLIT     = '─'
    let l:CELL_SPLIT          = '┼'
    let l:CELL_VERT_SPLIT_TL  = '┨'
    let l:CELL_VERT_SPLIT_TR  = '┠'

    let l:halfCellWidth  = float2nr(ceil(l:cellWidth / 2.0))
    let l:halfCellHeight = float2nr(ceil(l:cellHeight / 2.0))

    let l:topBorder = s:DrawLine(l:width, l:cellWidth, l:BORDER_TOP_LEFT, l:BORDER_SPACE, l:BORDER_SPLIT_DOWN, l:BORDER_TOP_RIGHT)
    let l:bottomBorder = s:DrawLine(l:width, l:cellWidth, l:BORDER_BOTTOM_LEFT, l:BORDER_SPACE, l:BORDER_SPLIT_UP, l:BORDER_BOTTOM_RIGHT)
    let l:rowBorder = s:DrawLine(l:width, l:cellWidth, l:CELL_VERT_SPLIT_TR, l:CELL_HORZ_SPLIT, l:CELL_SPLIT, l:CELL_VERT_SPLIT_TL)
    let l:row = s:DrawLine(l:width, l:cellWidth, l:BORDER_ROW, l:cellFillChar, l:CELL_VERT_SPLIT, l:BORDER_ROW)

    let l:grid = [l:topBorder]
    let l:c = 0
    while l:c < l:height-1
        call add(l:grid, l:row)
        call add(l:grid, l:rowBorder)
        let l:c += 1
    endwhile
    call add(l:grid, l:row)
    call add(l:grid, l:bottomBorder)

    " add comment lines to doc
	call append(line('.'), l:grid)
endfunction
"}}}

function! s:DrawLine(width, cellWidth, leftBookEnd, fillChar, dividerChar, rightBookEnd)
    let l:line = a:leftBookEnd . repeat(a:fillChar, a:cellWidth)
    let l:c = 0
    while l:c < a:width-1
        let l:line .= a:dividerChar . repeat(a:fillChar, a:cellWidth)
        let l:c += 1
    endwhile
    let l:line .= a:rightBookEnd
    return l:line
endfunction

"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
"                          CommentBox function                              {{{"
"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
" Syntax: CommentBox(
"    comment_char:     first character of each line.
"    top_start_str:    top char to start line,
"    top_end_str:      top char to end the line,
"    line_width        width of line,
"    top_frame_fill:   top character to fill space in frame border (e.g. '*', '-', '=', ' '),
"    start_title_str:  start character start title line (e.g. '|'),
"    end_title_str:    end character end title line (e.g. '|'),
"    spacing:          number of spaces to leave around title string
"    bottom_start_str: bottom 
"    bottom_end_str:   
"    bottom_frame_fill:
"    titlestring:       title string in center of line)
function! s:CommentBox(comment_char, top_start_str, top_end_str, line_width, top_frame_fill, start_title_str, end_title_str, title_fill, spacing, bottom_start_str, bottom_end_str, bottom_frame_fill, titlestring)
  " check and mod arg vars
  let l:title_fill = s:CheckNotEmpty(' ', a:title_fill)
  let l:top_frame_fill = s:CheckNotEmpty(' ', a:top_frame_fill)
  let l:bottom_frame_fill = s:CheckNotEmpty(' ', a:bottom_frame_fill)

  " prepend/append spacing
  let l:titlestr = repeat(' ', a:spacing) . a:titlestring . repeat(' ', a:spacing)

  " combine and count
	let l:middle_length=a:line_width - len(a:top_start_str . a:top_end_str)
	let l:title_left_length=((l:middle_length / 2) - (len(l:titlestr) / 2))
  let l:title_left = repeat(l:title_fill, l:title_left_length)
	let l:title_right_length=l:middle_length - len(l:title_left) - len(l:titlestr)
  let l:title_right = repeat(l:title_fill, l:title_right_length)
  
  " build border lines
	let l:top_border=a:comment_char . a:top_start_str . repeat(l:top_frame_fill, l:middle_length) . a:top_end_str
	let l:bottom_border=a:comment_char . a:bottom_start_str . repeat(l:bottom_frame_fill, l:middle_length) . a:bottom_end_str
  " build title_line
	let l:title_line=a:comment_char . a:start_title_str . l:title_left . l:titlestr . l:title_right . a:end_title_str

  " add comment lines to doc
	call append(line('.'), l:bottom_border)
	call append(line('.'), l:title_line)
	call append(line('.'), l:top_border)
endfunction
"}}}

"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
"                          CommentRight function                            {{{"
"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
" Syntax: CommentRight(comment char to start line,
"            comment char to end the line,
"            width of line,
"            width of right end of line (after title),
"            character to fill space (e.g. '*', '-', '=', ' '),
"            number of spaces to leave around title string
"            title string on right side of line)
function! s:CommentRight(start_str, end_str, line_width, right_width, title_fill, spacing, titlestring)
  " check and mod arg vars
  let l:title_fill = s:CheckNotEmpty(' ', a:title_fill)

  " prepend/append spacing
  let l:titlestr = repeat(' ', a:spacing) . a:titlestring . repeat(' ', a:spacing)

  " combine and count
  let l:middle_length=a:line_width - len(a:start_str . a:end_str)
  let l:title_right_length=a:right_width
  let l:title_right = repeat(l:title_fill, l:title_right_length)
  let l:title_left_length=(l:middle_length - len(l:titlestr) - l:title_right_length)
  let l:title_left = repeat(l:title_fill, l:title_left_length)

  " build title_line
	let title_line=a:start_str . l:title_left . l:titlestr . l:title_right . a:end_str

  " add comment lines to doc
  call append(line('.'), l:title_line)
endfunction
"}}}

"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ CheckNotEmpty function   {{{ ~~~~~
function! s:CheckNotEmpty(default_val, arg_val)
  if a:arg_val != ''
    return a:arg_val
  else
    return a:default_val
  endif
endfunction
"}}}

"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ MapKeys function   {{{ ~~~~~
function! s:MapKeys(modes, keys, target)
  " Build up a map command like
  " 'inoremap <Leader>keys target'
  let s:map_start = 'noremap <Leader>'
  for mode in (a:modes == '') ? [''] : split(a:modes, '\zs')
    if mode == 'i'
      let s:target = '<C-C>' . a:target . ' a'
    else
      let s:target = a:target
    endif
    if strlen(a:keys)
      execute mode . s:map_start . a:keys  . ' ' . s:target
    endif
  endfor
endfunction
" usage:  call s:MapKeys('nvi', 'do', 'doStuff')
"}}}



"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
"                               General Use Setup                           {{{"
"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Custom Comment Functions {{{ ~~~~~
function! CommentFrame#Custom(start_str, end_str, line_width, 
                     \frame_fill, title_fill, numspaces, titlestring)
  call s:CommentFrame(a:start_str, a:end_str, a:line_width, 
                     \a:frame_fill, a:title_fill, a:numspaces, a:titlestring)
endfunction

function! CommentFrame#CustomBox(comment_char, top_start_str, top_end_str, line_width, 
            \top_frame_fill, start_title_str, end_title_str, title_fill, spacing, 
            \bottom_start_str, bottom_end_str, bottom_frame_fill, titlestring)
  call s:CommentBox(a:comment_char, a:top_start_str, a:top_end_str, a:line_width, 
            \a:top_frame_fill, a:start_title_str, a:end_title_str, a:title_fill, a:spacing, 
            \a:bottom_start_str, a:bottom_end_str, a:bottom_frame_fill, a:titlestring)
endfunction

function! CommentFrame#CustomGrid(...)
    call call('s:CommentGrid', a:000)
endfunction

function! CommentFrame#CustomRight(start_str, end_str, line_width,
                     \right_width, title_fill, numspaces, titlestring)
  call s:CommentRight(a:start_str, a:end_str, a:line_width, a:right_width, 
                     \a:title_fill, a:numspaces, a:titlestring)
endfunction

function! CommentFrame#MapKeys(modes, keys, target)
  call s:MapKeys(a:modes, a:keys, a:target)
endfunction
"}}}

"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Commands, Mappings of Custom Functions {{{ ~~~~~
command! -nargs=+ CommentFrameCustom :call CommentFrame#Custom(<args>)
call s:MapKeys("ni", "fcu", ":CommentFrameCustom '#','#',80,'=','-',3,''<Left>")

command! -nargs=+ CommentRightCustom :call CommentFrame#CustomRight(<args>)
call s:MapKeys("ni", "frc", ":CommentRightCustom '#','',80,5,'~',1,''<Left>")

"}}}

"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Languages, CommentFrame {{{ ~~~~~
command! -nargs=+ CommentFrameSlashes     : call CommentFrame#Custom('//', '//', 80, '*', ' ', 0, <args>)
call s:MapKeys('ni', 'fcs', ':CommentFrameSlashes ""<Left>')

command! -nargs=+ CommentFrameSlashStar   : call CommentFrame#Custom('/*', '*/', 80, '*', ' ', 0, <args>)
call s:MapKeys('ni', 'fcS', ':CommentFrameSlashStar ""<Left>')

command! -nargs=+ CommentFrameHashDash    : call CommentFrame#Custom('#', '#', 80, '-', ' ', 0, <args>)
call s:MapKeys('ni', 'fch', ':CommentFrameHashDash ""<Left>')

command! -nargs=+ CommentFrameHashEqual   : call CommentFrame#Custom('#', '#', 80, '=', '-', 5, <args>)
call s:MapKeys('ni', 'fcH', ':CommentFrameHashEqual ""<Left>')

command! -nargs=+ CommentFrameQuoteDash   : call CommentFrame#Custom('"', '"', 80, '-', ' ', 5, <args>)
call s:MapKeys('ni', 'fcq', ':CommentFrameQuoteDash ""<Left>')

command! -nargs=+ CommentFrameQuoteTilde  : call CommentFrame#Custom('"', '"', 80, '~', ' ', 5, <args>)
call s:MapKeys('ni', 'fcQ', ':CommentFrameQuoteTilde ""<Left>')
"}}}

"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Languages, CommentRight {{{ ~~~~~
command! -nargs=+ CommentRightHash      : call CommentFrame#CustomRight('#', '', 80, 5, '~', 1, <args>)
call s:MapKeys('ni', 'frh', ':CommentRightHash ""<Left>')

command! -nargs=+ CommentRightSlashes   : call CommentFrame#CustomRight('//', '', 80, 5, '~', 1, <args>)
call s:MapKeys('ni', 'frs', ':CommentRightSlashes ""<Left>')

command! -nargs=+ CommentRightSlashStar : call CommentFrame#CustomRight('/*', '*/', 80, 5, '~', 1, <args>)
call s:MapKeys('ni', 'frS', ':CommentRightSlashStar ""<Left>')

command! -nargs=+ CommentRightQuote     : call CommentFrame#CustomRight('"', '', 80, 5, '~', 1, <args>)
call s:MapKeys('ni', 'frq', ':CommentRightQuote ""<Left>')
"}}}

"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Languages, CommentBox {{{ ~~~~~
command! -nargs=+ CommentBoxBox         : call CommentFrame#CustomBox('//', '┍', '┑', 80, '━', '│', '│', ' ', 1, '└', '┘', '─', <args>)
call s:MapKeys('ni', 'fcb', ':CommentBoxBox ""<Left>')

command! -nargs=+ CommentGrid           : call CommentFrame#CustomGrid(<args>)
call s:MapKeys('ni', 'fcg', ':CommentGrid ""<Left>')
"}}}

"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Plugin Menu Creation {{{ ~~~~~
amenu .170.1 &Plugin.Comment&Frames.Frame\ &Custom<Tab>fcu          <Leader>fcu
amenu .170.1 &Plugin.Comment&Frames.Frame\ &HashDash<Tab>fch        <Leader>fch
amenu .170.1 &Plugin.Comment&Frames.Frame\ Hash&Equal<Tab>fcH       <Leader>fcH
amenu .170.1 &Plugin.Comment&Frames.Frame\ &Slashes<Tab>fcs         <Leader>fcs
amenu .170.1 &Plugin.Comment&Frames.Frame\ &Slash\ Star<Tab>fcs     <Leader>fcS
amenu .170.1 &Plugin.Comment&Frames.Frame\ &QuoteDash<Tab>fcq       <Leader>fcq
amenu .170.1 &Plugin.Comment&Frames.Frame\ Quote&Tilde<Tab>fcQ      <Leader>fcQ
amenu .170.1 &Plugin.Comment&Frames.-Rights- :
amenu .170.1 &Plugin.Comment&Frames.Right\ &Custom<Tab>frc          <Leader>frc
amenu .170.1 &Plugin.Comment&Frames.Right\ &Hash<Tab>frh            <Leader>frh
amenu .170.1 &Plugin.Comment&Frames.Right\ &Slashes<Tab>frs         <Leader>frs
amenu .170.1 &Plugin.Comment&Frames.Right\ &Slash\ Stars<Tab>frS    <Leader>frS
amenu .170.1 &Plugin.Comment&Frames.Right\ &Quote<Tab>frq           <Leader>frq
"}}}
"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}}}
