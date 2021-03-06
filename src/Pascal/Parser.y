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
        ':='            { Token _ (TokenOp ":=")   }
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
        'and'           { Token _ (TokenOp "and") }
        'or'            { Token _ (TokenOp "or") }
        'not'           { Token _ (TokenOp "not") }
        'sqrt'          { Token _ (TokenOp "sqrt") }
        'ln'            { Token _ (TokenOp "ln") }
        'exp'           { Token _ (TokenOp "exp") }
        'sin'           { Token _ (TokenOp "sin") }
        'cos'           { Token _ (TokenOp "cos") }
        '('             { Token _ (TokenK  "(")   }
        ')'             { Token _ (TokenK  ")")   }
        ';'             { Token _  (TokenK ";")   }
        ':'             { Token _  (TokenK ":")   }
        ','             { Token _  (TokenK ",")   }
        '.'             { Token _  (TokenK ".")   }
        'program'       { Token _ (TokenK "program") }
        'begin'         { Token _ (TokenK "begin") }
        'end'           { Token _ (TokenK "end")  }
        'var'           { Token _ (TokenK "var")  }
        'real'          { Token _ (TokenK "real")  }
        'boolean'       { Token _ (TokenK "boolean")  }
        'writeln'       { Token _ (TokenK "writeln") }
        'if'            { Token _ (TokenK "if") }
        'else'          { Token _ (TokenK "else") }
        'then'          { Token _ (TokenK "then") }
        'else if'       { Token _ (TokenK "else if") }
        'for'           { Token _ (TokenK "for") }
        'while'         { Token _ (TokenK "while") }
        'to'            { Token _ (TokenK "to") }
        'do'            { Token _ (TokenK "do") }
        'procedure'     { Token _ (TokenK "procedure") }
        'function'      { Token _ (TokenK "function") }


-- associativity of operators in reverse precedence order
%nonassoc '>' '>=' '<' '<=' '=' '<>'
%left 'and' 'or' 
%left '+' '-'
%left '*' '/'
%nonassoc ':='
%%

-- Entry point
Program :: {Program}
    : 'program' ID ';' VarBlock FuncDecBlock Block '.' { (($4, $5), $6) }

VarBlock :: {[VarDec]}
    : 'var' VarDecs { $2 }

VarDecs :: {[VarDec]}
    : { [] } -- nothing
    | VarDec VarDecs { $1:$2 }

VarDec :: {VarDec}
    : ID ':' 'real' '=' RExp ';' { Init $1 (FloatExp $5) }
    | ID ':' 'boolean' '=' BExp ';' { Init $1 (BoolExp $5) }
    | ID ':' 'real' ';' { DecF $1 }
    | ID ':' 'boolean' ';' { DecB $1 }

FuncDecBlock :: { [Function] }
    : { [] } -- nothing
    | FuncDec FuncDecBlock { $1:$2 }

FuncDec :: {Function}
    : 'function' ID '(' FormalParamList ')' ':' 'real' ';' VarBlock Block ';' { ($2, (RType_Real $4 $9 $10)) }
    | 'function' ID '(' FormalParamList ')' ':' 'boolean' ';' VarBlock Block ';' {  ($2, (RType_Bool $4 $9 $10)) }
    | 'procedure' ID '(' FormalParamList ')' ';' VarBlock Block ';' { ($2, (RType_None $4 $7 $8)) }

 FormalParamList :: { [String] }
    : { [] } --nothing
    | ParamGroup { $1 }
    | FormalParamList { $1 }
    | ParamGroup ';' FormalParamList { $1 ++ $3 }

ParamGroup :: { [String] }
    : VariableList ':' 'real' { $1 }
    | VariableList ':' 'boolean' { $1 }

VariableList :: { [String] }
    : ID { [$1] }
    | ID ',' VariableList { $1:$3 }

 



Statements :: {[Statement]}
    : { [] } -- nothing; make empty list
    | Statement Statements { $1:$2 } -- put statement as first element of statements

Statement :: {Statement}
    : ID ':=' Generic ';' { Assign $1 $3}
    | ID '(' Parameters ')' ';' { ProcCall $1 $3 } 
    | ID ':=' ID '(' Parameters ')' ';' { FuncCall $1 $3 $5 }                      --assignment of boolean
    | 'if' CondBlock ElseIfBlock ElseBlock { If_State ($2:$3) $4 }    --if-elseif-else statement
    | 'writeln' '(' Vals ')' ';' { Writeln $3 }                       --writeln
    | 'for' ID ':=' RExp 'to' RExp 'do' Block ';' { For_Loop $2 $4 $6 $8 }
    | 'while' '(' BExp ')' 'do' Block ';' { While_Loop $3 $6 }


Parameters :: {[Val]}
    : { [] } --nothing
    | Generic { [$1] }
    | Parameters { $1 }
    | Generic ',' Parameters { $1:$3 }



ElseIfBlock :: {[Conditional]}
    : {[]} --nothing
    | ElseIf ElseIfBlock { $1:$2 }

ElseIf :: {Conditional}
    : 'else if' CondBlock { $2 }

CondBlock :: {Conditional}
    : '(' BExp ')' 'then' StateBlock { ($2, $5) }

ElseBlock :: {[Statement]}
    : { [] } --no else statement 
    | 'else' StateBlock { $2 }

StateBlock :: {[Statement]}
    : Block ';' { $1 }
    | Statement { [$1] }

-- Expressions
RExp :: {RExp}
    : '+' RExp { $2 } -- ignore Plus
    | '-' RExp { Op1 "-" $2}
    | 'sqrt' '(' RExp ')' { OpEq "sqrt" $3 }
    | 'ln' '(' RExp ')' { OpEq "ln" $3 }
    | 'exp' '(' RExp ')' { OpEq "exp" $3 }
    | 'sin' '(' RExp ')' { OpEq "sin" $3 }
    | 'cos' '(' RExp ')' { OpEq "cos" $3 }
    | RExp '*' RExp { Op2 "*" $1 $3 }
    | RExp '/' RExp { Op2 "/" $1 $3 }
    | RExp '+' RExp { Op2 "+" $1 $3 }
    | RExp '-' RExp { Op2 "-" $1 $3 }
    | '(' RExp ')' { $2 } -- ignore brackets
    | float { Real $1 }
    | ID { Var_R $1 }

BExp :: {BExp}
    : bool { Boolean $1 }
    | 'not' BExp { Not $2 }
    | BExp 'and' BExp { OpB "and" $1 $3 }
    | BExp 'or' BExp { OpB "or" $1 $3 }
    | RExp '=' RExp { Comp "=" $1 $3 }
    | RExp '<>' RExp { Comp "<>" $1 $3 }
    | RExp '>' RExp { Comp ">" $1 $3 }
    | RExp '<' RExp { Comp "<" $1 $3 }
    | RExp '>=' RExp { Comp ">=" $1 $3 }
    | RExp '<=' RExp { Comp "<=" $1 $3 }
    | ID { Var_B $1 }






-- helpers 
Val :: {Val}
    : ID { Val_ID $1 }
    | RExp { GExp (FloatExp $1) }
    | BExp { GExp (BoolExp $1) }
    | string { Val_S $1 }

Vals :: {[Val]}
    : {[]} --nothing
    | Val { [$1] }
    | Vals { $1 }
    | Val ',' Vals { $1:$3 }


Block :: {[Statement]}
    : 'begin' Statements 'end' { $2 }

Generic :: {Val}
    : ID {(Val_ID $1)}
    | RExp { GExp (FloatExp $1) }
    | BExp { GExp (BoolExp $1) }

{}
