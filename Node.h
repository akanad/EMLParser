#ifndef NODE_H
#define NODE_H
#include <iostream>
#include <vector>

class ENode {
public:
    virtual ~ENode() {}
};

class EBlock;

typedef std::vector<EBlock*>  EBlockList;

class EBlocks : public ENode {
    public:
        EBlocks(){}
        EBlockList blockList;
};

class EBlock : public ENode {
    public:
        int object;
        int property;
        int callback;
        int repeater;
};
#endif