%{

#include <iostream>
#include "Node.h"
extern int yylex();
void yyerror(const char *s) { std::cout << s << std::endl; }

%}

%error-verbose

%union {
    ENode *node;
    std::string *string;
    int token;
}

%token <string> TIDENTIFIER TWIDGET TSTRING TNUMBER TON TREPLACER
%token <token> TLBRACKET TRBRACKET TLBRACE TRBRACE TLPAREN TRPAREN
%token <token> TCOL TEND TCOMMA TSCOL TEQUAL TREPEATER TDOT

%start eml_blocks

%%

/* BLOCK <<<<<<<<<<<< */
eml_blocks
:   eml_blocks eml_block                            { std::cout << "append block" << std::endl; }
|   eml_block                                       { std::cout << "new block" << std::endl; }
;

eml_block
:   eml_object
|   eml_property TSCOL
|   eml_property
|   eml_callback
|   eml_repeater
;

eml_callbackblocks
:   eml_callbackblocks eml_callbackblock                            { std::cout << "append block" << std::endl; }
|   eml_callbackblock                                       { std::cout << "new block" << std::endl; }
;

eml_callbackblock
:   eml_callbackproperty TSCOL
|   eml_callbackproperty
;
/* >>>>>>>>>>> BLOCK */



/* OBJECT <<<<<<<<<<<< */
eml_object
:   eml_list TCOL eml_name_ns TLBRACE eml_blocks TRBRACE     { std::cout << "LALR(1)"<< std::endl; }
|   eml_list TCOL eml_name_ns TLBRACE TRBRACE     { std::cout << "LALR(1)" << std::endl; }
|   eml_name_ns TLBRACE eml_blocks TRBRACE     { std::cout << "new block body" << std::endl; }
|   eml_name_ns TLBRACE TRBRACE                     { std::cout << "new empty block body" << std::endl; }
;
/* >>>>>>>>>>> OBJECT */



/* PROPERTY <<<<<<<<<<<< */
eml_property
:   eml_name_ns                                  { std::cout << "property ident " << std::endl; }
|   eml_keyvalue                                 { std::cout << "property val : keyvalue" << std::endl; }
;

eml_callbackproperty
:   eml_keyvalue                                 { std::cout << "property val : keyvalue" << std::endl; }
|   eml_name_ns                                  { std::cout << "property ident " << std::endl; }
|   eml_name_ns eml_name_ns                      { std::cout << "property val : function call?" << std::endl; }
;
/* >>>>>>>>>>> PROPERTY */



/* CALLBACK <<<<<<<<<<<< */
eml_callback
:   TON  TLBRACE eml_callbackblocks TRBRACE          { std::cout << "new callback body"<< *$1 << std::endl; }
|   TON  TLBRACE TRBRACE                     { std::cout << "new empty callback body"<< *$1 << std::endl; }
;
/* >>>>>>>>>>> CALLBACK */



/* REPEATER <<<<<<<<<<<< */
eml_repeater
:   eml_repeaterbase TLBRACE eml_object TRBRACE     { std::cout << "repeater ... is it possible?" << std::endl; }
;

eml_repeaterbase
: TREPEATER TLPAREN eml_repeater_specs TRPAREN
;

eml_repeater_specs
:   eml_repeater_specs TCOMMA eml_repeater_spec
|   eml_repeater_spec
;

eml_repeater_spec
:   TNUMBER TCOMMA TNUMBER TEQUAL eml_list      { std::cout << "spec 1" << *$1 << *$3 << std::endl; }
|   TNUMBER TEQUAL eml_list                     { std::cout << "spec 1" << *$1 << std::endl; }
|   TNUMBER                                     { std::cout << "spec 2" << *$1 << std::endl; }
;
/* >>>>>>>>>>> REPEATER */

/* NAME_NS <<<<<<<<<<<< */
eml_name_ns
: eml_name_ns TDOT TIDENTIFIER
| TIDENTIFIER
;
/* >>>>>>>>>>> NAME_NS */

/* KEYVALUE <<<<<<<<<<<< */
eml_keyvalue
:   eml_key TCOL eml_value                      { std::cout << "new keyvalue" << std::endl; }
;

eml_key
:   eml_name_ns                                     { std::cout << "new key : "  << std::endl; }
|   eml_name_ns TLBRACKET TSTRING TRBRACKET         { std::cout << "new key2(part) : " << *$3 << std::endl; }
|   eml_name_ns TLBRACKET eml_name_ns TRBRACKET     { std::cout << "new key3(part) : " << std::endl; }
;

eml_value
:   eml_name_ns                                 { std::cout << "new val :"  << std::endl; }
|   TSTRING                                     { std::cout << "new val :" << *$1 << std::endl; }
|   TNUMBER                                     { std::cout << "new val :" << *$1 << std::endl; }
|   TREPLACER                                   { std::cout << "new val :" << *$1 << std::endl; }
|   eml_list                                    { std::cout << "new val eml_list" << std::endl; }
|   eml_map                                     { std::cout << "new val eml_list" << std::endl; }

;
/* >>>>>>>>>>> KEYVALUE */



/* LIST <<<<<<<<<<<< */
eml_list
:   TLBRACKET eml_listitems TRBRACKET
/*| TLBRACKET TRBRACKET empty list ?*/
;

eml_listitems
:   eml_listitems TCOMMA eml_listitem
|   eml_listitem
;

eml_listitem
:   eml_name_ns
|   TSTRING
|   TNUMBER
|   TREPLACER
|   eml_map
;
/* >>>>>>>>>>> LIST */

/* MAP <<<<<<<<<<<< */
eml_map
:   TLBRACE eml_mapitems TRBRACE
/*|   TLBRACE TRBRACE empty map*/
;
eml_mapitems
:   eml_mapitems TCOMMA eml_mapitem
|   eml_mapitem
;

eml_mapitem
:   eml_keyvalue
;
/* >>>>>>>>>>> MAP */

%%