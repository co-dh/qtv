#!/Users/dh/q/m64/q
k)align:{{(|/#:''x)$/:x}(,$!x),$[#*r:.Q.s2'. x:.Q.sw@+x;+r;()]}
/highlight header, current row and current column
/x: [[str]] aligned table. cr,cc: current row/column
rend:{[x;cr;cc]xs: -1_ 0,(+\)1+count each x 0; raze til[count x]rend1[x;xs;cr;cc]/:\:til count x 0 }
rend1:{[t;xs;cr;cc;r;c]a:$[cr=r; Attr`A_REVERSE; c=cc; bor[colorPair 232; Attr`A_BOLD]; 0]; (r;xs c;t[r;c];a)}
bor:{0b sv (|/)0b vs/:x,y} /bitwise or
\l pykx.q
.pykx.setdefault "raw"
\l te.p
C: .pykx.import[`curses]
colorPair: C[`:color_pair;<]
Attr  : .pykx.get[`getAttr;<][];Key:  .pykx.get[`getKey;<][]
/{x set' .pykx.get x}`init`fini`
stdscr: .pykx.get[`init][]; .z.exit:{[x].pykx.get[`fini]stdscr}

addstr:stdscr[`:addstr;<];erase: stdscr[`:erase][];refresh:stdscr[`:refresh][];getmaxyx:stdscr[`:getmaxyx;<]
lg: neg hopen `:/tmp/log
onKey:{[c;yx]$[`KEY_DOWN=k:Key?c; cr::(yx[0]-1)&cr+1
              ;k=`KEY_UP; cr::0|cr-1 
              ;k=`KEY_LEFT; cc::0|cc-1
              ;k=`KEY_RIGHT; cc::(count[cols t]-1)&cc+1
              ];yx}
display:{[yx]erase`; rows: rend[yx[0] sublist align t; cr; cc]; {addstr[x 0;x 1; x 2; x 3];} each rows; refresh`}

t:([] 
  id:1+til 20;
  name:`Alice`Bob`Charlie`David`Eve`Frank`Grace`Hank`Ivy`Jack`Kara`Liam`Mia`Nora`Oscar`Paul`Quinn`Rose`Sam`Tina;
  department:20?`HR`IT`Sales`Engineering`Support;
  salary:20?50000.0+til 30000;
  years_of_service:20?til 15
 );
cr:0;cc:0
 
display getmaxyx[]    
while["q"<>c:stdscr[`:getch][]`;display onKey[c]getmaxyx[]] 
exit 0
/
What's the interface between render and kdb?
the render knows:
    r0: first row of t on screen,  0 indexed
    cr,cc: current row/col to highlight
    w,h: screen width/height

the q code need to return an array of [y,x,txt, attr] to be called by addstr
