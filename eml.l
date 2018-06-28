%e  1019
%p  2807
%n  371
%k  284
%a  1213
%o  1117

%{

#include <string>

#include "Node.h"
#include "parser.hpp"


#define SAVE_TOKEN yylval.string = new std::string(yytext, yyleng)
#define TOKEN(t) (yylval.token = t)

extern "C" int yywrap() { }

%}

%%


"on "[a-zA-Z_][a-zA-Z0-9_\.\,]*                 SAVE_TOKEN; return TON;
"Repeater"                                      return TOKEN(TREPEATER);

[-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?          SAVE_TOKEN; return TNUMBER;
[a-zA-Z_][a-zA-Z0-9_]*                        SAVE_TOKEN; return TIDENTIFIER;
(\"([^\\\"]|\\.)*\")                            SAVE_TOKEN; return TSTRING;

\%[-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?        SAVE_TOKEN; return TREPLACER;

"{"                                             return TOKEN(TLBRACE);
"}"                                             return TOKEN(TRBRACE);
"["                                             return TOKEN(TLBRACKET);
"]"                                             return TOKEN(TRBRACKET);
"("                                             return TOKEN(TLPAREN);
")"                                             return TOKEN(TRPAREN);
"="                                             return TOKEN(TEQUAL);
"\."                                             return TOKEN(TDOT);

":"                                             return TOKEN(TCOL);
","                                             return TOKEN(TCOMMA);

[\;]                                             return TOKEN(TSCOL);
[ \t\n]                                        ;
.                                               printf("Unknown token!n"); yyterminate();

%%