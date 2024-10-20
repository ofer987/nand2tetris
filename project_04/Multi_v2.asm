// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/6/rect/Rect.asm

// The product of R0 and R1, stored in R2
// R2 = R0 x R1
// E.g., R2 = 0 x 0 = 0
// E.g., R2 = 1 * 0 = 0
// E.g., R2 = 1 * 2 = 2
// E.g., R2 = 2 * 6 = 12
// E.g., R2 = 6 * 2 = 12

  // Result
  @R8
  M=0

  @R0
  D=M

  @END
  D;JLE

  // Iterator (i)
  @R7
	@n
  M=D

(LOOP)
  // Result
  @R1
  D=M

  @R8
  M=D+M

  @n
	MD=M-1

  @LOOP
  D;JGT

  // Store the Result in @R2
  @R8
  D=M

  @R2
  M=D

(END)
  @END
  0;JMP
