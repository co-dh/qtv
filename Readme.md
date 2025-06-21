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
[ ] nyse, t as symbol, date as drop down
[X] horizontal scroll
[X] separate command that impact display(navigator) vs content
[ ] rewrite in k?
[ ] namespace? if not, hard to use with other code
[ ] history, replay, easily define new function.
row:
    [ ] esc in input
    [X] filter expression 
    [ ] delete
col:
    [X] delete
    [X] copy
    [ ] rename
    [X] xasc, xdesc
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


///////// color map
t: flip (`$string[til 16])!flip 16 16#til 256
rendColor:{[t;xs;cr;cc;r;c] (r; xs c;t[r;c]; color_pair c+r*16)}

//// forth
what should be at the forth level? every q function? or table functions?
the F language knows nothing about the stack. 
The interpreter knows the stack. it run F string 

