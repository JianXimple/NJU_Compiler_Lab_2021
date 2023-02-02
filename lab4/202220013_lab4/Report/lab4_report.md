## 编译原理 Lab4

202220013 徐简

#### 项目环境:

1. GNU LINUX Realease: Ubuntu 
2. GCC version: 7.5.0
3. GNU Flex version:2.6.4
4. GNU Bison version: 3.0.4

#### 实现的功能

###### 目标代码生成

- 完成了必做要求
- 对手册提供的测试样例进行了测试模拟

#### 代码实现

​	实验4的代码，除了debug时修改了之前的一些漏洞之外，集中在`mips.c`

- 在语义分析部分，将`read`函数和`write`函数初始化进符号表

```c
void initTable()
{
    for (int i = 0; i < HASHSIZE + 1; ++i) {
        hashTable[i] = NULL;
    }
...
    item->name = "read";
...
    insert(item);
...
    item->name = "write";
...
    insert(item);
}
```

- 在目标代码生成部分，首先将头部信息输出到文件中

```c
#define PRECODE "..."
FILE* f = fopen(fielname, "w");
fprintf(f, PRECODE);
```

- 指令选择部分，遍历中间代码，进行模式匹配

```c
extern InterCodes* head;
InterCodes* p = head->next;
while (p) {
        p = p->next;
  			...
        ...	
    }
fclose(f);
```

- 寄存器分配采用了朴素寄存器分配算法

  将所有的变量或者临时变量都放在内存里，每次生成代码的时候，将将变量读入寄存器中，计算完成后，再将结果写回内存。

- 为了实现这样的机制，引入了记录数据偏移量的数组`varOffset`,根据类型遍历中间代码，得到varOffset。

  ```c
  //初始化
  int n = varCount + tmpCount - 1;
  varOffset = (int*)malloc(sizeof(int) * n);
  for (int i = 0; i < n; i++) {
    varOffset[i] = -1;
  }
  //计算VarOffset
  
  int allocVar(InterCodes* begin)
  {
      int fpoffset = 4;
      InterCodes* p = begin;
      while (p && p->code.kind != FUNCTION) {
          ...
          ...
          p = p->next;
      }
      return fpoffset;
  }
  
  ```

- 最后再遍历中间代码完成翻译，用偏移量完成正确的变量读取和写入

###### 测试

- 手册测试样例运行截图如下
- Test1.cmm

![Screen Shot 2022-01-09 at 19.11.03](/Users/kirakiraakira/Desktop/Screen Shot 2022-01-09 at 19.11.03.png)

- Test2.cmm

![Screen Shot 2022-01-09 at 22.52.28](/Users/kirakiraakira/Desktop/Screen Shot 2022-01-09 at 22.52.28.png)

###### 使用方法

使用makefile完成编译、运行：

- `make`, `make clean`
- 测试使用命令`./parser ../Test/test1.cmm out1.s`。中间代码会被保存到当前目录的`outxxx.s`中



###### 实验思考

- 为了确保跑通代码生成，只完成了最基础的寄存器分配方法，效率很低，只用到了两个寄存器，而且需要大量的寄存器内存读取操作，这在实际的应用中是不允许发生的
- 时间原因，只对手册的样例进行了测试，所以不知道对于有更加复杂的数据结构和函数调用的情况下，当前的代码能否胜任

