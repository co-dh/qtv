#!/Users/dh/q/m64/q
rel:{` sv first[` vs hsym`$get[x]6],y}
{system "l ",1_string rel[{}]x} each `curse.q`fun.q
k)align:{{(|/#:''x)$/:x}(,$!x),$[#*r:.Q.s2'. x:.Q.sw@+x;+r;()]}
rend:{[t;cr;cc] /render string table t at current row and column
    ; xs:-1_0,(+\)1+count each t 0 //x of each column
    ; if[xs[cc+1]>yx 1; shift:xs first where xs>xs[cc+1]-yx 1; xs-: shift] 
    ; raze til[count t]rend1[t;xs;cr;cc]/:\:til count t 0}
lg: {x -3!(y;z); z}neg[hopen `:/tmp/te.log]
rend1:{[t;xs;cr;cc;r;c] //render string table t[r][c] with highlighted (cr,cc). xs: x of each column. kc: count of key column
    ; a:$[0=r;A`A_UNDERLINE;0] //highlight header
    ; a:bor[a;$[cr=r-1; .cl.row;0]] //highlight current row
    ; a:bor[a;$[c=cc;.cl.col;0]]
    ; cell: t[r;c],$[c=kc-1;"|";""] //add | after keyed columns
    ; (r;xs c;cell;a)}
onKey:{[cnt] yx::getmaxyx[]; .kf[kn::`$"c"$$[0=cnt;"";keyname getch[]]][]; kn}
Addstr:{[y;x;s;a] if[(y>=yx[0]) or (yx[1]<=x+count s); :()]; .[addstr;(y;x;s;a);{[y;x;e]lg(y;x;e)}[y;x]]} 
msg:""; commify:{","sv reverse 3 cut reverse string x}
sb:{s:neg[-10+yx 1]$msg,("/"sv -3 sublist "/"vs fn),string[kn], " ",string[cr],"/",commify CT`; Addstr[yx[0]-1;0;s;.cl.st]; refresh[]}
display:{[x]if[(kn=`Q)or 0=count st;H 15; :0]
    ;erase[];(Addstr .)each rend[align r0 _(r0+yx[0]-2)sublist 0!t;cr-r0;cc];sb[];refresh[];1}
H:{system "c ",string[x]," ",first system "tput cols";}
.Q.trp[{cnt:0; while[display onKey cnt; cnt+:1]};(); {fini stdscr; show x; -1@.Q.sbt y;H 15}] 
fini stdscr

