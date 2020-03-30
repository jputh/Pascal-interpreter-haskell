//Tests procedures

program t10;
var

v : real = 10;

procedure SayHello(a : real);
var
q : real = 10;
begin
if(a < q) then
    writeln('hello');
else
    writeln('I hate you');
end;

procedure SayHello2();
var
begin
writeln('hey');
end;

begin

SayHello(7);
SayHello(11);
SayHello2();
SayHello2();

end.