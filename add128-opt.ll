; ModuleID = '<stdin>'

@.str = private unnamed_addr constant [16 x i8] c"%016llx%016llx\0A\00", align 1

declare i32 @printf(i8*, ...)

define i32 @main() {
  %result = add i128 24376736269128437184639567244956479712, 57643874189567368763458875368743675743
  %lower64 = trunc i128 %result to i64
  %result_shifted = lshr i128 %result, 64
  %higher64 = trunc i128 %result_shifted to i64
  %1 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([16 x i8], [16 x i8]* @.str, i32 0, i32 0), i64 %higher64, i64 %lower64)
  ret i32 0
}
