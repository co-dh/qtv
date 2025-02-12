\l p.q
{x set' .p.import each x:`builtins`curses;}[]
import:{y set x[hsym y;<]}
builtins import/:`getattr`dir;
curses import/:`color_pair`has_colors`use_default_colors`init_pair`echo`noecho`cbreak`nocbreak`endwin`start_color`curs_set`initscr`keyname;
init:{stdscr:.p.wrap initscr[];noecho[];cbreak[];start_color[];curs_set 0; 
    if[has_colors[];use_default_colors[]]; stdscr}
    
fini:{keypad 0;echo[];nocbreak[];endwin[]}
{(`$k) set' {k!getattr[curses;] each k:`${x where x like y,"_*"}[;x]dir(curses)} each k:("A";"KEY";"COLOR");}[]
stdscr:init[]; stdscr import/:`erase`refresh`getmaxyx`getch`getkey`keypad`addstr`getstr; keypad[1] /convert escape sequences to int
bor:{0b sv (|/)0b vs/:x,y} ;
init_pair[1; -1; 22]; init_pair[2;0;68] 
.cl.col: bor[color_pair 1; A`A_BOLD]; .cl.row: A`A_REVERSE; .cl.st: color_pair 2   
/ color schema


