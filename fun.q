t: update I:i from("***J*"; enlist csv)0:`:csv/1000.csv
/ the render state of the table t:  cr/cc, r0: first row to display. multiple render states formed a stack
st:enlist `r0`cr`cc`type`t!(0;0;0;`;t); reg:enlist[::]!enlist[::];
ft:{.[`st;0,`t     ;x CC[]]}; Convert:{c: "c"$getch[]; if[lower[c] in .Q.t; fc[$[c;]]]}
fc:{.[`st;0,`t,CC[];x]};      delcol:{![y;();0b;enlist x]}; 
/(1+cr-r0)=sreen y in [1, y-2] => cr-r0 in [0,y-3]
Down:{mr:yx[0]-3; r:R x+R`; $[0>s:r-r0:R0[];R0 r0+s; s>mr;R0 r0+s-mr]} /mr: max index of rows.
T:{st[0]`t}; CT:{count T[]}
C:{$[null x;st[0]`cc; .[`st;0,`cc;:;(count[cols st[0]`t]-1)&0|C[]+x]]}; CC:{cols[st[0]`t]C[]}; CV:{T[][CC`][R`]}
R :{$[null x; st[0;`cr]; [.[`st;0,`cr;:;n:(CT[]-1)&0|x];n]]}
R0:{$[null x; st[0;`r0];  .[`st;0,`r0;:; 0|(CT[]-yx[0]-2)&x]]}

.kf.d:{if[1<count cols T[]; ft delcol; C 0]} /del current column
.kf.q:{st::1_st;count st}; .kf[`$"$"]:{Convert[]}
.kf.KEY_DOWN:{Down  1}; .kf.KEY_LEFT :{C -1}; .kf[`$"["]:{ft[xasc]}; .kf.kDN5:{Down     yx[0]-2}
.kf.KEY_UP  :{Down -1}; .kf.KEY_RIGHT:{C  1}; .kf[`$"]"]:{ft[xdesc]};.kf.kUP5:{Down neg yx[0]-2}
.kf.G:{Down CT[]}; .kf.g:{Down neg CT[]};
.kf.F:{[] /frequency 
    ; t:0!desc?[T[];(); d!d:enlist CC[];enlist[`Cnt]!enlist(count;`i)]
    ; t:update Pct: 100*Cnt%sum t`Cnt from t
    ; t:update Bar: `$floor[Pct]#\:"#" from t
    ; d:`r0`cr`cc`type`t!(0;0;0;`Freq;t)
    ; st::enlist[d],st
    }
/exec first i from t where ec_count~\:CV`, i>R`    "
Se:{f:(>;<)!(first;last); R ?[T[]; (((\:;~);CC`;reg["/"]);(x;`i;R`));();(f x;`i)]; Down 0}
.kf.n:{Se[>]}; .kf.N:{Se[<]}; .kf[`$"*"]:{reg["/"]:CV`;Se[>]}
.kf[`$"/"]:{echo[]; reg["/"]:"c"$getstr[yx[0]-1; 1]; noecho[]; Se[>]}    
/
///////// color map
t: flip (`$string[til 16])!flip 16 16#til 256
rendColor:{[t;xs;cr;cc;r;c] (r; xs c;t[r;c]; color_pair c+r*16)}
rendCell: rendColor

