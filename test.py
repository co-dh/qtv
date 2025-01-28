#!/usr/bin/env python
import curses
import polars as pl
from typing import List, Tuple

def load_chunk(file_path: str, start: int, n: int) -> pl.DataFrame:
    """Load chunk of data starting from `start` row."""
    loader = pl.scan_parquet if file_path.endswith('.parquet') else pl.scan_csv
    return loader(file_path).slice(start, n).collect().cast(pl.Utf8)

def display_table(file_path: str) -> None:
    """Interactive table viewer with dynamic loading."""
    screen = curses.initscr()
    try:
        curses.noecho(), curses.cbreak(), screen.keypad(1), curses.curs_set(0)
        curses.start_color()
        curses.init_pair(1, curses.COLOR_CYAN, 0)
        curses.init_pair(2, curses.COLOR_YELLOW, 0)
        curses.init_pair(3, curses.COLOR_MAGENTA, 0)

        # Get total rows
        if file_path.endswith('.parquet'):
            total = pl.scan_parquet(file_path).select(pl.count()).collect().item()
        else:
            total = pl.scan_csv(file_path).select(pl.count()).collect().item()

        # Initial state
        start_row = 0
        hr, hc = 0, 0  # highlight pos
        widths = None
        headers = None
        
        while True:
            # Load current chunk
            max_y, max_x = screen.getmaxyx()
            chunk_size = max_y - 1  # Leave room for status
            df = load_chunk(file_path, start_row, chunk_size)
            
            # Initialize headers and widths on first load
            if headers is None:
                headers = df.columns
                rows = df.rows()
                widths = [max(len(h), *(len(r[i]) for r in rows)) for i, h in enumerate(headers)]
            
            # Align data for display
            data = [[h[:w].ljust(w) for h, w in zip(headers, widths)]]
            data += [[c[:w].ljust(w) for c, w in zip(r, widths)] for r in df.rows()]
            
            # Render
            screen.clear()
            for y, row in enumerate(data[:max_y-1]):
                x = 0
                for i, cell in enumerate(row):
                    attr = 0
                    if y == hr and i == hc: attr = curses.color_pair(3)
                    elif y == hr: attr = curses.color_pair(1)
                    elif i == hc: attr = curses.color_pair(2)
                    
                    try: screen.addstr(y, x, cell[:max_x-x], attr)
                    except: pass
                    x += len(cell) + 1

            # Status bar
            status = f" Row: {start_row+hr+1}/{total} Col: {hc+1}/{len(widths)} "
            screen.addstr(max_y-1, 0, status[:max_x], curses.A_REVERSE)
            screen.refresh()

            # Handle input
            k = screen.getch()
            if k == curses.KEY_UP and hr > 0: hr -= 1
            elif k == curses.KEY_DOWN:
                if hr < len(data)-2:  # Within current chunk
                    hr += 1
                elif start_row + len(data)-1 < total:  # Load next chunk
                    start_row += len(data)-1
                    hr = 0
            elif k == curses.KEY_LEFT and hc > 0: hc -= 1
            elif k == curses.KEY_RIGHT and hc < len(widths)-1: hc += 1
            elif k in (ord('q'), 27): break

    finally:
        curses.endwin()

if __name__ == '__main__':
    display_table('csv/newzea.parquet')
