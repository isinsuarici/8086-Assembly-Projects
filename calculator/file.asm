org 100h       

calculator:  

print_message1:
MOV [SI],'&'
LEA DX,msg1
MOV AH,09H
INT 21H 
mov dx,2040h  

input1:
MOV AH,01H
INT 21H 
CMP AL,13d
JE  print_message2BAS 
MOV BH,AL
CALL CHECHIFNOTNUMBER   

DEVAM:
out dx,al
inc dx
SUB AL,'0'
INC SI
MOV [SI],AL
JMP input1 
 
 
print_message2BAS:

INC SI      

print_message2:

MOV [SI],'&'
LEA DX,msg2
MOV AH,09H
INT 21H 
mov dx,2047h 

input2:
MOV AH,01H
INT 21H
CMP AL,13d         
JE parser
MOV BH,AL
CALL CHECHIFNOTNUMBER2   


DEVAM2:
out dx,al
inc dx
SUB AL,'0'          
INC SI             
MOV [SI],AL         
JMP input2 
   
parser:      
MOV CX,01d         
MOV BX,00H            

parse2:  

MOV AX,00H          
MOV AL,[SI]        
MUL CX             
ADD BX,AX           
MOV AX,CX           
MOV CX,10d          
MUL CX              
MOV CX,AX           
DEC SI              
CMP [SI],'&'        
JNZ parse2          
MOV [num2],BX       
MOV BX,00H                 
MOV DX,00h          
DEC SI              
MOV CX,01d          

parse1:  
MOV AX,00H          
MOV AL,[SI]         
MUL CX             
ADD BX,AX           
MOV AX,CX          
MOV CX,10d          
MUL CX             
MOV CX,AX           
DEC SI              
CMP [SI],'&'        
JNZ parse1          
MOV [num1],BX       
MOV AX,[num1]       
MOV BX,[num2]       
  

operation:   
 
MOV AX,[num1]       
MOV BX,[num2]       
MOV CX,AX            
LEA DX,msg3          
MOV AH,09H        
INT 21H 


MOV AH,01H       
INT 21H 
mov dx,2044h 
          
CMP AL,'+' 
out dx,al 
JE addition 
         
          
 
CMP AL,'-'
out dx,al  
JE subtraction       

          

CMP AL,'*'
out dx,al  
JE multiplication    


CMP AL,'/'
out dx,al  
JE division       
           
LEA DX,unknown_message
MOV AH,09H          
INT 21H             
loop operation                      
           
addition:
MOV AX,CX
MOV DX,00h  
ADD AX,BX 
ADC AX,DX
jmp reverse_parse  

subtraction:
MOV AX,CX
SUB AX,BX
jc ov
jnc nov
ov:NEG AX 
MOV [overflow],01h
nov:  
jmp reverse_parse

multiplication:
MOV AX,CX
MOV DX,00H 
MUL BX 
jmp reverse_parse
 
division: 
MOV AX,CX 
MOV DX,00H
ADD BX,DX
DIV BX  


    
reverse_parse:
MOV DX,00h          
MOV BX,10d           
DIV BX                
ADD DL,'0'          
INC SI            
MOV [SI],DL       
ADD AX,00h         
JNZ reverse_parse              
               

print1:
MOV CL,01h           
CMP CL,[overflow]      
MOV [overflow],00h
JZ print_minus       
JNZ SONUCUYAZDIR             
         
         
print_minus:
mov dx,204Bh
mov al, '-'
out dx,al               


SONUCUYAZDIR:
mov dx,204CH 

print: 
MOV AL,[SI] 
OUT DX,AL 
inc DX                     
DEC SI                
CMP [SI],'&'          
JNZ print             


mov dx,204AH
MOV AL,'='
OUT DX,AL


  
mov dx,2040h 
mov cx,47

clear:
mov al,00 
out dx,al
dec cx
inc dx
cmp cx,0
je calculator
loop clear       




CHECHIFNOTNUMBER PROC   
SUB BH,30H 
MOV CX,10    
MOV AH,0
LOOP1:  
CMP AH,BH  
JE DEVAM
 
ADD AH,1
LOOP LOOP1
JMP print_message1      

CHECHIFNOTNUMBER ENDP  

CHECHIFNOTNUMBER2 PROC   
SUB BH,30H 
MOV CX,10    
MOV AH,0
LOOP2:  
CMP AH,BH  
JE DEVAM2
 
ADD AH,1
LOOP LOOP2
JMP print_message2      

CHECHIFNOTNUMBER2 ENDP 

ret 

msg1 DB 0AH,0DH, "Enter first  number :  $" 
msg2 DB 0AH,0DH, "Enter second number :  $"
msg3 DB 0AH,0DH, "Enter operator :  $"        
unknown_message DB  "  Unknown operator.$"  
num1 dw 00h
num2 dw 00h
overflow db 00h