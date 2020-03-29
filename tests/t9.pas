//Tests while loop 

program test8
var
b : real = 1;
q : boolean = True;

begin

while (b <= 5) do
begin
    if(q) then
        writeln('She loves me');
    else
        writeln('She loves me not');

    b := b + 1;
    q := not q;
end;
end.