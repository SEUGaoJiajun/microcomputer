STACK SEGMENT STACK
DW 200H DUP(?)
STACK ENDS
DATA SEGMENT
KEY DB ?
BUF DB "OK!"
DATA ENDS
CODE SEGMENT
     ASSUME CS:CODE,SS:STACK,DS:DATA

DELAY PROC       ;��ʱ1s����                        
      PUSH CX
      PUSH AX
      MOV AX,08FFFH
GOOON:MOV CX,0FFFFH
GOON: DEC CX
      JNE GOON
      DEC AX
      JNE GOOON          ;ѭ����ѭ����ǿ��ʱЧ��
      POP AX
      POP CX
      RET
DELAY ENDP

DISP1 PROC FAR
      PUSH AX
      PUSH BX
      PUSH CX
      PUSH DX
      MOV AH,15              ;����ǰ��ʾ״̬��������ڣ�����
      INT 10H
      MOV AH,0               ;������ʾ״̬
      INT 10H
      MOV CX,1               ;��ʾһ��
      MOV DX,0               ;��0��0�д���ʾ
RETT: MOV AH,2
      INT 10H                 ;���ù��λ��               
      MOV AL,0FH              ;��ʾһ��ACSIIΪ0F���ַ�
      MOV AH,10
      INT 10H
      CALL DELAY
      CMP KEY,10
      JNB GETOUT
      INC DH                  ;�����ƶ�һ��
      ADD DL,2                ;�����ƶ�����
      CMP DH,25               ;�Ƿ�������
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
NEXT: LODSB                   ;[SI]����ĵ�ַ����AL��
      MOV AH,0EH              ;0E��ɶ����
      MOV BX,01
      INT 10H
      CALL DELAY
      LOOP NEXT               ;����3��
GOOUT:POP AX
      POP BX
      POP CX
      RET
DISP2 ENDP
KEYINT PROC FAR
      PUSH AX
      PUSH SI
      STI                      ;�����ж�
      IN AL,60H
      MOV AH,AL                ;�Ѽ�����AH��

      IN AL,61H                ;��PB7
      OR AL,80H                ;ʹD7�ø�
      OUT 61H,AL               
      AND AL,7FH               ;D7����
      OUT 61H,AL               ;���һ��D7��������,�жϸ�λ���ȴ��´ε���
      TEST AH,80H
      JNE THEN                 ;�޼����½�����������
      STI
      INC KEY
      MOV SI,OFFSET BUF        ;��OK����ַ��SI
      CALL DISP2
THEN: MOV AL,20H
      OUT 20H,AL               ;�����жϱ�ʶ���Ĵ���
      POP SI
      POP AX
      IRET
KEYINT ENDP

START:MOV AX,STACK
      MOV SS,AX                ;ջ������
      MOV AX,DATA
      MOV DS,AX                ;���ݶ�����
      MOV AX,0
      MOV ES,AX                ;����ESΪ����ʼ��ȡ�ж�������
      MOV AX,ES:[24H]
      PUSH AX
      MOV AX,ES:[26H]
      PUSH AX                  ;��24252627��ַ����������
      CLI                      ;���ж�(?)
      MOV AX,OFFSET KEYINT     
      MOV ES:[24H],AX          ;ȡ�����ж�ƫ�Ƶ�ַ�����͵�ַ
      MOV AX,SEG KEYINT
      MOV ES:[26H],AX          ;ȡ�����ж϶ε�ַ�����ߵ�ַ
      STI                      ;���ж�
      MOV KEY,0                ;KEY��������
AGAIN:CALL DISP1
      CMP KEY,10
      JB AGAIN                 ;KEY������ʮǰѭ��
      CLI                      ;���ж�(?)
      POP AX
      MOV ES:[26H],AX
      POP AX
      MOV ES:[24H],AX          ;ԭ������ԭ
      STI                      ;���ж�
      MOV AH,4CH
      INT 21H                  ;��������DOS
CODE ENDS
      END START
      
      