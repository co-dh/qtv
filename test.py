import curses

def draw_table(data, highlight_row=None, highlight_col=None):
    if not data:
        return

    stdscr = curses.initscr()
    try:
        curses.noecho()
        curses.cbreak()
        stdscr.keypad(True)
        curses.start_color()
        
        # VisiData-like color scheme
        curses.init_pair(1, curses.COLOR_CYAN, curses.COLOR_BLACK)    # Cursor row
        curses.init_pair(2, curses.COLOR_YELLOW, curses.COLOR_BLACK)  # Cursor column
        curses.init_pair(3, curses.COLOR_MAGENTA, curses.COLOR_BLACK) # Both
        
        stdscr.clear()
        max_y, max_x = stdscr.getmaxyx()
        
        for y, row in enumerate(data):
            if y >= max_y:
                break
                
            current_x = 0
            for col_idx, cell in enumerate(row):
                if current_x >= max_x:
                    break
                
                # Determine highlighting
                is_highlight_row = (highlight_row is not None and y == highlight_row)
                is_highlight_col = (highlight_col is not None and col_idx == highlight_col)
                color_pair = 0
                
                if is_highlight_row and is_highlight_col:
                    color_pair = 3
                elif is_highlight_row:
                    color_pair = 1
                elif is_highlight_col:
                    color_pair = 2
                
                # Convert cell to string and calculate display length
                cell_str = str(cell)
                cell_len = len(cell_str)
                
                # Truncate cell if needed
                remaining_width = max_x - current_x
                if remaining_width <= 0:
                    break
                    
                display_cell = cell_str[:remaining_width]
                attr = curses.color_pair(color_pair) if color_pair else curses.A_NORMAL
                
                try:
                    stdscr.addstr(y, current_x, display_cell, attr)
                except curses.error:
                    pass
                
                # Move position and add space separator
                current_x += cell_len
                if current_x < max_x:
                    try:
                        stdscr.addstr(y, current_x, ' ')
                    except curses.error:
                        pass
                    current_x += 1

        stdscr.refresh()
        stdscr.getch()
    
    finally:
        curses.endwin()

# Example usage
if __name__ == "__main__":
    pre_aligned_data = [
        ["Name   ", "Age ", "Country      "],
        ["Alice  ", "30  ", "United States"],
        ["Bob    ", "25  ", "Canada       "],
        ["Charlie", "45  ", "Mexico       "]
    ]
    # Highlight row 1 (Alice's row) and column 2 (Country)
    draw_table(pre_aligned_data, highlight_row=1, highlight_col=2)
