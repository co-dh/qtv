fn: .z.x 0
t: get hsym`$fn
/ the render state of the table t, cr/cc, r0: first row to display. multiple render states formed a stack
st:enlist (GL:`r0`cr`cc`kc`type`t)!(0;0;0;0;`;t); reg:enlist[::]!enlist[::]; sp:0
GL set'(0 0 0 0,`,enlist t) //globals of top table. r0: first row to display. cr: current selected row. kc: count of key columns 
convert:{c: "c"$getch[]; if[lower[c]in .Q.t; ![`t;();0b;enlist[k]!enlist($[c;];k:CC`)]]}
delcol:{![`t;();0b;enlist CC`]}; 
sort:{[f]t::f[CC`;t]} //sort table by selected column or key
/(1+cr-r0)=sreen y in [1, y-2] => cr-r0 in [0,y-3]
down:{mr:yx[0]-3;R cr+x; $[0>s:cr-r0;R0 r0+s; s>mr;R0 r0+s-mr]} /mr: max index of rows.
CT:{count t}; CC:{cols[t]cc}; CV:{t[CC`]cr} 
C1:{cc::(-1+count cols t)&0|x+cc}; //current column +=x 
R: {cr::0|x&CT[]-1}
R0:{r0::0|x&CT[]-yx[0]-2}
.kf.d:{if[1<count cols t;delcol[];C1 0]} /del current column
.kf.q:{if[count st; `r0`cr`cc`kc`type`t set' st[0]; st::1_ st]; -1+count st }; .kf[`$"$"]:{convert[]}
.kf.KEY_DOWN:{down  1}; .kf.KEY_LEFT :{C1 -1}; .kf[`$"["]:{sort[xasc]}; .kf[`$"^D"]: .kf.kDN5:{down     yx[0]-2}
.kf.KEY_UP  :{down -1}; .kf.KEY_RIGHT:{C1  1}; .kf[`$"]"]:{sort[xdesc]};.kf[`$"^U"]: .kf.kUP5:{down neg yx[0]-2}
.kf.G:{down CT[]}; .kf.g:{down neg CT[]};
.kf.F:{[]u:0!desc?[t;(); d!d:enlist CC[];enlist[`Cnt]!enlist(count;`i)]
    ; push[`Freq]update Bar: `$floor[Pct]#\:"#" from update Pct: 100*Cnt%sum t`Cnt from u}
push:{st::enlist[GL!value each GL],st;GL set'(0;0;0;0;x;y) }
/exec first i from t where ec_count~\:CV`, i>R`    "
Se:{f:(>;<)!(first;last);R ?[t; (((\:;~);CC`;ctype[]$reg"/");(x;`i;cr));();(f x;`i)]; down 0}
ctype:{neg type T[]CC`}; 
fzf:{`:/tmp/fzf.in 0: x; r:first system "cat /tmp/fzf.in|fzf --print-query --bind ctrl-e:replace-query --header ^E |tail -n1"
    ;clear[]; curs_set 0; r}
input:{fzf enlist $[0h=ctype[]; string[CC`]," like \"",CV[], "\""; string[CC`],"=",string CV[] ]}
inputT:{ctype[]$input`}
.kf[`$"/" ]:{reg["/" ]:inputT`;Se[>]};  .kf.n:{Se[>]};  .kf.N:{Se[<]};  .kf[`$"*"]:{reg["/"]:CV`;Se[>]}
.kf[`$"\\"]:{reg["\\"]:input`;push[`]t:?[T[]; parse each ","vs reg"\\";0b;()]} 
.kf[`$"^"]:{ft xcol[enlist[CC`]!enlist[`$input`]]} 
.kf.D:{push[`]t}; .kf.S:{if[1>count st;:()];n:st[0]; st::enlist[GL!value each GL],1_st; GL set'n}; .kf.M:{push[`m]0!meta t}
.kf[`$"!"]:{n:$[(c:CC`) in k:kc#cols t;k except c;k,c]; kc::count n; t::n xcols t} //if x in key columns, remove it, else add it 
.kf.c::{ 
    ; nc: `$string[c:CC`],"1"
    ; p: 1+cols[t]?x  
    ; t::((p#cols[t]),nc, p _ cols t)xcols ![t;();0b;enlist[nc]!enlist c]
    }
// aggregate CC[] by keyed column. aggregate can be count, sum, avg, dev etc
agg:{f:value fzf string `count`sum`avg`dev`min`max; ?[t;();b!b:kc#cols t; enlist[c]!enlist(f;c:CC`)]}
.kf.b:{push[`agg]agg[]}
/

///////// color map
t: flip (`$string[til 16])!flip 16 16#til 256
rendColor:{[t;xs;cr;cc;r;c] (r; xs c;t[r;c]; color_pair c+r*16)}
rendCell: rendColor

"P"$string floor t[`Time]%1000000
"n"$t`Time
//// forth
what should be at the forth level? every q function? or table functions?
the F language knows nothing about the stack. 
The interpreter knows the stack. it run F string 

