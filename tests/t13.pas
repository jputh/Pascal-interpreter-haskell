program test13;

var

a : real;

function factorial(a : real) : real;
var

b : real;
result : real;

begin

    if(a = 1) then
        result := 1;
    else
        begin
            b := factorial(a-1);
            result := a * b;
        end;

    factorial := result;
end;

begin

    a := factorial(5);
    writeln('The factorial of 5 is ', a);

end.