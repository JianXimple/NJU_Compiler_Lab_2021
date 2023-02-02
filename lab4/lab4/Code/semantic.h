#include <stdio.h>
#include "node.h"
#define HASHSIZE 0x3fff

typedef struct Operand_ Operand;



struct Type_ {
    enum { INT, FLOAT, ARRAY, STRUCTURE,STRUCTVAR,  FUNC, WRONGFUNC } kind;
    union {
        //基本类型
        int basic;
        //数组类型信息包括元素类型与数组大小
        struct
        {
            Type* elem;
            int size;
        } array;
        //结构体类型信息是一个链表
        FieldList* structure;
        FieldList* structvar;
        //函数类型信息
        struct
        {
            Type* ret;
            int argc;
            FieldList* args;
        } function;
    } u;
};

struct FieldList_ {
    char* name; //域的名字
    Type* type; //域的类型
    FieldList* tail; //下一个域
};

struct TableList_ {
    char* name;
    Type* type;
    unsigned size;
    Operand* op;
    TableList* next;
};

unsigned hash_pjw(char *name);
void init_table();
TableList* search(char* name);
void insert(TableList* item);

int cmp_structure(FieldList* s1, FieldList* s2);
int cmp_array(Type* t1, Type* t2);
int cmp_function(FieldList* arg1, FieldList* arg2);

void semantic_check(Node *node);
void ExtDefList(Node *node);
void ExtDef(Node *node);
void Specifier(Node *node);
void ExtDecList(Node *node);
void FunDec(Node *node);
void CompSt(Node *node);
void VarDec(Node *node);
void StructSpecifier(Node *node);
void OptTag(Node *node);
void DefList(Node *node);
void Tag(Node *node);
void VarList(Node *node);
void ParamDec(Node *node);
void StmtList(Node *node);
void Stmt(Node *node);
void Exp(Node *node);
void Def(Node *node);
void DecList(Node *node);
void Dec(Node *node);
void Args(Node *node);

void print_table();
void log_error(int type, int line, char *msg);
