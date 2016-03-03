This is a very simple LLVM pass. It replaces the `add` between two `i128`s with a call to `add128`. We can then link it with `add128-def.s`, which contains a `add128` function using long stream addition. 

Based on [https://github.com/sampsyo/llvm-pass-skeleton](https://github.com/sampsyo/llvm-pass-skeleton).

# How to Run?

```
pushd build
cmake ..
make
popd

# Run the original version
llc add128.ll
clang -o add128 add128.s
./add128

# Run the long stream addition version
opt -load build/longstream/libLongstreamPass.so -longstream -S < add128.ll > add128-opt.ll
llc add128-def.ll
llc add128-opt.ll
clang -o add128-opt add128-opt.s add128-def.s
./add128-opt
```
