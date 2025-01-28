import curses
import polars as pl
from typing import List, Tuple

def load_dataframe(file_path: str, max_rows: int) -> pl.DataFrame:
    """Load initial rows from CSV/Parquet, convert all cols to strings."""
    loader = pl.scan_parquet if file_path.endswith('.parquet') else pl.scan_csv
    return loader(file_path).fetch(max_rows).cast(pl.Utf8)

def calculate_column_widths(headers: List[str], rows: List[Tuple[str]]) -> List[int]:
    """Determine max width for each column including header."""
    return [
        max(len(headers[i]), *(len(row[i]) for row in rows))
        for i in range(len(headers))
    ]

def align_cells(
    headers: List[str], 
    rows: List[Tuple[str]], 
    widths: List[int]
) -> List[List[str]]:
    """Format each cell to fixed width, left-aligned."""
    header_row = [h[:w].ljust(w) for h, w in zip(headers, widths)]
    data_rows = [
        [cell[:w].ljust(w) for cell, w in zip(row, widths)] 
        for row in rows
    ]
    return [header_row] + data_rows

def render_display(
    screen: curses.window,
    data: List[List[str]],
    total_rows: int,
    highlight_row: int,
    highlight_col: int
) -> None:
    """Draw table with row/column highlighting."""
    max_y, max_x = screen.getmaxyx()
    screen.clear()
    
    # Initialize colors
    curses.init_pair(1, curses.COLOR_CYAN, curses.COLOR_BLACK)    # Row highlight
    curses.init_pair(2, curses.COLOR_YELLOW, curses.COLOR_BLACK)  # Column highlight
    curses.init_pair(3, curses.COLOR_MAGENTA, curses.COLOR_BLACK) # Intersection
    
    for y, row in enumerate(data[:max_y-1]):
        x = 0
        for col_idx, cell in enumerate(row):
            cell_width = len(cell)
            if x + cell_width > max_x:
                break
            
            # Determine highlight type
            is_hl_row = y == highlight_row
            is_hl_col = col_idx == highlight_col
            attr = 0
            
            if is_hl_row and is_hl_col:
                attr = curses.color_pair(3)
            elif is_hl_row:
                attr = curses.color_pair(1)
            elif is_hl_col:
                attr = curses.color_pair(2)
            
            try:
                screen.addstr(y, x, cell[:max_x-x], attr)
            except curses.error:
                pass
            x += cell_width + 1
    
    # Status bar
    status = f" {highlight_row+1}/{total_rows}Row {highlight_col+1}/{len(row)}Col "
    screen.addstr(max_y-1, 0, status[:max_x], curses.A_REVERSE)
    screen.refresh()

def display_table(file_path: str) -> None:
    """Interactive table viewer with highlighting."""
    screen = curses.initscr()
    try:
        curses.noecho()
        curses.cbreak()
        screen.keypad(True)
        curses.curs_set(0)
        curses.start_color()

        # Get total rows without loading entire file
        if file_path.endswith('.parquet'):
            total_rows = pl.scan_parquet(file_path).select(pl.count()).collect().item()
        else:
            total_rows = pl.scan_csv(file_path).select(pl.count()).collect().item()

        # Initial load
        max_y, _ = screen.getmaxyx()
        df = load_dataframe(file_path, max_rows=max_y-1)
        widths = calculate_column_widths(df.columns, df.rows())
        data = align_cells(df.columns, df.rows(), widths)
        
        hr, hc = 0, 0  # Highlight coordinates
        
        while True:
            render_display(screen, data, total_rows, hr, hc)
            key = screen.getch()
            
            # Navigation
            if key == curses.KEY_UP: hr = max(0, hr-1)
            elif key == curses.KEY_DOWN: hr = min(len(data)-1, hr+1)
            elif key == curses.KEY_LEFT: hc = max(0, hc-1)
            elif key == curses.KEY_RIGHT: hc = min(len(widths)-1, hc+1)
            elif key in (ord('q'), 27): break
            
    finally:
        curses.endwin()

if __name__ == '__main__':
    display_table('csv/newzea.parquet')
