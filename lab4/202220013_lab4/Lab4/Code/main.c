#include "intermediate.h"
#include "mips.h"
void perror(const char *__s);
int yyrestart();
int yyparse();
int yydebug;
extern unsigned char right;
extern unsigned char right;
extern unsigned char semright;
extern unsigned char interight;
extern Node *root;
extern TableList *hashTable[HASHSIZE];
extern int syserr, myerr;
bool opt=false;
int main(int argc, char **argv)
{
    if (argc <= 1)
        return 1;
    FILE *f = fopen(argv[1], "r");
    if (!f)
    {
        perror(argv[1]);
        return 1;
    }
    yyrestart(f);
    yydebug = 1;
    yyparse();
    if (right)
    {
        init_table();
        semantic_check(root);
        if (semright) {
            setVariable();
            initInterCodes();
            tranProgram(root);
            if (interight) {
                writeInterCodes(argv[2], opt);
                initOffset();
                code_generate(argv[2]);
                
            }
        }
        //semantic_check(root);
        //outPut(root, 0);
        //print_table();
    }
    return 0;
}
