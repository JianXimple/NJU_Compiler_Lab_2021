%{
#include "syntax.tab.h"
/* record appear location*/
int yycolumn = 1;
#define YY_USER_ACTION \
    yylloc.first_line = yylloc.last_line = yylineno; \
    yylloc.first_column = yycolumn; \
    yylloc.last_column = yycolumn + yyleng - 1; \
    yycolumn += yyleng;

extern uint8_t right;
%}
/* record line no*/
%option yylineno
/* C -- definition */ 
delim       [ \t]
ws          {delim}+
digit       [0-9]
letter      [_a-zA-Z]
nonletter   [`~@#$%^|\\\?:\"\']
relop       >|<|>=|<=|==|!=
type        int|float
STRUCT      struct
RETURN      return
IF          if
ELSE        else
WHILE       while
ID          {letter}+({digit}|{letter})*         
INT_DEC         ([1-9]{digit}*|0)               
INT_OCT         0[0-7]+                         
INT_HEX         0[xX][0-9a-fA-F]+               
FLOAT       {digit}+\.{digit}+              
OCT         0[0-7]*[89]+[0-9]*                      
HEX         0[xX][0-9a-fA-F]*[g-zG-Z]+[0-9a-zA-Z]*       
%%
\n      {yycolumn = 1;}
{ws}    {}
{STRUCT}  {yylval.node = newTreeNode("STRUCT", Ter, yytext); return STRUCT;}
{RETURN}  {yylval.node = newTreeNode("RETURN", Ter, yytext); return RETURN;}
{IF}      {yylval.node = newTreeNode("IF", Ter, yytext); return IF;}
{ELSE}    {yylval.node = newTreeNode("ELSE", Ter, yytext); return ELSE;}
{WHILE}   {yylval.node = newTreeNode("WHILE", Ter, yytext); return WHILE;}
{type}  {yylval.node = newTreeNode("TYPE", Type, yytext); return TYPE;}
"("     {yylval.node = newTreeNode("LP", Ter, yytext); return LP;}
")"     {yylval.node = newTreeNode("RP", Ter, yytext); return RP;}
"["     {yylval.node = newTreeNode("LB", Ter, yytext); return LB;}
]       {yylval.node = newTreeNode("RB", Ter, yytext); return RB;}
"{"     {yylval.node = newTreeNode("LC", Ter, yytext); return LC;}
"}"     {yylval.node = newTreeNode("RC", Ter, yytext); return RC;}
;       {yylval.node = newTreeNode("SEMI", Ter, yytext); return SEMI;}
,       {yylval.node = newTreeNode("COMMA", Ter, yytext); return COMMA;}
=       {yylval.node = newTreeNode("ASSIGNOP", Ter, yytext); return ASSIGNOP;}
{relop} {yylval.node = newTreeNode("RELOP", Relop, yytext); return RELOP;}
"+"     {yylval.node = newTreeNode("PLUS", Ter, yytext); return PLUS;}
-       {yylval.node = newTreeNode("MINUS", Ter, yytext); return MINUS;}
"*"     {yylval.node = newTreeNode("STAR", Ter, yytext); return STAR;}
"/"     {yylval.node = newTreeNode("DIV", Ter, yytext); return DIV;}
&&      {yylval.node = newTreeNode("AND", Ter, yytext); return AND;}
"||"    {yylval.node = newTreeNode("OR", Ter, yytext); return OR;}
"."     {yylval.node = newTreeNode("DOT", Ter, yytext); return DOT;}
!       {yylval.node = newTreeNode("NOT", Ter, yytext); return NOT;}
{ID}    {yylval.node = newTreeNode("ID", Id, yytext); return ID;}
{INT_DEC}               {yylval.node = newTreeNode("INT", Int, yytext); return INT;}
{INT_OCT}                         {yylval.node = newTreeNode("OCT", Int, yytext); return INT;}
{INT_HEX}               {yylval.node = newTreeNode("HEX", Int, yytext); return INT;}
{FLOAT}              {yylval.node = newTreeNode("FLOAT", Float, yytext); return FLOAT;}
{OCT}                      {printf("Error type A at Line %d: Illegal octal int \'%s\'.\n", yylineno, yytext); yylval.node = newTreeNode("OCT", Int, yytext); right = 0; return INT;}
{HEX}  {printf("Error type A at Line %d: Illegal hexadecimal int \'%s\'.\n", yylineno, yytext); yylval.node = newTreeNode("HEX", Int, yytext); right = 0; return INT;}
{digit}+\.|\.{digit}+                   {printf("Error type A at Line %d: Illegal float  \'%s\'.\n", yylineno, yytext);}
{digit}+({digit}|{letter})+     {printf("Error type A at Line %d: Illegal ID \'%s\'.\n", yylineno, yytext); yylval.node = newTreeNode("ID", Id, yytext); right = 0; return ID;}

.   {printf("Error type A at Line %d: Unknown character \'%s\'.\n", yylineno, yytext); right = 0;}
%%