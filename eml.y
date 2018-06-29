%{

#include <iostream>
#include "Node.h"

EBlocks *emlBody;

extern int yylex();
void yyerror(const char *s) { std::cout << s << std::endl; }

%}

%error-verbose

%union {
    ENode           *node;
    EBlocks         *eml_blocks;
    EBlock          *eml_block;
    std::string     *string;
    int             token;
}

%token <string> TIDENTIFIER TWIDGET TSTRING TNUMBER TON TREPLACER
%token <token> TLBRACKET TRBRACKET TLBRACE TRBRACE TLPAREN TRPAREN
%token <token> TCOL TEND TCOMMA TSCOL TEQUAL TREPEATER TDOT


%type <eml_blocks> eml_blocks eml
%type <eml_block> eml_block
%start eml

%%

/* EML <<<<<<<<<<<< */
eml
:   eml_blocks                                                  { emlBody = $1; }
/* EML >>>>>>>>>>>> */


/* BLOCK <<<<<<<<<<<< */
eml_blocks
:   eml_blocks eml_block                                        { $1->blockList.push_back($<eml_block>2); std::cout << "append block" << std::endl; }
|   eml_block                                                   { $$ = new EBlocks(); $$->blockList.push_back($<eml_block>1); std::cout << "new block" << std::endl; }
;

eml_block
:   eml_object
|   eml_property TSCOL
|   eml_property
|   eml_callback
|   eml_repeater
;

eml_callbackblocks
:   eml_callbackblocks eml_callbackblock
|   eml_callbackblock
;

eml_callbackblock
:   eml_callbackproperty TSCOL
|   eml_callbackproperty
;
/* >>>>>>>>>>> BLOCK */



/* OBJECT <<<<<<<<<<<< */
eml_object
:   eml_list TCOL eml_name_ns TLBRACE eml_blocks TRBRACE
|   eml_list TCOL eml_name_ns TLBRACE TRBRACE
|   eml_name_ns TLBRACE eml_blocks TRBRACE
|   eml_name_ns TLBRACE TRBRACE
;
/* >>>>>>>>>>> OBJECT */



/* PROPERTY <<<<<<<<<<<< */
eml_property
:   eml_name_ns
|   eml_keyvalue
;

eml_callbackproperty
:   eml_keyvalue
|   eml_name_ns
|   eml_name_ns eml_name_ns
;
/* >>>>>>>>>>> PROPERTY */



/* CALLBACK <<<<<<<<<<<< */
eml_callback
:   TON  TLBRACE eml_callbackblocks TRBRACE
|   TON  TLBRACE TRBRACE
;
/* >>>>>>>>>>> CALLBACK */



/* REPEATER <<<<<<<<<<<< */
eml_repeater
:   eml_repeaterbase TLBRACE eml_object TRBRACE
;

eml_repeaterbase
: TREPEATER TLPAREN eml_repeater_specs TRPAREN
;

eml_repeater_specs
:   eml_repeater_specs TCOMMA eml_repeater_spec
|   eml_repeater_spec
;

eml_repeater_spec
:   TNUMBER TCOMMA TNUMBER TEQUAL eml_list
|   TNUMBER TEQUAL eml_list
|   TNUMBER
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
:   eml_key TCOL eml_value
;

eml_key
:   eml_name_ns
|   eml_name_ns TLBRACKET TSTRING TRBRACKET
|   eml_name_ns TLBRACKET eml_name_ns TRBRACKET
;

eml_value
:   eml_name_ns
|   TSTRING
|   TNUMBER
|   TREPLACER
|   eml_list
|   eml_map

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