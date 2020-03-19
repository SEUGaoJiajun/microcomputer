data segment
ioport equ 3100h-0280h;查看计算机给实验设备分配的内存计算基址
io8255a equ ioport+28ah;c口地址
io8255b equ ioport+28bh;控制寄存器地址
portc1 db 24h,44h,04h,44h,04h.44h,04h;六个交通灯可能的状态数据
db 81h,82h,80h,82h,80h,82h,80h
db 0ffh;结束标志
data ends
code segment
	assume cs:code,ds:data
start:	mov ax,data
		mov ds,ax
		mov dx,io8255b;dx中是控制寄存器的地址
		mov al,90h
		out dx,al;设置C口为输出
		mov dx,io8255a
re_on:	mov bx,0
on:		mov al,portc1[bx];读取相应的交通灯状态
		cmp al,0ffh;判断是否读到结尾
		jz re_on;若读到结尾处则重复上述过程
		out dx,al;点亮相应的灯
		inc bx;为读下一个状态做准备
		mov cx,6fffh;cx控制循环次数
		test al,21h;测试是否有绿灯亮
		jz de1;没有则短延时（跳过给cx赋较大数的指令）
		mov cx,0ffffh
de1:	mov di,0ffffh
de0:	dec di
		jnz de0
		loop de1;嵌套延时
		push dx;dx中为c口地址，入栈保护
		mov ah,06h
		mov dl,0ffh
		int 21h;判断是否有键按下
		pop dx
		jz on;没键按下循环，有键按下退出程序
exit:	mov ah,4ch
		int 21h;返回dos中断
code ends
end start

