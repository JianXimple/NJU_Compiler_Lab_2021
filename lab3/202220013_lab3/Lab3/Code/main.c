#include "intermediate.h"

void perror(const char* __s);
int yyrestart();
int yyparse();
int yydebug;
extern unsigned char right;
extern unsigned char semright;
extern unsigned char intermediate_right;
extern Node* root;
extern TableList* hashTable[HASHSIZE];
extern int syserr, myerr;

int main(int argc, char** argv)
{
    if (argc <= 1)
        return 1;
    FILE* f = fopen(argv[1], "r");
    if (!f) {
        perror(argv[1]);
        return 1;
    }
    yyrestart(f);
    yydebug = 1;
    yyparse();
    //词法error right=0
    if (right) {
        initTable();
        //初始化Table 记录read write
        Program(root);
        if (semright) {
            setVariable();
            initInterCodes();
            translate_Program(root);
            if (intermediate_right) {
                
                writeInterCodes(argv[2]);
            }
        }
    }
    return 0;
}
