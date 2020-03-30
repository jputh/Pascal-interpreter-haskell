//Tests procedures

program t10;
var

a : real = 10;
b : real = 36;
c : real = 9;

procedure FindMin(x, y, z : real);
var
min : real;
begin
    if(x < y) then
        min := x;
    else
        min := y;

    if(z < min) then
        min := z;

    writeln('Minimum value is ', min);
end;

begin

FindMin(a, b, c);

end.

