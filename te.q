#!/Users/dh/q/m64/q
rel:{` sv first[` vs hsym`$get[x]6],y}
{system "l ",1_string rel[{}]x} each `curse.q`fun.q
k)align:{{(|/#:''x)$/:x}(,$!x),$[#*r:.Q.s2'. x:.Q.sw@+x;+r;()]}
rend:{[t;cr;cc] /render string table t with select row(cr) and column(cc)
    ; xs:-1_0,(+\)1+count each t 0 //x of each column
    ; xs,: last[xs]+count last t[0]
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
CT:{count t}; 
sb:{s:neg[-10+yx 1]$msg, "|",("/"sv -3 sublist "/"vs fn),string[kn], " ",string[cr],"/",commify CT`; Addstr[yx[0]-1;0;s;.cl.st]; refresh[]}
display:{[x]if[(kn=`Q)or 0=count st;H 15; :0] ;erase[]; (Addstr .)each rend[align r0 _(r0+yx[0]-2)sublist t;cr-r0;cc];sb[];refresh[];1}
H:{system "c ",string[x]," ",first system "tput cols";}
/navigator
C1:{cc::(-1+count cols t)&0|x+cc}; //current column +=x 
/(1+cr-r0)=sreen y in [1, y-2] => cr-r0 in [0,y-3]
down:{mr:yx[0]-3;R cr+x; $[0>s:cr-r0;R0 r0+s; s>mr;R0 r0+s-mr]} /mr: max index of rows.
R: {cr::0|x&CT[]-1} //set current select row
R0:{r0::0|x&CT[]-yx[0]-2} //set R0: the first row on screen
.kf.KEY_DOWN:{down  1}; .kf.KEY_LEFT :{C1 -1}; .kf[`$"^D"]: .kf.kDN5:{down     yx[0]-2}
.kf.KEY_UP  :{down -1}; .kf.KEY_RIGHT:{C1  1}; .kf[`$"^U"]: .kf.kUP5:{down neg yx[0]-2}
.kf.G:{down CT[]}; .kf.g:{down neg CT[]};
ctype:{neg type t CC`}; 
/exec first i from t where ec_count~\:CV`, i>R`    "
Se:{f:(>;<)!(first;last);R ?[t; (((\:;~);CC`;ctype[]$reg"/");(x;`i;cr));();(f x;`i)]; down 0}
.kf[`$"/" ]:{reg["/" ]:inputT`;Se[>]};  .kf.n:{Se[>]};  .kf.N:{Se[<]};  .kf[`$"*"]:{reg["/"]:CV`;Se[>]}
/input
fzf:{`:/tmp/fzf.in 0: x; r:last system "sh -c 'fzf --print-query</tmp/fzf.in || true' " ;clear[]; curs_set 0; r}
input:{fzf enlist $[0h=ctype[]; string[CC`]," like \"",CV[], "\""; string[CC`],"=",string CV[] ]}
inputT:{ctype[]$input`}
.kf[`$"!"]:{n:$[(c:CC`) in k:kc#cols t;k except c;k,c]; kc::count n; t::n xcols t} //if x in key columns, remove it, else add it 

/main
.Q.trp[{cnt:0; while[display onKey cnt; cnt+:1]};(); {fini stdscr; show x; -1@.Q.sbt y;H 15}] 
fini stdscr
