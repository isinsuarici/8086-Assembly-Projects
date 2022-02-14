org 100h    

MOV AL,01
MOV BX,2000H
MOV CL,5

increase:
    mov [BX],AL
    ADD AL,1
    ADD BX,1
    loop increase
    
ret