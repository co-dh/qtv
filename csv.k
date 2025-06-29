\d .csv
gt:{j:(2>|/|/'+/''x=/:e) & &/&/'(x in "0123456789")|(f:x in e:".eE+-"); f:|/|/'f; $[f&j;"F";j;"J"; 0.1>(#?x)%#x;"s";"*"]}
read:{t: ."\\head -n 10000 ",x;c@:i:*>c:+/'t[0]=/:s:",|"; t:((c+1)#"*";,s i)0:-1!`$x; (. gt'+t;,s i)0:-1!`$x}

/
\d . 

t: .csv.read x: "../qtvdata/1000.csv"
meta t
1 .Q.s t
gt x:t`BidPrice
gt x:("12.0e5"; "12.2.3"; "abc")
gt x:("12.0e5"; "12.2.3")
gt x:("12"; "123")
t:+(`$($:!+t).q.except\:"_")!.+t; /remove _ from table column name

