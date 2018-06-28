# EML
EML is a kind of a meta language to describe the UI for an EFL application.

you can find out more information here(http://eyomi.org/mediawiki/index.php/EML)


# Prerequisites
running below command will be ok if you use ubuntu.

$ sudo apt install build-essential flex bison


# How to use 
$ make

$ cat some_ea_file.ea | eml_parser

or you are able to parse with a dbg mode enabled parser like below

$ cat some_ea_file.ea | eml_parser_dbg
