#!/Users/dh/q/m64/q
\l p.q
x set' .p.import each x:`builtins`curses;
import:{y set x[hsym y;<]}
builtins import/:`getattr`dir;
curses import/:`color_pair`has_colors`use_default_colors`init_pair`echo`noecho`cbreak`nocbreak`endwin`start_color`curs_set`initscr;
Attr: k!getattr[curses;] each k:`${x where any x like/:("A_*";"KEY_*")}dir(curses)
init:{stdscr:.p.wrap initscr[];noecho[];cbreak[];start_color[];curs_set 0; 
    if[has_colors[];use_default_colors[];{init_pair[x+1;x;-1]}each til 256]; stdscr}
fini:{keypad 0;echo[];nocbreak[];endwin[]}
k)align:{{(|/#:''x)$/:x}(,$!x),$[#*r:.Q.s2'. x:.Q.sw@+x;+r;()]}
rend:{[x;cr;cc]xs:-1_0,(+\)1+count each x 0; raze til[count x]rend1[x;xs;cr;cc]/:\:til count x 0 }
rend1:{[t;xs;cr;cc;r;c]a:$[cr=r; Attr`A_REVERSE; c=cc; bor[color_pair 232; Attr`A_BOLD]; 0]; (r;xs c;t[r;c];a)}
bor:{0b sv (|/)0b vs/:x,y} /bitwise or
lg: {x -3!y; y}neg[hopen `:/tmp/te.log]
onKey:{[c;yx]
    /; lg (`onKey;`c;c;`yx; yx)
    ; s:st[0];k:Attr?c
    ; $[k=`KEY_DOWN;  Down[s;yx]
      ;k=`KEY_UP  ;   Up[s;yx]
      ;k=`KEY_LEFT;  .[`st;0,`cc;:;0|s[`cc]-1]
      ;k=`KEY_RIGHT; .[`st;0,`cc;:;(count[cols s`t]-1)&1+s`cc]
      ;c="[";        .[`st;0,`t;cols[s`t][s`cc] xasc]
      ;c="]";        .[`st;0,`t;cols[s`t][s`cc] xdesc]
      ;c="F";        Freq[s;yx]
      ]
    ;yx}

Down:{[s; yx]mr:yx[0]-1;  $[mr=s`cr;.[`st;0,`r0;:; (count[s`t]-mr)&1+s`r0];  .[`st;0,`cr;:;(yx[0]-1)&1+s`cr]]}
Up  :{[s; yx]             $[0=s`cr ;.[`st;0,`r0;:;0|s[`r0]-1];               .[`st;0,`cr;:;0|s[`cr]-1]]}

display:{[yx]
    ; s:st 0
    ; lg (`display;`yx;yx)
    ;erase[]
    ;rows:rend[align (yx[0]-1) sublist s[`r0]_ s`t;s`cr;s`cc]
    ;{addstr[x 0;x 1;x 2;x 3]}each rows
    ;refresh[]
    }

t: ("SSIJJ"; enlist csv)0:`:csv/newzea.csv
cc:{s:st 0; cols[s`t] s[`cc]}
Freq:{[s;yx]t:0!desc?[s`t;(); d!d:enlist cc[];enlist[`Cnt]!enlist(count;`i)]; d:`r0`cr`cc`type`t!(0;0;0;`Freq;t); st::enlist[d],st}
/ the render state of the table t:  cr/cc, r0: first row to display. multiple render states formed a stack
st:enlist `r0`cr`cc`type`t!(0;0;0;`;t)
/addstr:{x}; color_pair:{x} /DBG

stdscr:init[]
stdscr import/:`erase`refresh`getmaxyx`getch`keypad`addstr;
keypad[1] /convert escape sequences to int
.z.exit:{[x]fini stdscr}
display getmaxyx[]    
while["q"<>c:getch[];display onKey[c]getmaxyx[]] 
exit 0
/
What's the interface between render and kdb?
the render knows:
    r0: first row of t on screen,  0 indexed
    cr,cc: current row/col to highlight
    w,h: screen width/height

the q code need to return an array of [y,x,txt, attr] to be called by addstr

/
foo: .pykx.get[`init1][]
foo[`f;<][1;2]
\
