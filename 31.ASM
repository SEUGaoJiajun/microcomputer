;*************************;
;*  8253��ʽ0������ʵ��  *;
;*************************;
ioport		equ 3100h-0280h
io8253a		equ ioport+283h
io8253b		equ ioport+280h
code segment
	assume  cs:code
start: mov al,10h       ;����8253ͨ��0Ϊ������ʽ2,�����Ƽ���
	 mov dx,io8253a
	 out dx,al
	 mov dx,io8253b      ;�ͼ�����ֵΪ0FH
	 mov al,0fh
	 out dx,al
lll:     in al,dx         ;��������ֵ
	 call disp        ;����ʾ�ӳ���
	 push dx  
	 mov ah,06h 
	 mov dl,0ffh
	 int 21h
	 pop dx
	 jz lll
	 mov ah,4ch       ;�˳�
	 int 21h
disp   proc near        ;��ʾ�ӳ���
	 push dx
	 and al,0fh       ;����ȡ����λ
	 mov dl,al
	 cmp dl,9         ;�ж��Ƿ�<=9
	 jle  num         ;������Ϊ'0'-'9',ASCII���30H
	 add dl,7         ;����Ϊ'A'-'F',ASCII���37H
num:     add dl,30h
	 mov ah,02h       ;��ʾ
	 int 21h
	 mov dl,0dh       ;�ӻس���
	 int 21h
	 mov dl,0ah       ;�ӻ��з�
	 int 21h
	 pop dx
	 ret              ;�ӳ��򷵻�
disp endp
code ends
end start