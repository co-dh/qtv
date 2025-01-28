import curses

def draw_table(data):
    if not data:
        return

    stdscr = curses.initscr()
    try:
        curses.noecho()
        curses.cbreak()
        stdscr.keypad(True)
        curses.start_color()
        curses.curs_set(0)  # Hide cursor
        
        # VisiData-like color scheme
        curses.init_pair(1, curses.COLOR_CYAN, curses.COLOR_BLACK)    # Row highlight
        curses.init_pair(2, curses.COLOR_YELLOW, curses.COLOR_BLACK)  # Column highlight
        curses.init_pair(3, curses.COLOR_MAGENTA, curses.COLOR_BLACK) # Intersection
        
        highlight_row = 0
        highlight_col = 0
        max_row = len(data) - 1
        max_col = len(data[0]) - 1 if data else 0

        while True:
            stdscr.clear()
            max_y, max_x = stdscr.getmaxyx()
            
            # Draw table content
            for y, row in enumerate(data):
                if y >= max_y:
                    break
                    
                current_x = 0
                for col_idx, cell in enumerate(row):
                    if current_x >= max_x:
                        break
                    
                    # Determine highlighting
                    is_highlight_row = (y == highlight_row)
                    is_highlight_col = (col_idx == highlight_col)
                    color_pair = 0
                    
                    if is_highlight_row and is_highlight_col:
                        color_pair = 3
                    elif is_highlight_row:
                        color_pair = 1
                    elif is_highlight_col:
                        color_pair = 2
                    
                    cell_str = str(cell)
                    cell_len = len(cell_str)
                    remaining_width = max_x - current_x
                    
                    if remaining_width <= 0:
                        break
                        
                    display_cell = cell_str[:remaining_width]
                    attr = curses.color_pair(color_pair) if color_pair else curses.A_NORMAL
                    
                    try:
                        stdscr.addstr(y, current_x, display_cell, attr)
                    except curses.error:
                        pass
                    
                    current_x += cell_len
                    if current_x < max_x and col_idx != len(row)-1:
                        try:
                            stdscr.addstr(y, current_x, ' ')
                        except curses.error:
                            pass
                        current_x += 1

            # Draw status line
            status = f"Row: {highlight_row}/{max_row} Col: {highlight_col}/{max_col} (q to quit)"
            try:
                stdscr.addstr(max_y-1, 0, status[:max_x-1], curses.A_REVERSE)
            except curses.error:
                pass

            stdscr.refresh()
            
            # Handle keyboard input
            key = stdscr.getch()
            if key == curses.KEY_UP:
                highlight_row = max(0, highlight_row - 1)
            elif key == curses.KEY_DOWN:
                highlight_row = min(max_row, highlight_row + 1)
            elif key == curses.KEY_LEFT:
                highlight_col = max(0, highlight_col - 1)
            elif key == curses.KEY_RIGHT:
                highlight_col = min(max_col, highlight_col + 1)
            elif key in (ord('q'), ord('Q')):
                break
            elif key == curses.KEY_RESIZE:
                pass  # Will auto-redraw on next loop iteration
    
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
    draw_table(pre_aligned_data)
