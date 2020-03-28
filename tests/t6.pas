//Tests if-elseif-else statements/blocks
//This test shows that if statement blocks are not evaluated unless the corresponding if-statement is true

program test6
var 

b : real = 0.0;
c : real;

begin

c := cos(b);

if(c > 100.0) then
    writeln('c is pretty big');
else if (c > 50.0) then
    writeln('c is kinda big');
else if (c = 10.0) then
    begin
    writeln('c is kinda small but we can make it bigger');
    c := c * 100.0;
    writeln('c is now equal to ', c);
    end;
else if (c > 0.0) then
    begin
    writeln('c is pretty small but we can make it humungous');
    c := c * 200.0;
    writeln('c is now equal to ', c);
    end;

writeln('Why do we care so much about c');

end.
