;将data1和data2中的两个四位16进制数相加
data segment
data1 db 12H,34H     ;加数1
data2 db 56H,78H     ;加数2
data3 db 2 dup(?)    ;和
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
      mov cx,2      ;设置循环次数
loop1:mov al,data1[si]   ;取加数1 
      mov data3[si],al    
      mov al,data2[si]   ;取加数2
      adc data3[si],al
      inc si
      loop loop1
      mov ah,4ch       ;程序结束返回
      int 21h	
main endp
code ends
end start
