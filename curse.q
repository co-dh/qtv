\l p.q
x set' .p.import each x:`builtins`curses;
import:{y set x[hsym y;<]}
builtins import/:`getattr`dir;
curses import/:`color_pair`has_colors`use_default_colors`init_pair`echo`noecho`cbreak`nocbreak`endwin`start_color`curs_set`initscr`keyname;
init:{stdscr:.p.wrap initscr[];noecho[];cbreak[];start_color[];curs_set 0; 
    if[has_colors[];use_default_colors[];{init_pair[x+1;x;-1]}each til 256]; stdscr}
fini:{keypad 0;echo[];nocbreak[];endwin[]}
(`$k) set' {k!getattr[curses;] each k:`${x where x like y,"_*"}[;x]dir(curses)} each k:("A";"KEY");
stdscr:init[]; stdscr import/:`erase`refresh`getmaxyx`getch`keypad`addstr; keypad[1] /convert escape sequences to int
