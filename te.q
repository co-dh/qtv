// te.q - Table data definition
t:([] 
  id:1+til 20;
  name:`Alice`Bob`Charlie`David`Eve`Frank`Grace`Hank`Ivy`Jack`Kara`Liam`Mia`Nora`Oscar`Paul`Quinn`Rose`Sam`Tina;
  department:20?`HR`IT`Sales`Engineering`Support;
  salary:20?50000.0+til 30000;
  years_of_service:20?til 15
 );

/give table t, return 2d array of string of same width at each column.
k)align:{{(|/#:''x)$/:x}(,$!x),$[#*r:.Q.s2'. x:.Q.sw@+x;+r;()]}

/highlight header, current row and current column
rend:{ 
    ; xs: -1_ 0,(+\)1+count each x 0
    ; raze til[count x]{[t;xs;cr;cc;r;c](r;xs c;t[r;c];0) }[x;xs;cr;cc]/:\:til count x 0
    }

rend align t
/
What's the interface between render and kdb?
the render knows:
    r0: first row of t on screen,  0 indexed
    cr,cc: current row/col to highlight
    w,h: screen width/height

the q code need to return an array of [y,x,txt, attr] to be called by addstr
\
/r0: 1; cr:2; cc: 1; w: 50; h:10 
getCmd:{[r0;cr;cc;w;h]
   h sublist r0 _ t 

.Q.tab

    
