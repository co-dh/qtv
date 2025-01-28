#!/usr/bin/env python
import curses
import polars as pl
from typing import List, Tuple, Optional

def load_full(file_path: str) -> pl.DataFrame:
    """Load entire DataFrame with type casting."""
    loader = pl.scan_parquet if file_path.endswith('.parquet') else pl.scan_csv
    return loader(file_path).collect().cast(pl.Utf8)

def load_chunk(source, start: int, n: int) -> pl.DataFrame:
    """Load slice from either file path or existing DataFrame."""
    if isinstance(source, pl.DataFrame):
        return source.slice(start, n)
    return pl.scan_parquet(source).slice(start, n).collect().cast(pl.Utf8) \
        if str(source).endswith('.parquet') else \
        pl.scan_csv(source).slice(start, n).collect().cast(pl.Utf8)

def display_table(file_path: str) -> None:
    """Interactive table viewer with sorting."""
    screen = curses.initscr()
    try:
        curses.noecho(), curses.cbreak(), screen.keypad(1), curses.curs_set(0)
        curses.start_color()
        curses.init_pair(1, curses.COLOR_CYAN, 0)
        curses.init_pair(2, curses.COLOR_YELLOW, 0)
        curses.init_pair(3, curses.COLOR_MAGENTA, 0)

        # Initial state
        data_source = file_path  # Can be DataFrame after sorting
        total = load_full(file_path).height
        headers, widths = None, None
        start_row, hr, hc = 0, 0, 0
        
        while True:
            # Load and prepare data
            max_y, max_x = screen.getmaxyx()
            df = load_chunk(data_source, start_row, max_y-1)
            
            if headers is None:  # Initial setup
                headers = df.columns
                widths = [max(len(h), *[len(r[i]) for r in df.rows()]) 
                        for i, h in enumerate(headers)]
            
            # Build display rows
            rows = [[h[:w].ljust(w) for h, w in zip(headers, widths)]] + \
                   [[c[:w].ljust(w) for c, w in zip(r, widths)] for r in df.rows()]
            
            # Render
            screen.clear()
            for y, row in enumerate(rows[:max_y-1]):
                x = 0
                for i, cell in enumerate(row):
                    attr = curses.color_pair(3) if (y == hr and i == hc) else \
                        curses.color_pair(1) if y == hr else \
                        curses.color_pair(2) if i == hc else 0
                    try: screen.addstr(y, x, cell[:max_x-x], attr)
                    except: pass
                    x += len(cell) + 1
            
            # Status
            status = f"Row {start_row+hr+1}/{total} Col {hc+1}/{len(widths)} [=sort Q=quit"
            screen.addstr(max_y-1, 0, status[:max_x], curses.A_REVERSE)
            screen.refresh()

            # Handle input
            k = screen.getch()
            if k == curses.KEY_UP: hr = max(0, hr-1)
            elif k == curses.KEY_DOWN:
                if hr < len(rows)-2: hr += 1
                elif start_row + len(rows)-1 < total: 
                    start_row += len(rows)-1
                    hr = 0
            elif k == curses.KEY_LEFT: hc = max(0, hc-1)
            elif k == curses.KEY_RIGHT: hc = min(len(widths)-1, hc+1)
            elif k == ord('['):
                # Sort by current column
                sorted_df = load_full(file_path).sort(headers[hc])
                data_source = sorted_df
                total = sorted_df.height
                headers = sorted_df.columns
                widths = [max(len(h), *[len(r[i]) for r in sorted_df.rows()]) 
                        for i, h in enumerate(headers)]
                start_row, hr = 0, 0
            elif k in (ord('q'), 27): break

    finally:
        curses.endwin()

if __name__ == '__main__':
    display_table('csv/newzea.parquet')
