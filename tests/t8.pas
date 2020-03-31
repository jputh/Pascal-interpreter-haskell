//Tests for loop and beginning of scopes
//output: b is equal to 1.0
//b is equal to 2.0
//b is equal to 4.0
//b is equal to 7.0
//Lucky number
//b is equal to 11.0

program test8;
var
b : real = 1;

begin

for a := 0 to 5 do
begin
    b := b + a;
    writeln('b is equal to ', b);

    if(b = 7) then
        writeln('Lucky number');
end;
end.