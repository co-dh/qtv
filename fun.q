fn: .z.x 0
t: get hsym`$fn
/ the render state of the table t, cr/cc, r0: first row to display. multiple render states formed a stack
st:enlist (GL:`r0`cr`cc`kc`type`t)!(0;0;0;0;`;t); reg:enlist[::]!enlist[::]; sp:0
GL set'(0 0 0 0,`,enlist t) //globals of top table. r0: first row to display. cr: current selected row. kc: count of key columns 
del:{$[1<count cols y; ![y;();0b;(),x]; y]}; /delete column x from table y
k)CC:{(!+t)cc}; CV:{t[CC`]cr} 
HI:""; ft:{HI::x," ",HI; t::value[x] t; msg::HI;0}
fact:{ft string[x],"[", (";"sv .Q.s1 each y,CC`),"]"};  /apply f, arg, column to t. f[a;CC`;t]
fct:fact[;()]
to:{[c;k;t]$[lower[c]in .Q.t; ![t;();0b;enlist[k]!enlist($[c;];k)]; t]}
ren:{(enlist[y]!enlist[x]) xcol z} //newName, oldName, table
cp:{nc:`$string[x],"1"; i:1+cols[y]?x; ((i#cols[y]),nc,i _ cols y)xcols ![y;();0b;enlist[nc]!enlist x]}

.kf.d:{C1 fct`del}; .kf[`$"["]:{fct`xasc}; .kf[`$"]"]:{fct`xdesc}; .kf.c:{fct`cp}
.kf[`$"$"]:{fact[`to]"c"$getch[]}
.kf[`$"^"]:{fact[`ren]`$input`} 

.kf.q:{if[count st; `r0`cr`cc`kc`type`t set' st[0]; st::1_ st]; -1+count st }; 

.kf.F:{[]u:0!desc?[t;(); d!d:enlist CC[];enlist[`Cnt]!enlist(count;`i)]
    ; push[`Freq]update Bar: `$floor[Pct]#\:"#" from update Pct: 100*Cnt%sum u`Cnt from u}
push:{st::enlist[GL!value each GL],st;GL set'(0;0;0;0;x;y) }
/exec first i from t where ec_count~\:CV`, i>R`    "
Se:{f:(>;<)!(first;last);R ?[t; (((\:;~);CC`;ctype[]$reg"/");(x;`i;cr));();(f x;`i)]; down 0}
ctype:{neg type t CC`}; 
.kf[`$"\\"]:{reg["\\"]:input`;push[`]t:?[T[]; parse each ","vs reg"\\";0b;()]} 
.kf.D:{push[`]t}; 
.kf.S:{if[1>count st;:()];n:st[0]; st::enlist[GL!value each GL],1_st; GL set'n}; 
.kf.M:{push[`m]0!meta t}
.kf[`$"!"]:{n:$[(c:CC`) in k:kc#cols t;k except c;k,c]; kc::count n; t::n xcols t} //if x in key columns, remove it, else add it 

// aggregate CC[] by keyed column. aggregate can be count, sum, avg, dev etc
agg:{f:value fzf string `count`sum`avg`dev`min`max; ?[t;();b!b:kc#cols t; enlist[c]!enlist(f;c:CC`)]}
.kf.b:{push[`agg]agg[]} //by
