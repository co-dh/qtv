#!/usr/bin/env python
import curses
import pdb
from pykx import q

def draw_table(stdscr):
    q('\\l te.q')
    
    # Get table structure from q
    headers = q('cols t').py()
    rows = q('t').py()
    
    # Setup curses
    curses.curs_set(0) # no blinking cursor

    curses.init_pair(1, curses.COLOR_CYAN, 0)
    curses.init_pair(2, curses.COLOR_YELLOW, 0)
    curses.init_pair(3, curses.COLOR_MAGENTA, 0)
    
    # Main loop
    while True:
        stdscr.erase()
        max_y, max_x = stdscr.getmaxyx()
        
        # Calculate column widths
        col_width = (max_x - 4) // len(headers)
        
        # Draw headers
        stdscr.addstr(0, 0, " " * max_x, curses.color_pair(1))
        x = 2
        for h in headers:
            header_text = str(h)[:col_width-2].ljust(col_width-2)
            stdscr.addstr(0, x, header_text, curses.color_pair(1))
            x += col_width
        
        # Draw rows
        for row_idx, row in enumerate(rows[:max_y-2], 1):
            x = 2
            for col in row:
                cell_content = str(col)[:col_width-2].ljust(col_width-2)
                stdscr.addstr(row_idx, x, cell_content)
                x += col_width
        
        # Status bar
        stdscr.addstr(max_y-1, 0, f"Press Q to quit | Columns: {len(headers)} | Rows: {len(rows)}", curses.A_REVERSE)
        stdscr.refresh()
        
        # Input handling
        key = stdscr.getch()
        if key in [ord('q'), ord('Q')]:
            break

if __name__ == '__main__':
    curses.wrapper(draw_table)
