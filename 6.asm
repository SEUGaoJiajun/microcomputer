data segment
ioport equ 3100h-0280h;�鿴�������ʵ���豸������ڴ�����ַ
io8255a equ ioport+28ah;c�ڵ�ַ
io8255b equ ioport+28bh;���ƼĴ�����ַ
portc1 db 24h,44h,04h,44h,04h.44h,04h;������ͨ�ƿ��ܵ�״̬����
db 81h,82h,80h,82h,80h,82h,80h
db 0ffh;������־
data ends
code segment
	assume cs:code,ds:data
start:	mov ax,data
		mov ds,ax
		mov dx,io8255b;dx���ǿ��ƼĴ����ĵ�ַ
		mov al,90h
		out dx,al;����C��Ϊ���
		mov dx,io8255a
re_on:	mov bx,0
on:		mov al,portc1[bx];��ȡ��Ӧ�Ľ�ͨ��״̬
		cmp al,0ffh;�ж��Ƿ������β
		jz re_on;��������β�����ظ���������
		out dx,al;������Ӧ�ĵ�
		inc bx;Ϊ����һ��״̬��׼��
		mov cx,6fffh;cx����ѭ������
		test al,21h;�����Ƿ����̵���
		jz de1;û�������ʱ��������cx���ϴ�����ָ�
		mov cx,0ffffh
de1:	mov di,0ffffh
de0:	dec di
		jnz de0
		loop de1;Ƕ����ʱ
		push dx;dx��Ϊc�ڵ�ַ����ջ����
		mov ah,06h
		mov dl,0ffh
		int 21h;�ж��Ƿ��м�����
		pop dx
		jz on;û������ѭ�����м������˳�����
exit:	mov ah,4ch
		int 21h;����dos�ж�
code ends
end start

