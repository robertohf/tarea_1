#include "ast.h"

#define BINARY_EXPR_EVAL(name, op) \
int name##Expr::eval(Context &ctx) { \
    return leftExpr->eval(ctx) op  rightExpr->eval(ctx); \
} \

BINARY_EXPR_EVAL(Add, +);
BINARY_EXPR_EVAL(Sub, -);
BINARY_EXPR_EVAL(Mult, *);
BINARY_EXPR_EVAL(Div, /);

int IntExpr::eval(Context &ctx) {
    ctx.value = value;
    return ctx.value;
}

int IdentExpr::eval(Context &ctx) {
    return ctx.vars[id];
}

void BlockStmt::exec(Context &ctx) {
    for (auto &it : *stmtlist) 
        it->exec(ctx);
}

void AssignStmt::exec(Context &ctx) {
    ctx.vars[id] = rightExpr->eval(ctx);
}

void WriteStmt::exec(Context &ctx) {
    std::cout << expr->eval(ctx) << std::endl;
}