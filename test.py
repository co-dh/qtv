import curses

def draw_table(data):
    if not data:
        return

    stdscr = curses.initscr()
    try:
        curses.noecho()
        curses.cbreak()
        stdscr.keypad(True)
        stdscr.clear()
        
        # Get terminal dimensions
        max_y, max_x = stdscr.getmaxyx()
        
        # Draw each row
        for y, row in enumerate(data):
            if y >= max_y - 1:  # Leave room for cursor
                break
                
            # Join columns with single space and truncate to screen width
            row_str = " ".join(str(cell) for cell in row)
            truncated = row_str[:max_x-1]  # Ensure we don't hit edge of screen
            
            try:
                stdscr.addstr(y, 0, truncated)
            except curses.error:
                pass  # Handle edge cases quietly
            
        stdscr.refresh()
        stdscr.getch()  # Wait for keypress before exiting
    
    finally:
        curses.endwin()

# Example usage with pre-aligned data
if __name__ == "__main__":
    pre_aligned_data = [
        ["Name   ", "Age ", "Country      "],
        ["Alice  ", "30  ", "United States"],
        ["Bob    ", "25  ", "Canada       "],
        ["Charlie", "45  ", "Mexico       "]
    ]
    draw_table(pre_aligned_data)
