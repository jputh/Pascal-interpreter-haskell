//Tests procedures
//output : hello the value of q inside the procedure is 10.0
//hey the value of q inside the procedure is now 1000.0

program t10;
var

v : real = 10;
q : real = 8;

procedure SayHello(a : real);
var
q : real = 10;
begin
    if(a < q) then
        begin
            a := 500;
            writeln('hello the value of q inside the procedure is ', q);
        end;
    else
        begin
            q := 1000;
            writeln('hey the value of q inside the procedure is now ', q);
        end;
end;


begin


SayHello(7);
SayHello(11);



end.