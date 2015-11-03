# vim: syntax=mips:
# David Karwowski
# Program #9 - Conway's Game of Life

# Life  - Take a board and calculate the next state for each square
#   RULES:
#       - alive & <2 neighbors  -> die
#       - alive & 2-3 neighbors -> live
#       - alive & >3 neighbors  -> die
#       - dead  & =3 neighbors  -> live

# Parameters
# $a0   - The board
# $v0   - the new board
Life:
        # save return register
        addi    $sp, $sp, -40
        sw      $ra, 0x00 ($sp)
        sw      $s0, 0x04 ($sp)
        sw      $s1, 0x08 ($sp)
        sw      $s2, 0x0C ($sp)
        sw      $s3, 0x10 ($sp)
        sw      $s4, 0x14 ($sp)
        sw      $s5, 0x18 ($sp)
        sw      $s6, 0x1C ($sp)

        # check for errors (address out of range)
        blt     $a0, 0x10008000, error
        bgtu    $a0, 0x7FFFFFDC, error

        # check for unaligned addresses
        li      $t0, 0x4
        divu    $a0, $t0                    # $HI = address % 4
        mfhi    $t0                         # $t0 = address % 4
        bne     $t0, $0, error              # raise an error

        # store old board
        sw      $a0, 0x20 ($sp)             # 0x20 ($sp) = old board

        # check the column and row numbers
        lw      $s0, 0 ($a0)                # $s0 = rows
        ble     $s0, $0, error              # if (rows <= 0) error
        lw      $s1, 4 ($a0)                # $s1 = columns
        ble     $s1, $0, error              # if (cols <= 0) error

        # unsigned int bits = rows * cols
        mul     $t2, $s0, $s1               # $t2 = rows * cols
        # unsigned int bytes = bits/8 + (bits%8>0);
        li      $t3, 8                      # $t3 = 8
        div     $t2, $t3                    # $LO = bytes, $HI = bits
        mflo    $a0                         # $a0 = bits/8
        mfhi    $t3                         # $t3 = bits%8
        sgt     $t4, $t3, $0                # $t4 = ($t3 > 0) ? 1 : 0
        add     $a0, $a0, $t4               # $a0 += (bits%8 > 0)
        addi    $a0, $a0, 8                 # $a0 += 8 (sizeof(word)*2)
        li      $v0, 0x9                    # syscall 9 (allocate on heap)
        syscall

        move    $t0, $v0
        sw      $s0, 0 ($t0)
        sw      $s1, 4 ($t0)
        sw      $t0, 0x24 ($sp)             # 0x24 ($sp) = new board

        # for (int y = 0; y < rows; y++) {
        li      $s2, 0                      # $s2 = y
fory_loop:
        bge     $s2, $s0, fory_done

        # .for (int x = 0; x < cols; x++) {
        li      $s3, 0                      # $s3 = x
forx_loop:
        bge     $s3, $s1, forx_done

        # ..int surround = 0;
        li      $s6, 0                      # $s6 = surround

        # ..for (int i = -1; i < 2; i++) {
        li      $s4, -1
fori_loop:
        li      $t0, 2
        bge     $s4, $t0, fori_done

        # ...for (int j = -1; j < 2; j++) {
        li      $s5, -1
forj_loop:
        li      $t0, 2
        bge     $s5, $t0, forj_done

        # ....if (j != 0 || i != 0) {
        seq     $t0, $s4, $0                # $t0 = (j==0)
        seq     $t1, $s5, $0                # $t1 = (i==0)
        and     $t0, $t0, $t1               # $t0 = (j==0 && i==0)
        bne     $t0, $0, else_not_this

        # .....int temp = get(old, x+j, y+i);
        lw      $a0, 0x20 ($sp)             # $a0 = old board
        add     $a1, $s3, $s5               # $a1 = x + j
        add     $a2, $s2, $s4               # $a2 = y + i
        jal     get_pos                     # $v0 = get(old, x+j, y+i);

        # .....surround += temp;
        add     $s6, $s6, $v0               # $s6 += temp

        # ....}
else_not_this:

        # ...}
        addi    $s5, $s5, 1
        beq     $0, $0, forj_loop
forj_done:

        # ..}
        addi    $s4, $s4, 1
        beq     $0, $0, fori_loop
fori_done:

        # ..int temp = get(old, x, y);
        lw      $a0, 0x20 ($sp)             # $a0 = old board
        add     $a1, $s3, $0                # $a1 = x
        add     $a2, $s2, $0                # $a2 = y
        jal     get_pos                     # $v0 = get(old, x, y);

        # ..if (temp) {
        beq     $v0, $0, else_dead
        # ...if (2 == surround || surround == 3)
        li      $t0, 2
        seq     $t0, $t0, $s6               # $t0 = (2 == surround)
        li      $t1, 3
        seq     $t1, $t1, $s6               # $t1 = (3 == surround)
        or      $t0, $t0, $t1               # $t0 = (2 == surround) || (3 == surround)
        beq     $t0, $0, continue
        
        # ....set(new, x, y, 1);
        lw      $a0, 0x24 ($sp)             # $a0 = new board
        add     $a1, $s3, $0                # $a1 = x
        add     $a2, $s2, $0                # $a2 = y
        li      $a3, 1                      # $a3 = 1
        jal     set_pos
        # ...}
        beq     $0, $0, continue
        # ..}
        # ..else {
else_dead:
        # ...if (surround == 3) {
        li      $t0, 3                      # $t0 = 3
        bne     $s6, $t0, continue
        # ....set(new, x, y, 1);
        lw      $a0, 0x24 ($sp)             # $a0 = new board
        add     $a1, $s3, $0                # $a1 = x
        add     $a2, $s2, $0                # $a2 = y
        li      $a3, 1                      # $a3 = 1
        jal     set_pos
        # ...}
        # ..}
continue:
        # .}
        addi    $s3, $s3, 1
        beq     $0, $0, forx_loop
forx_done:

        # }
        addi    $s2, $s2, 1
        beq     $0, $0, fory_loop
fory_done:
        # return result
        lw      $v0, 0x24 ($sp)
        beq     $0, $0, return

error:  # there was a problem, make sure we return a null
        move    $v0, $0
        beq     $0, $0, return
        
return: # get outta here
        lw      $ra, 0 ($sp)
        lw      $s0, 4 ($sp)
        lw      $s1, 8 ($sp)
        lw      $s2, 12 ($sp)
        lw      $s3, 16 ($sp)
        lw      $s4, 20 ($sp)
        lw      $s5, 24 ($sp)
        lw      $s6, 28 ($sp)
        addi    $sp, $sp, 40

        jr      $ra

# get(board $a0, x $a1, y $a2)
# get a position from the board
#   Assumes board has been verified accurate, checks bounds
# return:
#   $v0 = 0 or 1, -1 if error
get_pos:
        addi    $sp, $sp, -4
        sw      $ra, 0 ($sp)

        li      $a3, -1                     # -1 val means we get the masked value
        jal     set_pos

        blt     $v0, $0, return_get         # return an error if there was one
        sgt     $v0, $v0, $0                # ensure we return just 0 or 1

return_get:
        lw      $ra, 0 ($sp)
        addi    $sp, $sp, 4
        jr      $ra

# set(board $a0, x $a1, y $a2, val $a3)
# set board[x][y] = val
#   Assumes valid board, checks values
#   Returns the position masked if val<0
set_pos:
        # get the columns and rows
        lw      $t9, 0 ($a0)
        lw      $t8, 4 ($a0)                # $t8 = cols

        # adjust x and y within bounds
        div     $a1, $t8
        mfhi    $a1
        div     $a2, $t9
        mfhi    $a2

        bge     $a1, $0, set_a2
        add     $a1, $t8, $a1               # $a1 += cols
set_a2:
        bge     $a2, $0, set_cont
        add     $a2, $t9, $a2               # $a2 += rows

set_cont:
        # get how many bytes in
        mul     $t1, $t8, $a2               # $t1 = cols * y
        add     $t1, $t1, $a1               # $t1 = x + cols*y
        li      $t2, 8                      # $t2 = 8 (bits in byte)
        div     $t1, $t2                    # $LO = bytes in, $HI = bits in
        mflo    $t0                         # $t0 = bytes
        mfhi    $t1                         # $t1 = bits

        # loop $t0 times to get to the right byte
        li      $t2, 0                      # $t2 = 0 (i=0)
        addi    $t3, $a0, 8                 # $t3 = array[0]
set_loop_byte:
        beq     $t2, $t0, set_bits          # if ($t2 == $t0) goto bits
        la      $t3, 1 ($t3)                # $t3 = ($t3)[i+1]
        addi    $t2, $t2, 1                 # $t2 += 1 (i+=1)
        beq     $0, $0, set_loop_byte

        # set bitmask to the right element
set_bits:
        li      $t2, 0                      # $t2 = 0 (i=0)
        lbu     $t4, 0 ($t3)                # $t4 = byte
        li      $t5, 0x80                   # $t5 = mask (start at highest)
set_loop_bits:
        beq     $t2, $t1, done_set          # if ($t2 == $t1) goto done_set
        srl     $t5, $t5, 1                 # $t5 = $t5 >> 1 (shift mask over one)
        addi    $t2, $t2, 1                 # $t2 += 1 (i+=1)
        beq     $0, $0, set_loop_bits

        # make sure the bit is set
done_set:
        blt     $a3, $0, mask_set           # if (val < 0) goto mask_set
        not     $t6, $t5                    # not the mask (we want the opposite
        and     $v0, $t4, $t6               # $v0 = $t4 & $t6 (remove the bit we're changing)
        beq     $a3, $0, store_set          # $a3 == 0, return $v0
        or      $v0, $v0, $t5               # $v0 |= $t5
        beq     $0, $0, store_set

mask_set:
        and     $v0, $t4, $t5               # $v0 = byte & mask
        beq     $0, $0, return_set

error_set:
        li      $v0, -1
        beq     $0, $0, return_set

store_set:
        sb      $v0, 0 ($t3)                # *$t3 = $v0
        li      $v0, 0                      # return 0 for proper value
return_set:
        jr      $ra

