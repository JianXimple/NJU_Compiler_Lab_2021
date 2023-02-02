#include "semantic.h"
#include <stdbool.h>

typedef struct Operand_ Operand;
typedef struct InterCode InterCode;
typedef struct InterCodes InterCodes;

struct Operand_ {
    enum { VARIABLE, TEMP, PARAMETER, CONSTANT, LAB, FUNCT } kind;
    enum { VAL, ADDRESS} type;
    union {
        int var_no;
        long long int value;
        char* func_name;
    } u;
};

struct InterCode {
    enum { LABEL, FUNCTION, ASSIGN, ADD, SUB, MUL, DIV, GOTO, IF, RETURN, DEC, ARG, CALL, PARAM, READ, WRITE } kind;
    enum { NORMAL, GETADDR, GETVAL, SETVAL, COPY } type;
    union {
        struct {
            Operand *left, *right;
        } assign;
        struct {
            Operand *res, *op1, *op2;
        } binaryop;
        struct {
            Operand *res, *op;
        } singleop;
        struct {
            Operand* op;
        } single;
        struct {
            Operand *op1, *op2, *target;
            char relop[4];
        } cond;
        struct {
            Operand* op;
            unsigned size;
        } dec;
    } u;
};

struct InterCodes {
    InterCode code;
    bool isDelete;
    InterCodes *prev, *next;
};

void initInterCodes();
void setVariable();
Operand* newConst(long long int val);
void createAssign(unsigned type, Operand* left, Operand* right);
void createBinaryOp(unsigned kind, unsigned type, Operand* res, Operand* op1, Operand* op2);
void createSingleOp(unsigned kind, Operand* res, Operand* op);
void createSingle(unsigned kind, Operand* op);
void createCond(Operand* op1, Operand* op2, Operand* target, char* re);
void createDec(Operand* op, unsigned size);
char* printOperand(Operand* op);
void writeInterCodes(const char* fielname);

void translate_Cond(int id, Node* node, Operand* label_true, Operand* label_false);
void translate_Exp(Node* node, Operand* place);
void translate_Args(Node* node, Operand* arg_list[], int index);
void translate_Compst(Node* node);

void translate_Program(Node* node);
void translate_ExtDefList(Node* node);
void translate_ExtDef(Node* node);
void translate_FunDec(Node* node);
void translate_CompSt(Node* node);
void translate_VarDec(Node* node, int isFunc, int isStruct);
void translate_DefList(Node* node);
void translate_VarList(Node* node, int isFunc);
void translate_ParamDec(Node* node, int isFunc);
void translate_StmtList(Node* node);
void translate_Stmt(Node* node);
void translate_Def(Node* node);
void translate_DecList(Node* node, int isStruct);
void translate_Dec(Node* node, int isStruct);
