#include "llvm/Pass.h"
#include "llvm/IR/Module.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/Transforms/IPO/PassManagerBuilder.h"

using namespace llvm;

namespace {
  struct LongstreamPass : public ModulePass {
    static char ID;
    LongstreamPass() : ModulePass(ID) {}

    virtual bool runOnModule(Module &m) {
      errs() << "Holy Crap!!!\n";
      return true;
    }
  };
}

char LongstreamPass::ID = 0;
static RegisterPass<LongstreamPass> X("longstream", "Long Stream Pass", false, false);
