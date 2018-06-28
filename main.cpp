#include <iostream>

#include "Node.h"

using namespace std;

extern int yyparse();

int main(int argc, char **argv)
{
    int r = 0;
    r = yyparse();
    cout << "yyparse : " << r << endl;
    return r;
}