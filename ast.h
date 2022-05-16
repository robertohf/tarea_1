#ifndef _AST_H
#define _AST_H

#include <iostream>
#include <memory>
#include <list>
#include <unordered_map>

class Expr;
class Stmt;

typedef Expr *ExprPtr;
typedef Stmt *StmtPtr;
typedef std::list<Stmt *> StmtList;

class Context {
public:
    explicit Context() {}
    int value;
    std::unordered_map<std::string, int> vars;
};

class AstNode {
public:
    AstNode() {}
    virtual ~AstNode() {}
};

class Expr: public AstNode {
public:
    Expr() {}
    virtual ~Expr() {}
    virtual int eval(Context &ctx) = 0;
};

class IntExpr : public Expr {
public:
    IntExpr(int value) : value(value) {}
    
    int value;
    int eval(Context &ctx) override;
};

class IdentExpr : public Expr {
public:
    IdentExpr(std::string id) : id(id) {}
    
    std::string id;
    int eval(Context &ctx) override;
};

#define BINARY_EXPR(name) \
class name##Expr: public Expr { \
public: \
    name##Expr(ExprPtr leftExpr, ExprPtr rightExpr) : leftExpr(std::move(leftExpr)), rightExpr(std::move(rightExpr)) {} \
    ExprPtr leftExpr, rightExpr; \
    int eval(Context &ctx) override; \
}; \

BINARY_EXPR(Add);
BINARY_EXPR(Sub);
BINARY_EXPR(Mult);
BINARY_EXPR(Div);

class Stmt : public AstNode {
public:
    Stmt() {}
    virtual ~Stmt() {}
    virtual void exec(Context &ctx) = 0;
    bool isTrue;
};

class BlockStmt : public Stmt {
public:
    BlockStmt(StmtList *stmtlist) : stmtlist(stmtlist) { }
    StmtList *stmtlist;
    void exec(Context &ctx) override;
    bool isTrue;
};

class AssignStmt : public Stmt {
public:
    AssignStmt(std::string id, ExprPtr rightExpr) : id(id), rightExpr(rightExpr) {}
    std::string id;
    ExprPtr rightExpr;
    void exec(Context &ctx) override;
};

class WriteStmt : public Stmt {
public:
    WriteStmt(ExprPtr expr) : expr(expr) {}
    ExprPtr expr;
    void exec(Context &ctx) override;
};

#endif