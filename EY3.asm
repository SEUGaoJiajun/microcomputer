;*************************;
;*  8253方式0计数器实验  *;
;*************************;
ioport		equ 3100h-0280h	;通过查看计算机给实验设备分配的内存计算基址
io8253a		equ ioport+283h
io8253b		equ ioport+280h
code segment
	assume  cs:code
start: mov al,10h       ;设置8253通道0为工作方式2,二进制计数
	 mov dx,io8253a		;dx存入的是控制寄存器的地址
	 out dx,al			;将控制字写入控制寄存器
	 mov dx,io8253b      ;送计数初值为0FH，dx存入的是计数器0的地址
	 mov al,0fh
	 out dx,al			;将计数初值送到计数器0
lll:  in al,dx         ;读计数初值
	 call disp        ;调显示子程序
	 push dx			;dx值入栈保护    
	 mov ah,06h			;功能号为06h的中断，直接控制台I/O，DL=0ffh表示输入
	 mov dl,0ffh
	 int 21h
	 pop dx
	 jz lll				;结果为零的时候跳到111处继续执行，有键按下则准备结束
	 mov ah,4ch       ;退出，返回DOS中断
	 int 21h
disp   proc near        ;显示子程序
	 push dx
	 and al,0fh       ;取低四位
	 mov dl,al
	 cmp dl,9         ;判断是否<=9
	 jle  num         ;若是则为'0'-'9',ASCII码加30H
	 add dl,7         ;否则为'A'-'F',ASCII码加37H
num:     add dl,30h
	 mov ah,02h       ;显示，DL存入的是待显示字符
	 int 21h			
	 mov dl,0dh       ;加回车符
	 int 21h
	 mov dl,0ah       ;加换行符
	 int 21h
	 pop dx
	 ret              ;子程序返回
disp endp
code ends
end start
