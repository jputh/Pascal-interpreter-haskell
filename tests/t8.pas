//Tests for loop and beginning of scopes

program test8
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