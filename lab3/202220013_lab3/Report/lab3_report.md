## 编译原理 Lab3

202220013 徐简

#### 项目环境:

1. GNU LINUX Realease: Ubuntu 
2. GCC version: 7.5.0
3. GNU Flex version:2.6.4
4. GNU Bison version: 3.0.4

#### 实现的功能

###### 中间代码生成

- 完成了必做
- 完成了选做1，即可以出现结构体变量（未完成选做2）

#### 代码实现

- 首先添加read和write函数的信息(添加READ和WRITE枚举类型即可)

```c
struct InterCode {
    enum { LABEL, FUNCTION, ASSIGN, ADD, SUB, MUL, DIV, GOTO, IF, RETURN, DEC, ARG, CALL, PARAM, READ, WRITE } kind;
 //...
};
```

- 按照实验手册中推荐的方法，采用双向链表来记录中间代码

```c
struct InterCode {
	//...	
};

struct InterCodes {
    InterCode code;
    bool isDelete;
    InterCodes *prev, *next;
  	//双向链表的头尾结点
};
```

- 根据手册中的翻译模式，实现各翻译函数translate_X

```c
void translate_Program(Node* node);
void translate_ExtDefList(Node* node);
void translate_ExtDef(Node* node);
//...

//根据lab2的到的分析树，进行翻译
void translate_Program(Node* node)
{
    translate_ExtDefList(node->child);
}
```

- 一系列函数，实现双向链表的建立，主要的操作是设置InterCode的属性，并加入到双向链表中

```c
void createAssign(unsigned type, Operand* left, Operand* right);
void createBinaryOp(unsigned kind, unsigned type, Operand* res, Operand* op1, Operand* op2);
void createSingleOp(unsigned kind, Operand* res, Operand* op);
void createSingle(unsigned kind, Operand* op);
void createCond(Operand* op1, Operand* op2, Operand* target, char* re);
void createDec(Operand* op, unsigned size);

```

- 将得到的中间代码，输出到文件中

```c
void writeInterCodes(const char* fielname)
{
    InterCodes* p = head->next;
    FILE* f = fopen(fielname, "w");
    while (p) {
      //fprintf 写入文件
    }
    fclose(f);
}
```

- 结构体实现，用count Size函数来计算每个Type的大小，对于结构体，则递归地将结果相加返回，从而确定要申请的空间的大小。这样可以实现对结构体中每个成员的表示。测试用例3就说明了这一原理（结构体中含有两个int型的变量）。

```c
unsigned countSize(Type* type)；
```

![Screen Shot 2021-12-04 at 22.11.59](/Users/kirakiraakira/Desktop/Screen Shot 2021-12-04 at 22.11.59.png)

###### 测试

- 手册测试样例运行截图如下

test1

![Screen Shot 2021-12-04 at 21.52.17](/Users/kirakiraakira/Desktop/Screen Shot 2021-12-04 at 21.52.17.png)

test2

![Screen Shot 2021-12-04 at 21.52.25](/Users/kirakiraakira/Desktop/Screen Shot 2021-12-04 at 21.52.25.png)

test3

![Screen Shot 2021-12-04 at 21.52.30](/Users/kirakiraakira/Desktop/Screen Shot 2021-12-04 at 21.52.30.png)

test4(未实现数组)

![Screen Shot 2021-12-04 at 21.50.48](/Users/kirakiraakira/Desktop/Screen Shot 2021-12-04 at 21.50.48.png)

- 在IR Simulator中运行截图如下

![Screen Shot 2021-12-04 at 21.58.25](/Users/kirakiraakira/Desktop/Screen Shot 2021-12-04 at 21.58.25.png)



###### 使用方法

使用makefile完成编译、运行：

- `make`, `make clean`
- 测试使用命令`./parser ../Test/test1.cmm out1.ir`。中间代码会被保存到当前目录的`outxxx.ir`中



###### 实验思考

- debug花了很多时间，但是测试用例的强度还是太低了。
- 时间原因，也没有做中间代码生成的优化，实验四有机会再尝试。

