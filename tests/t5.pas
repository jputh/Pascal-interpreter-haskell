// Tests if statements

program test5;
var

a : boolean = True;
x : real = 9.0;
y : real = 9.0;

begin

if(x > y) then 
    writeln('The condition is true');
else if (x = y) then
    writeln('The values are equal');
else
    writeln('The condition is false');

end.