#!/Users/dh/q/m64/q
\l curse.q
\l fun.q
k)align:{{(|/#:''x)$/:x}(,$!x),$[#*r:.Q.s2'. x:.Q.sw@+x;+r;()]}
rend:{[t;cr;cc]xs:-1_0,(+\)1+count each t 0; raze til[count t]rend1[t;xs;cr;cc]/:\:til count t 0}
lg: {x -3!y; y}neg[hopen `:/tmp/te.log]
rend1:{[t;xs;cr;cc;r;c] a:$[0=r;A`A_UNDERLINE;0]; a:bor[a;$[cr=r-1; .cl.row;0]]; a:bor[a; $[c=cc;.cl.col;0]]; (r;xs c;t[r;c];a)}
onKey:{[cnt] yx::getmaxyx[]; .kf[kn::`$"c"$$[0=cnt;"";keyname getch[]]][]; kn}
Addstr:{[y;x;s;a] if[(y>=yx[0]) or (yx[1]<=x+count s); :()]; .[addstr;(y;x;s;a);{[y;x;e]lg(y;x;e)}[y;x]]} 
sb:{s:neg[-1+yx 1]$string[kn], " ",string[R[]],"/", string[CT[]];  Addstr[yx[0]-1; 0; s; .cl.st]}
display:{[x]if[(kn=`Q) or 0=count st;:0];erase[];s:st 0;(Addstr .)each rend[align s[`r0]_ (s[`r0]+yx[0]-2)sublist s`t;s[`cr]-s`r0;s`cc];sb[];refresh[];1}
.Q.trp[{cnt:0; while[display onKey cnt; cnt+:1]};(); {fini stdscr; show x; -1@.Q.sbt y;}] 
fini stdscr

/
[ ] Forth. interpreter apply f on current element of stack
[ ] separate render layer 
[x] nav: page up/down,  G, g
[?] column selector
[X] ^ rename column
[X] * search current cell
[X] / search, N, n 
[ ] / search string, pattern 
[x] type convert
[ ] .j.k
[ ] pad
row
    [ ] esc in input
    [ ] filter expression 
    [ ] delete
table 
    [ ] pipe sql
    [^] dup/swap 
    [ ] keyed table
    [ ] join, diff 
    [ ] gnuplot.
    [ ] description. 
    [.] status. memory, current row, col, * 
    [ ] open file
    [X] meta table
    [ ] table id 
    [ ] enter on Frequency 
[ ] dir sheet

