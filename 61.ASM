data segment
ioport equ 3100h-0280h;�鿴�������ʵ���豸������ڴ�����ַ
io8255a equ ioport+28ah;c�ڵ�ַ
io8255b equ ioport+28bh;���ƼĴ�����ַ
io82558 equ ioport+288h;A�ڵ�ַ
portc1 db 24h,44h,04h,44h,04h.44h,04h;������ͨ�ƿ��ܵ�״̬����
db 81h,82h,80h,82h,80h,82h,80h
db 0ffh;������־
led db 3fh,06h,5bh;�������ʾ0��1,2����Ҫ�����
buffer db 2;���Ҫ��ʾ�ĸ�λ��ʮλ
data ends
code segment
	assume cs:code,ds:data
start:	mov ax,data
		mov ds,ax
		mov dx,io8255b
        mov al,80h
		out dx,al;��A����Ϊ����������ڷ�ʽ0��c��Ϊ���
		mov dx,io8255a
		mov di,offset buffer;diΪ��ʾ������
re_on:	mov bx,0
on:		mov al,portc1[bx];��ȡ��Ӧ�Ľ�ͨ��״̬
		cmp al,0ffh;�ж��Ƿ������β
		jz re_on;��������β�����ظ���������
		out dx,al;������Ӧ�ĵ�
		inc bx;Ϊ����һ��״̬��׼��
		mov cx,6fffh

		test al,21h;�ж��Ƿ����̵���
		jnz continue;�����̵ƣ��򲻶�buffer����
		add byte ptr buffer,1;û���̵�buffer+1
		cmp byte ptr buffer,3;�Ƚ�buffer��3,
		jne continue;buffer��Ϊ3������buffer��0ָ��
		mov byte ptr buffer,0;buffer����

		test al,21h;��û���̵ƣ�����ʱ������cx��������ָ�
		jz de1
continue:mov cx,0ffffh
de1:	push bx;bxָ����һ���ݣ���Ҫ��ջ����
		mov bl,[di]      ;bl��Ϊ����ʾ������
		mov bh,0
		mov si,offset led
		add si,bx;siָ�����ʾ����������ܶ���
        pop bx;bx��ջ
		push dx;dx��ջ����
		mov al,byte ptr [si];al�����
		mov dx,io82558;dxΪA�ڵ�ַ
		out dx,al;��A���������
		pop dx;dx��ջ
		mov bp,0ffffh
de0:	dec bp
		jnz de0
		loop de1;Ƕ����ʱ
		push dx;dx��ջ����
		mov ah,06h
		mov dl,0ffh
		int 21h;�жϣ��ж��Ƿ��м����£�al�Ǽ��������ַ�
		pop dx;dx��ջ
		jz on;��û�м�������ѭ�������м�������ѭ��
exit: 	
		mov ah,4ch
		int 21h;����DOS�ж�
code ends
end start
