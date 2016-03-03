define i128 @add128(i128 %add1, i128 %add2) {
entry:
    %X = bitcast i128 %add1 to <2 x i64>
    %Y = bitcast i128 %add2 to <2 x i64>
    %R = add <2 x i64> %X, %Y

    ; signmask
    %x = icmp slt <2 x i64> %X, <i64 0, i64 0>
    %y = icmp slt <2 x i64> %Y, <i64 0, i64 0>
    %r = icmp slt <2 x i64> %R, <i64 0, i64 0>

    ; c = (x and y) or ((x or y) and not r)
    %x_and_y = and <2 x i1> %x, %y
    %x_or_y = or <2 x i1> %x, %y
    %not_r = xor <2 x i1> %r, <i1 1, i1 1>
    %x_or_y__and__not_r = and <2 x i1> %x_or_y, %not_r
    %c = or <2 x i1> %x_and_y, %x_or_y__and__not_r

    ; b = if all 64 bits are 1
    %b = icmp eq <2 x i64> %R, <i64 -1, i64 -1>

    ; i = MatchStar(c * 2, b)
    %c_i2 = bitcast <2 x i1> %c to i2
    %M = mul i2 %c_i2, 2
    ; MatchStar(M, C) = (((M ∧ C) + C) ⊕ C)|M
    %C = bitcast <2 x i1> %b to i2
    %M_and_C = and i2 %M, %C
    %M_and_C__add__C = add i2 %M_and_C, %C
    %M_and_C__add__C___xor___C = xor i2 %M_and_C__add__C, %C
    %i = or i2 %M_and_C__add__C___xor___C, %M
    
    ; S = zext <N x i1> i to <N x i64>
    %i_vec = bitcast i2 %i to <2 x i1>
    %S = zext <2 x i1> %i_vec to <2 x i64>

    ; Z = add <N x i64> R, S
    %Z = add <2 x i64> %R, %S

    %result = bitcast <2 x i64> %Z to i128
    ret i128 %result
}
