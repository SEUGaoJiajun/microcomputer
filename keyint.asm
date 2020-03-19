STACK SEGMENT STACK
DW 200H DUP(?)
STACK ENDS
DATA SEGMENT
KEY DB ?
BUF DB "OK!"
DATA ENDS
CODE SEGMENT
     ASSUME CS:CODE,SS:STACK,DS:DATA

DELAY PROC       ;延时1s过程                        
      PUSH CX
      PUSH AX
      MOV AX,08FFFH
GOOON:MOV CX,0FFFFH
GOON: DEC CX
      JNE GOON
      DEC AX
      JNE GOOON          ;循环套循环加强延时效果
      POP AX
      POP CX
      RET
DELAY ENDP

DISP1 PROC FAR
      PUSH AX
      PUSH BX
      PUSH CX
      PUSH DX
      MOV AH,15              ;读当前显示状态，意义何在？待测
      INT 10H
      MOV AH,0               ;设置显示状态
      INT 10H
      MOV CX,1               ;显示一个
      MOV DX,0               ;在0行0列处显示
RETT: MOV AH,2
      INT 10H                 ;设置光标位置               
      MOV AL,0FH              ;显示一个ACSII为0F的字符
      MOV AH,10
      INT 10H
      CALL DELAY
      CMP KEY,10
      JNB GETOUT
      INC DH                  ;向下移动一行
      ADD DL,2                ;向右移动两列
      CMP DH,25               ;是否满屏？
      JNE RETT
GETOUT:POP DX
      POP CX
      POP BX
      POP AX
      RET
DISP1 ENDP
DISP2 PROC FAR
      PUSH CX
      PUSH BX
      PUSH AX
      CMP KEY,10
      JA  GOOUT
      MOV CX,3                ;
NEXT: LODSB                   ;[SI]储存的地址传到AL中
      MOV AH,0EH              ;0E是啥？？
      MOV BX,01
      INT 10H
      CALL DELAY
      LOOP NEXT               ;调用3次
GOOUT:POP AX
      POP BX
      POP CX
      RET
DISP2 ENDP
KEYINT PROC FAR
      PUSH AX
      PUSH SI
      STI                      ;开启中断
      IN AL,60H
      MOV AH,AL                ;把键读到AH中

      IN AL,61H                ;读PB7
      OR AL,80H                ;使D7置高
      OUT 61H,AL               
      AND AL,7FH               ;D7置零
      OUT 61H,AL               ;输出一个D7的正脉冲,中断复位，等待下次调用
      TEST AH,80H
      JNE THEN                 ;无键按下将跳出，返回
      STI
      INC KEY
      MOV SI,OFFSET BUF        ;将OK串地址赋SI
      CALL DISP2
THEN: MOV AL,20H
      OUT 20H,AL               ;发个中断标识到寄存器
      POP SI
      POP AX
      IRET
KEYINT ENDP

START:MOV AX,STACK
      MOV SS,AX                ;栈堆设置
      MOV AX,DATA
      MOV DS,AX                ;数据段设置
      MOV AX,0
      MOV ES,AX                ;设置ES为最起始，取中断向量表
      MOV AX,ES:[24H]
      PUSH AX
      MOV AX,ES:[26H]
      PUSH AX                  ;存24252627地址的向量函数
      CLI                      ;关中断(?)
      MOV AX,OFFSET KEYINT     
      MOV ES:[24H],AX          ;取自制中断偏移地址发到低地址
      MOV AX,SEG KEYINT
      MOV ES:[26H],AX          ;取自制中断段地址发到高地址
      STI                      ;开中断
      MOV KEY,0                ;KEY记数清零
AGAIN:CALL DISP1
      CMP KEY,10
      JB AGAIN                 ;KEY记数满十前循环
      CLI                      ;关中断(?)
      POP AX
      MOV ES:[26H],AX
      POP AX
      MOV ES:[24H],AX          ;原向量表还原
      STI                      ;开中断
      MOV AH,4CH
      INT 21H                  ;结束返回DOS
CODE ENDS
      END START
      
      