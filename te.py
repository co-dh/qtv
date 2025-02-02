#!/usr/bin/env python
import curses
from pykx import q
q('\\l te.q')
q('setAttr', {x:getattr(curses,x) for x in dir(curses) if x.startswith('A_')})
q('setKey', {x:getattr(curses,x) for x in dir(curses) if x.startswith('KEY_')})

def draw_table(stdscr):
    # Setup curses
    curses.curs_set(0) # no blinking cursor

    curses.init_pair(1, curses.COLOR_CYAN, 0)
    curses.init_pair(2, curses.COLOR_YELLOW, 0)
    curses.init_pair(3, curses.COLOR_MAGENTA, 0)
    
    # Main loop
    while True:
        stdscr.erase()
        rows = q('rend[15#align t;2;0]').py()
        
        # Draw headers
        for a in rows:
            stdscr.addstr(a[0],a[1],a[2])
        
        max_y, max_x = stdscr.getmaxyx()
        # Status bar
        stdscr.addstr(max_y-1, 0, f"Press Q to quit | Columns: {len(rows[0])} | Rows: {len(rows)}", curses.A_REVERSE)
        stdscr.refresh()
        
        # Input handling
        key = stdscr.getch()
        if key in [ord('q'), ord('Q')]:
            break

if __name__ == '__main__':
    curses.wrapper(draw_table)
