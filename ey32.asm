;*******************
;*    8253��Ƶ     *
;*******************
ioport		equ 03100h-0280h	;ͨ���鿴�������ʵ���豸������ڴ�����ַ
io8253a		equ ioport+280h
io8253b		equ ioport+281h
io8253c		equ ioport+283h
code segment
	assume   cs:code
start:mov dx,io8253c     ;��8253д������
	mov al,36h       ;ʹ0ͨ��Ϊ������ʽ3�������Ƽ������ȶ�/д���ֽں���ֽ�
	out dx,al
        mov ax,1000      ;д��ѭ��������ֵ1000
	mov dx,io8253a
	out dx,al        ;��д����ֽ�
	mov al,ah
	out dx,al        ;��д����ֽ�
	mov dx,io8253c
	mov al,76h       ;��8253ͨ��1������ʽ3�������Ƽ������ȶ�/д���ֽ�
	out dx,al
	mov ax,1000      ;д��ѭ��������ֵ1000
	mov dx,io8253b
	out dx,al        ;��д���ֽ�
	mov al,ah
	out dx,al        ;��д���ֽ�
	mov ah,4ch       ;�����˳�
	int 21h
  code ends
	end start
