t: update I:i from("***J*"; enlist csv)0:`:csv/newzea.csv
/ the render state of the table t:  cr/cc, r0: first row to display. multiple render states formed a stack
st:enlist `r0`cr`cc`type`t!(0;0;0;`;t); reg:enlist[::]!enlist[::]; sp:0
ft :{.[`st;sp,`t    ;x]}
ftc:{.[`st;sp,`t    ;x CC`]}; Convert:{c: "c"$getch[]; if[lower[c] in .Q.t; fc[$[c;]]]}
fc: {.[`st;sp,`t,CC`;x]}    ; delcol:{![y;();0b;enlist x]}; 
/(1+cr-r0)=sreen y in [1, y-2] => cr-r0 in [0,y-3]
Down:{mr:yx[0]-3; r:R x+R`; $[0>s:r-r0:R0[];R0 r0+s; s>mr;R0 r0+s-mr]} /mr: max index of rows.
T:{st[sp]`t}; C:{st[sp]`cc}; CT:{count T[]}; F2:{.[`st;sp,x;:;y]}; CC:{cols[T`]C`}; CV:{T[][CC`][R`]}
k)C1:{F2[`cc; (-1+#!+st[sp]`t)&0|x+C`]}; 
R :{$[null x; st[0;`cr]; [.[`st;0,`cr;:;n:(CT[]-1)&0|x];n]]}
R0:{$[null x; st[0;`r0];  .[`st;0,`r0;:; 0|(CT[]-yx[0]-2)&x]]}
.kf.d:{if[1<count cols T[]; ftc delcol; C1 0]} /del current column
.kf.q:{st::1_st;count st}; .kf[`$"$"]:{Convert[]}
.kf.KEY_DOWN:{Down  1}; .kf.KEY_LEFT :{C1 -1}; .kf[`$"["]:{ftc[xasc]}; .kf.kDN5:{Down     yx[0]-2}
.kf.KEY_UP  :{Down -1}; .kf.KEY_RIGHT:{C1  1}; .kf[`$"]"]:{ftc[xdesc]};.kf.kUP5:{Down neg yx[0]-2}
.kf.G:{Down CT[]}; .kf.g:{Down neg CT[]};
.kf.F:{[]t:0!desc?[T[];(); d!d:enlist CC[];enlist[`Cnt]!enlist(count;`i)]
    ; push[`Freq]update Bar: `$floor[Pct]#\:"#" from update Pct: 100*Cnt%sum t`Cnt from t }
push:{d:`r0`cr`cc`type`t!(0;0;0;x;y); st::enlist[d],st}
/exec first i from t where ec_count~\:CV`, i>R`    "
Se:{f:(>;<)!(first;last); R ?[T[]; (((\:;~);CC`;ctype[]$reg"/");(x;`i;R`));();(f x;`i)]; Down 0}
ctype:{neg type T[]CC`}; Input:{echo[]; r:"c"$getstr[yx[0]-1; 1]; noecho[]; r}; InputT:{ctype[]$Input`}
.kf[`$"/" ]:{reg["/" ]:InputT`;Se[>]}; .kf.n:{Se[>]}; .kf.N:{Se[<]}; .kf[`$"*"]:{reg["/"]:CV`;Se[>]}
.kf[`$"\\"]:{reg["\\"]:InputT`;push[`]t:?[T[]; enlist((\:;~);CC`;reg"\\");0b;()]} 
.kf[`$"^"]:{ft xcol[enlist[CC`]!enlist[`$Input`]]} 
.kf.D:{push[`]T[]}; .kf.S:{@[`st;0 1;:;st 1 0]}; .kf.M:{push[`m]0!meta T[]}

/
///////// color map
t: flip (`$string[til 16])!flip 16 16#til 256
rendColor:{[t;xs;cr;cc;r;c] (r; xs c;t[r;c]; color_pair c+r*16)}
rendCell: rendColor

//// forth
what should be at the forth level? every q function? or table functions?
the F language knows nothing about the stack. 
The interpreter knows the stack. it run F string 

