;*************************;
;*  8253��ʽ0������ʵ��  *;
;*************************;
ioport		equ 3100h-0280h	;ͨ���鿴�������ʵ���豸������ڴ�����ַ
io8253a		equ ioport+283h
io8253b		equ ioport+280h
code segment
	assume  cs:code
start: mov al,10h       ;����8253ͨ��0Ϊ������ʽ2,�����Ƽ���
	 mov dx,io8253a		;dx������ǿ��ƼĴ����ĵ�ַ
	 out dx,al			;��������д����ƼĴ���
	 mov dx,io8253b      ;�ͼ�����ֵΪ0FH��dx������Ǽ�����0�ĵ�ַ
	 mov al,0fh
	 out dx,al			;��������ֵ�͵�������0
lll:  in al,dx         ;��������ֵ
	 call disp        ;����ʾ�ӳ���
	 push dx			;dxֵ��ջ����    
	 mov ah,06h			;���ܺ�Ϊ06h���жϣ�ֱ�ӿ���̨I/O��DL=0ffh��ʾ����
	 mov dl,0ffh
	 int 21h
	 pop dx
	 jz lll				;���Ϊ���ʱ������111������ִ�У��м�������׼������
	 mov ah,4ch       ;�˳�������DOS�ж�
	 int 21h
disp   proc near        ;��ʾ�ӳ���
	 push dx
	 and al,0fh       ;ȡ����λ
	 mov dl,al
	 cmp dl,9         ;�ж��Ƿ�<=9
	 jle  num         ;������Ϊ'0'-'9',ASCII���30H
	 add dl,7         ;����Ϊ'A'-'F',ASCII���37H
num:     add dl,30h
	 mov ah,02h       ;��ʾ��DL������Ǵ���ʾ�ַ�
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
