all: eml eml_dbg

parser.cpp: eml.y
	bison --debug -v -d -o parser.cpp eml.y

tokens.cpp: eml.l
	flex -o tokens.cpp eml.l

tokens.dbg.cpp: eml.l
	flex -d -o tokens.dbg.cpp eml.l

eml: parser.cpp  tokens.cpp main.cpp
	g++ -o eml_parser main.cpp parser.cpp tokens.cpp

eml_dbg: parser.cpp tokens.dbg.cpp main.cpp
	g++ -o eml_parser_dbg main.cpp parser.cpp tokens.dbg.cpp

clean:
	rm eml_parser eml_parser_dbg parser.cpp parser.hpp tokens.cpp tokens.dbg.cpp parser.output
