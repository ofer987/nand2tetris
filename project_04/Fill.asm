// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/6/rect/Rect.asm

// When key is pressed down, then change the pixel from White to Black.
// When no key is pressed down, then every pixel is colored White.

(START)

	@R8
	@current_color
	// The default color is White
	M=0

(RESTART)
	@current_color
	D=M

	@R4
	M=D

	@SCREEN
	D=A

	@R9
	@addr
	M=D

	// Columns
	@8192
	D=A

	@R7
	@columns
	M=D

(LOOP_COLUMNS)

	@KBD
	D=M

	@R2
	@keyboard
	M=D

	@IS_ONE
	D;JGT

	@current_color
	MD=0
	
(IS_ZERO)

	@R4
	D=D-M

	@SKIP_IS_ONE
	D;JLE

	@RESTART
	0;JMP

(IS_ONE)
	@current_color
	MD=-1

	@R4
	D=M-D
	
	@RESTART
	D;JGT

(SKIP_IS_ONE)

	@current_color
	D=M

	@addr
	A=M
	M=D

	@addr
	D=M

	// Next Word
	@1
	D=D+A

	@addr
	M=D

	@columns
	MD=M-1

	@LOOP_COLUMNS
	D;JGT

	@START
	0;JMP

(END)
	@END
	0;JMP
