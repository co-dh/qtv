Freq:{[] 
    ; t:0!desc?[T[];(); d!d:enlist CC[];enlist[`Cnt]!enlist(count;`i)]
    ; t:update Pct: 100*Cnt%sum t`Cnt from t
    ; t:update Bar: `$floor[Pct]#\:"#" from t
    ; d:`r0`cr`cc`type`t!(0;0;0;`Freq;t)
    ; st::enlist[d],st
    }

/

///////// color map
t: flip (`$string[til 16])!flip 16 16#til 256
rendColor:{[t;xs;cr;cc;r;c] (r; xs c;t[r;c]; color_pair c+r*16)}
rendCell: rendColor

