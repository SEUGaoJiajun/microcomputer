;��data1��data2�е�������λ16���������
data segment
data1 db 12H,34H     ;����1
data2 db 56H,78H     ;����2
data3 db 2 dup(?)    ;��
data ends
stacks segment stack 
    db 256 dup(?)
stacks ends
code segment
  assume cs:code,ds:data,ss:stacks
main proc far
start:mov ax,data
      mov ds,ax
      mov ax,stacks
      mov ss,ax
      mov si,0      
      mov cx,2      ;����ѭ������
loop1:mov al,data1[si]   ;ȡ����1 
      mov data3[si],al    
      mov al,data2[si]   ;ȡ����2
      adc data3[si],al
      inc si
      loop loop1
      mov ah,4ch       ;�����������
      int 21h	
main endp
code ends
end start
