Based on https://github.com/sampsyo/llvm-pass-skeleton

# How to Run?
```
/usr/local/Cellar/llvm/3.7.1/bin/opt -load build/longstream/libLongstreamPass.so -longstream -S < add128.ll > add128-opt.ll
```
