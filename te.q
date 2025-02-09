#!/Users/dh/q/m64/q
\l curse.q
\l fun.q
k)align:{{(|/#:''x)$/:x}(,$!x),$[#*r:.Q.s2'. x:.Q.sw@+x;+r;()]}
rend:{[t;cr;cc]xs:-1_0,(+\)1+count each t 0; raze til[count t]rend1[t;xs;cr;cc]/:\:til count t 0}
bor:{0b sv (|/)0b vs/:x,y} ; lg: {x -3!y; y}neg[hopen `:/tmp/te.log]
rend1:{[t;xs;cr;cc;r;c] a:$[0=r;A`A_UNDERLINE;0]; a:bor[a;$[cr=r-1; A`A_REVERSE;0]]; a:bor[a; $[c=cc; bor[color_pair 15; A`A_BOLD];0]]; (r;xs c;t[r;c];a)}
onKey:{[cnt] yx::getmaxyx[]; .kf[`$"c"$keyname$[0=cnt;0;getch[]]][] }
display:{[x]if[0=count st; :0];erase[]; s:st 0 ;rows:rend[align (yx[0]-2) sublist s[`r0]_ s`t;s[`cr]-s`r0;s`cc];{addstr[x 0;x 1;x 2;x 3]}each rows ;refresh[];1}
cnt:0; .Q.trp[{while[display onKey cnt; cnt+:1]};(); {fini stdscr; show x; -1@.Q.sbt y;}] 
fini stdscr
/
[x] nav: page up/down,  
[ ] column selector
[ ] rename
[ ] move to c = 10, * next row with current cell value 
[x] type convert
[ ] .j.k
[ ] open csv

row
[ ] filter
[ ] delete

table 
[ ] dup/drop/swap 
[ ] join, diff 
[ ] gnuplot.
[ ] description. 
[ ] status. memory, current row, col, * main
  master

