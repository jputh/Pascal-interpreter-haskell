//Tests procedures

program t10;
var

v : real = 10;

procedure SayHello(a : real);
var
q : real = 10;
begin
if(a < q) then
begin
    a := 500;
    writeln('hello');
    end;
else
begin
    q := 1000;
    writeln('I hate you');
    end;
end;

procedure SayHello2();
var
begin
writeln('hey');
end;

begin

SayHello(7);
SayHello(11);


end.