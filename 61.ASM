data segment
ioport equ 3100h-0280h;查看计算机给实验设备分配的内存计算基址
io8255a equ ioport+28ah;c口地址
io8255b equ ioport+28bh;控制寄存器地址
io82558 equ ioport+288h;A口地址
portc1 db 24h,44h,04h,44h,04h.44h,04h;六个交通灯可能的状态数据
db 81h,82h,80h,82h,80h,82h,80h
db 0ffh;结束标志
led db 3fh,06h,5bh;数码管显示0，1,2所需要的输出
buffer db 2;存放要显示的个位和十位
data ends
code segment
	assume cs:code,ds:data
start:	mov ax,data
		mov ds,ax
		mov dx,io8255b
        mov al,80h
		out dx,al;将A口设为输出，工作于方式0，c口为输出
		mov dx,io8255a
		mov di,offset buffer;di为显示缓冲区
re_on:	mov bx,0
on:		mov al,portc1[bx];读取相应的交通灯状态
		cmp al,0ffh;判断是否读到结尾
		jz re_on;若读到结尾处则重复上述过程
		out dx,al;点亮相应的灯
		inc bx;为读下一个状态做准备
		mov cx,6fffh

		test al,21h;判断是否有绿灯亮
		jnz continue;若有绿灯，则不对buffer操作
		add byte ptr buffer,1;没有绿灯buffer+1
		cmp byte ptr buffer,3;比较buffer和3,
		jne continue;buffer不为3则跳过buffer置0指令
		mov byte ptr buffer,0;buffer置零

		test al,21h;若没有绿灯，短延时（跳过cx赋大数的指令）
		jz de1
continue:mov cx,0ffffh
de1:	push bx;bx指向下一数据，需要入栈保护
		mov bl,[di]      ;bl中为待显示的数字
		mov bh,0
		mov si,offset led
		add si,bx;si指向待显示的数的数码管段码
        pop bx;bx出栈
		push dx;dx入栈保护
		mov al,byte ptr [si];al存段码
		mov dx,io82558;dx为A口地址
		out dx,al;由A口输出段码
		pop dx;dx出栈
		mov bp,0ffffh
de0:	dec bp
		jnz de0
		loop de1;嵌套延时
		push dx;dx入栈保护
		mov ah,06h
		mov dl,0ffh
		int 21h;中断，判断是否有键按下，al是键盘输入字符
		pop dx;dx出栈
		jz on;若没有键按下则循环，若有键按下则循环
exit: 	
		mov ah,4ch
		int 21h;返回DOS中断
code ends
end start

