#include "llvm/Pass.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/Transforms/IPO/PassManagerBuilder.h"
#include "llvm/Support/raw_ostream.h"

using namespace llvm;

namespace {
  struct LongstreamPass : public ModulePass {
    static char ID;
    LongstreamPass() : ModulePass(ID) {}

    virtual bool runOnModule(Module &m) {
      llvm::LLVMContext &c = m.getContext();
      Constant *cons = m.getOrInsertFunction("add128",
                                             Type::getIntNTy(c, 128),
                                             Type::getIntNTy(c, 128),
                                             Type::getIntNTy(c, 128),
                                             NULL);
      Function *func = cast<Function>(cons);

      IRBuilder<> functionBuilder(c);
      Function *main = m.getFunction("main");
      Function::iterator b = main->begin();
      BasicBlock::iterator bi = b->begin();
      functionBuilder.SetInsertPoint(b, bi);

      for (Function &f : m) {
        for (BasicBlock &bb : f) {
          for (Instruction &inst : bb) {
            if (inst.getOpcode() == Instruction::Add) {
              Value *op0 = inst.getOperand(0);
              Value *op1 = inst.getOperand(1);

              Type *type = op0->getType();
              if (type->isIntegerTy(128)) {
                IRBuilder<> builder(&inst);
                Value *call = builder.CreateCall(func, {op0, op1}, "");

                for (auto &u : inst.uses()) {
                  User *user = u.getUser();
                  user->setOperand(u.getOperandNo(), call);
                }
              }
            }
          }
        }
      }
      return true;
    }
  };
}

char LongstreamPass::ID = 0;
static RegisterPass<LongstreamPass> X("longstream", "Long Stream Pass", false, false);
