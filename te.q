#!/Users/dh/q/m64/q
rel:{` sv first[` vs hsym`$get[x]6],y}
{system "l ",1_string rel[{}]x} each `curse.q`fun.q
k)align:{{(|/#:''x)$/:x}(,$!x),$[#*r:.Q.s2'. x:.Q.sw@+x;+r;()]}
k)kc:{$[98h=@x;();!+!x]} //key column count
rend:{[kc;t;cr;cc] /render string table t at current row and column
    ; xs:-1_0,(+\)1+count each t 0 //x of each column
    ; if[xs[cc+1]>yx 1; shift:xs first where xs>xs[cc+1]-yx 1; xs-: shift] 
    ; raze til[count t]rend1[kc;t;xs;cr;cc]/:\:til count t 0}
lg: {x -3!(y;z); z}neg[hopen `:/tmp/te.log]
rend1:{[kc;t;xs;cr;cc;r;c] //render string table t[r][c] with highlighted (cr,cc). xs: x of each column. kc: count of key column
    ; a:$[0=r;A`A_UNDERLINE;0] //highlight header
    ; a:bor[a;$[cr=r-1; .cl.row;0]] //highlight current row
    ; a:bor[a;$[c=cc;.cl.col;0]]
    ; cell: t[r;c],$[c=kc-1;"|";""] //add | after keyed columns
    ; (r;xs c;cell;a)}
onKey:{[cnt] yx::getmaxyx[]; .kf[kn::`$"c"$$[0=cnt;"";keyname getch[]]][]; kn}
Addstr:{[y;x;s;a] if[(y>=yx[0]) or (yx[1]<=x+count s); :()]; .[addstr;(y;x;s;a);{[y;x;e]lg(y;x;e)}[y;x]]} 
msg:""; commify:{","sv reverse 3 cut reverse string x}
sb:{s:neg[-10+yx 1]$msg,("/"sv -3 sublist "/"vs fn),string[kn], " ",string[R[]],"/",commify CT`; Addstr[yx[0]-1;0;s;.cl.st]; refresh[]}
display:{[x]if[(kn=`Q)or 0=count st;:0];erase[]; s:st 0
    ;(Addstr .)each rend[count kc s`t;align s[`r0]_(s[`r0]+yx[0]-2)sublist 0!s`t;s[`cr]-s`r0;s`cc];sb[];refresh[];1}
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
[ ] nyse, t as symbol, date as drop down
[ ] horizontal scroll
row
    [ ] esc in input
    [ ] filter expression 
    [ ] delete
table 
    [ ] pipe sql
    [^] dup/swap 
    [x] keyed table, display, add key, remove key.
    [ ] sort by 2 columns
    [ ] group by with keyed table
    [ ] join, diff 
    [ ] gnuplot.
    [ ] description. 
    [.] status. memory, current row, col, * 
    [ ] open file
    [X] meta table
    [ ] table id 
    [ ] enter on Frequency 
[ ] dir sheet

