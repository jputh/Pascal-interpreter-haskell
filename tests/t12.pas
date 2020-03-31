//Tests functions

program test12;

var

a : real;

function MultiplyBy5(a : real) : real;
var


begin

    MultiplyBy5 := a * 5;
    
end;

begin

    a := MultiplyBy5(5);
    writeln('a multiplied by 5 is ', a);

end.