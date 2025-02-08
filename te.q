#!/Users/dh/q/m64/q
\l p.q
\l fun.q
x set' .p.import each x:`builtins`curses;
import:{y set x[hsym y;<]}
builtins import/:`getattr`dir;
curses import/:`color_pair`has_colors`use_default_colors`init_pair`echo`noecho`cbreak`nocbreak`endwin`start_color`curs_set`initscr;
Attr: k!getattr[curses;] each k:`${x where any x like/:("A_*";"KEY_*")}dir(curses)
init:{stdscr:.p.wrap initscr[];noecho[];cbreak[];start_color[];curs_set 0; 
    if[has_colors[];use_default_colors[];{init_pair[x+1;x;-1]}each til 256]; stdscr}
fini:{keypad 0;echo[];nocbreak[];endwin[]}
k)align:{{(|/#:''x)$/:x}(,$!x),$[#*r:.Q.s2'. x:.Q.sw@+x;+r;()]}
rend:{[t;cr;cc]xs:-1_0,(+\)1+count each t 0; raze til[count t]rendCell[t;xs;cr;cc]/:\:til count t 0}
rend1:{[t;xs;cr;cc;r;c] a:$[0=r;Attr`A_UNDERLINE;0]; a:bor[a;$[cr=r-1; Attr`A_REVERSE;0]]; a:bor[a; $[c=cc; bor[color_pair 15; Attr`A_BOLD];0]]; (r;xs c;t[r;c];a)}
rendCell: rend1
bor:{0b sv (|/)0b vs/:x,y} /bitwise or
lg: {x -3!y; y}neg[hopen `:/tmp/te.log]
ft:{.[`st;0,`t    ;x cc`]}
fc:{.[`st;0,`t,cc`;x]}
convert:{c: "c"$getch[]; if[lower[c] in .Q.t; fc[$[c;]]]}
onKey:{[cnt] /return 0 to quit
    ; c:$[0=cnt;0;getch[]]; yx::getmaxyx[]; s:st[0];k:Attr?c
    ; $[k=`KEY_DOWN;UpDown[1] ;k=`KEY_UP;UpDown[-1]
       ;c=534;UpDown yx[0]-2  ;c=575;UpDown neg yx[0]-2
       ;k=`KEY_LEFT;CC -1+s`cc;k=`KEY_RIGHT;CC 1+s`cc
       ;c="[";ft[xasc] ;c="]";ft[xdesc]
       ;c="d";if[1<count cols s`t; ft delcol cc[]; CC s`cc]
       ;c="F"; Freq[s] ;c="q"; :Pop[s]
       ;c="$"; convert[]
      ]
    ; 1  
    }
cc:{s:st 0; cols[s`t]s`cc}; CC:{.[`st;0,`cc;:;(count[cols st[0]`t]-1)&0|x]}
delcol:{![y;();0b;enlist x]}; Pop:{st::1_st;count st}
CT:{count T[]}
R:{$[null x; st[0;`cr]; [.[`st;0,`cr;:;n:(CT[]-1)&0|x]; lg n]]} /getter and setter of current row
R0:{$[null x; st[0;`r0]; .[`st;0,`r0;:; 0|(CT[]-yx[0]-2)&x]]}
/(1+cr-r0)=sreen y in [1, y-2] => cr-r0 in [0,y-3]
/r0: index of first row in t that displayed on screen. in [0; CT[]
UpDown:{mr:yx[0]-3; r:R x+R`; $[0>s:r-r0:R0[];R0 r0+s; s>mr;R0 r0+s-mr]} /mr: max index of rows.
display:{[x]; /lg (`display;`x;x)
    ;if[x=0; :x] ;erase[] ; s:st 0
    ;rows:rend[align (yx[0]-2) sublist s[`r0]_ s`t;s[`cr]-s`r0;s`cc]
    ;{addstr[x 0;x 1;x 2;x 3]}each rows ;refresh[];1}

/t: flip (`$string[til 16])!flip 16 16#til 256
/rendColor:{[t;xs;cr;cc;r;c] (r; xs c;t[r;c]; color_pair c+r*16)}
/rendCell: rendColor

/t: update I:i from("SSIJJ"; enlist csv)0:`:csv/1000.csv
t: update I:i from("*****"; enlist csv)0:`:csv/1000.csv
/ the render state of the table t:  cr/cc, r0: first row to display. multiple render states formed a stack
st:enlist `r0`cr`cc`type`t!(0;0;0;`;t)
T:{st[0]`t}

stdscr:init[]
stdscr import/:`erase`refresh`getmaxyx`getch`keypad`addstr;
keypad[1] /convert escape sequences to int
cnt:0
.Q.trp[{while[display onKey cnt; cnt+:1]}; (); {fini stdscr; show x; -1@.Q.sbt y;}] 
fini stdscr
/
[ ] nav: page up/down,  
[ ] column selector
[ ] rename
[ ] move to c = 10, * next row with current cell value 
[ ] type convert
[ ] .j.k

row
[ ] filter
[ ] delete

table 
[ ] dup/drop/swap 
[ ] join, diff 
[ ] gnuplot.
[ ] description. 
[ ] status. memory, current row, col, 
