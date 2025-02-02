#!/Users/dh/q/m64/q
// te.q - Table data definition
t:([] 
  id:1+til 20;
  name:`Alice`Bob`Charlie`David`Eve`Frank`Grace`Hank`Ivy`Jack`Kara`Liam`Mia`Nora`Oscar`Paul`Quinn`Rose`Sam`Tina;
  department:20?`HR`IT`Sales`Engineering`Support;
  salary:20?50000.0+til 30000;
  years_of_service:20?til 15
 );

/give table t, return 2d array of string of same width at each column.
k)align:{{(|/#:''x)$/:x}(,$!x),$[#*r:.Q.s2'. x:.Q.sw@+x;+r;()]}

/highlight header, current row and current column
rend:{[x;cr;cc] 
    ; xs: -1_ 0,(+\)1+count each x 0
    ; raze til[count x]{[t;xs;cr;cc;r;c](r;xs c;t[r;c];0) }[x;xs;cr;cc]/:\:til count x 0
    }


\l pykx.q
\l te.p

.pykx.setdefault "raw"
Attr: .pykx.get[`getAttr; <][]
Key: .pykx.get[`getKey; <][]
rows: rend[15#align t; 2; 0]

.z.exit:{[x].pykx.get[`fini]stdscr}
stdscr: .pykx.get[`init][]
stdscr[`:erase][]`
addstr:stdscr[`:addstr;<]
{addstr[x 0;x 1; x 2];} each rows;
stdscr[`:refresh][]`

while["q"<>c:stdscr[`:getch][]`; 1+1] 
exit 0
/


/exit 0
/
What's the interface between render and kdb?
the render knows:
    r0: first row of t on screen,  0 indexed
    cr,cc: current row/col to highlight
    w,h: screen width/height

the q code need to return an array of [y,x,txt, attr] to be called by addstr
\
/
/r0: 1; cr:2; cc: 1; w: 50; h:10 
getCmd:{[r0;cr;cc;w;h]
   h sublist r0 _ t 


p)import curses
.pykx.qeval"dir(curses)"
ev: .pykx.qeval
Attr: ev "{x:getattr(curses,x) for x in dir(curses) if x.startswith('A_')}"
Key: ev "{x:getattr(curses,x) for x in dir(curses) if x.startswith('KEY_')}"
.pykx.get[`stdscr]    
nc: .pykx.import `curses
nc`:wrapper
