{
module Pascal.Parser where

import Pascal.Base
import Pascal.Data
import Pascal.Lexer
}


%name happyParser
%tokentype { Token }

%monad { Parser } { thenP } { returnP }
%lexer { lexer } { Token _ TokenEOF }

%token
        float           { Token _ (TokenReal $$) }
        bool            { Token _ (TokenBool $$) }
        ID              { Token _ (TokenID $$)  }
        string          { Token _ (TokenStr $$) }
        '+'             { Token _ (TokenOp "+")   }
        '-'             { Token _ (TokenOp "-")   }
        '*'             { Token _ (TokenOp "*")   }
        '/'             { Token _ (TokenOp "/")   }
        '='             { Token _ (TokenOp "=")   }
        '<>'            { Token _ (TokenOp "<>")  }
        '>'             { Token _ (TokenOp ">")  }
        '<'             { Token _ (TokenOp "<")  }
        '<='            { Token _ (TokenOp "<=")  }
        '>='            { Token _ (TokenOp ">=")  }
        ':='            { Token _ (TokenOp ":=")   }
        '('             { Token _ (TokenK  "(")   }
        ')'             { Token _ (TokenK  ")")   }
        ';'             { Token _  (TokenK ";")   }
        ','             { Token _  (TokenK ",")   }
        'program'       { Token _ (TokenK "program") }
        'begin'         { Token _ (TokenK "begin") }
        'end'           { Token _ (TokenK "end")  }
        'and'           { Token _ (TokenOp "and") }
        'or'            { Token _ (TokenOp "or") }
        'not'           { Token _ (TokenOp "not") }
        'writeln'       { Token _ (TokenK "writeln") }

-- associativity of operators in reverse precedence order
%nonassoc '>' '>=' '<' '<=' '=' '<>'
%left 'and' 'or' 
%left '+' '-'
%left '*' '/'
%nonassoc ':='
%%

-- Entry point
Program :: {Program}
    : 'program' 'begin' Statements 'end' { $3 }



-- Expressions
RExp :: {RExp}
    : '+' RExp { $2 } -- ignore Plus
    | '-' RExp { Op1 "-" $2}
    | RExp '*' RExp { Op2 "*" $1 $3 }
    | RExp '/' RExp { Op2 "/" $1 $3 }
    | RExp '+' RExp { Op2 "+" $1 $3 }
    | RExp '-' RExp { Op2 "-" $1 $3 }
    | '(' RExp ')' { $2 } -- ignore brackets
    | float { Real $1 }

BExp :: {BExp}
    : bool { Boolean $1 }
    | 'not' BExp { Not $2 }
    | BExp 'and' BExp { OpB "and" $1 $3 }
    | BExp 'or' BExp { OpB "or" $1 $3 }

Statements :: {[Statement]}
    : { [] } -- nothing; make empty list
    | Statement Statements { $1:$2 } -- put statement as first element of statements

Statement :: {Statement}
    : ID ':=' RExp ';'{ Assign $1 (FloatExp $3) }
    | ID ':=' BExp ';'{ Assign $1 (BoolExp $3) }
    | 'writeln' '(' Vals ')' ';' { Writeln $3 }


-- helpers for writeln
Val :: {Val}
    : RExp { GExp (FloatExp $1) }
    | BExp { GExp (BoolExp $1) }
    | string { Val_S $1 }

Vals :: {[Val]}
    : {[]} --nothing
    | Val { [$1] }
    | Vals { $1 }
    | Val ',' Vals { $1:$3 }

{}
