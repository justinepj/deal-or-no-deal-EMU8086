
print macro x, y, attrib, sdat
LOCAL   s_dcl, skip_dcl, s_dcl_end
    pusha
    mov dx, cs
    mov es, dx
    mov ah, 13h
    mov al, 1
    mov bh, 0
    mov bl, attrib
    mov cx, offset s_dcl_end - offset s_dcl
    mov dl, x
    mov dh, y
    mov bp, offset s_dcl
    int 10h
    popa
    jmp skip_dcl
    s_dcl DB sdat
    s_dcl_end DB 0
    skip_dcl:    
endm  

;Clear Screen
clear_screen macro
    pusha
    mov ax, 0600h
    mov bh, 0000_1111b
    mov cx, 0
    mov dh, 24
    mov dl, 79
    int 10h
    popa
endm


;Print Char
PUTC    MACRO   char
        PUSH    AX
        MOV     AL, char
        MOV     AH, 0Eh
        INT     10h     
        POP     AX
ENDM

org 100H
jmp s
;Print  


;Variables                 
       
     ;index 0 1 2 3 4 5 6 7 8  9 10 11 12 13 14 15 16 17 18 19
;CaseNumber  1   2   3   4   5   6   7   8   9  10
      
      x db ? ; "X Position"
      y db ? ; "Y Position"  
      
      temp dw ? ;"Temporary Variable"        
      tempindex dw ? ; "Temp Index" 
      tmp_r dw 0 ;temp round
      tc dw ? ; "Total Briefcase" 
      tm dw 0 ; total money     
      bo dw ? ;bankers offer    
      mc dw ? ; "Main Briefcase"  
      mc_index_tmp dw ?                   
      mc_money_tmp dw ? 
      mc_temp dw 0 ; Main Temp   
      case_color db 1111_0000b
    
      ui dw ? ; "User Input"      
      cxlooptemp dw ? ; cx temp storage
      r dw 0 ; "Round"
      p dw 0 ; "Pick     
      sc db ? ;Strike count    
      yn dw ? ;yes no answer
      cn dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0    
         dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0    
     
      ml dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0    
         dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0 0   
;Temp number      
      tn dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0    
         dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0  
         a1000a dw ?   
        seco db 0, 0, ' '
      db 0Dh, 0Ah, 24h         ; line feed   return   and  stop symbol 24h=$ (ASCII). 
  
    bx_lo_temp dw ?   
    ax_lo_temp dw ?   
    lolo dw ?      
    
    one dw 1
    two dw 1
    three dw 1
    four dw 1
    five dw 1
    six dw 1
    seven dw 1
    eight dw 1
    nine dw 1
    ten dw 1
    eleven dw 1
    twelve dw 1
    thirteen dw 1
    fourteen dw 1
    fifteen dw 1
    sixteen dw 1
    seventeen dw 1
    eighteen dw 1
    nineteen dw 1
    twenty dw 1 
    
    gamemode dw ?   
     
s:    
    mov ml[0], 1
    mov ml[2], 5  
    mov ml[4], 10
    mov ml[6], 15
    mov ml[8], 20
    mov ml[10], 25
    mov ml[12], 30
    mov ml[14], 35
    mov ml[16], 50
    mov ml[18], 75
    mov ml[20], 100
    mov ml[22], 150
    mov ml[24], 200
    mov ml[26], 250
    mov ml[28], 300
    mov ml[30], 350
    mov ml[32], 400
    mov ml[34], 450
    mov ml[36], 500
    mov ml[38], 1000       
    
    INPUT_GAME_MODE_AGAIN:
    print 1,1,0000_0111b,  "Welcome to Deal or No Deal by BSIT-IS3A Group 6"
    print 1,2,0000_0111b,  "Choose Game Mode:"
    print 1,3,0000_0111b,  "1. One Player"
    print 1,4,0000_0111b,  "2. Two Player"
    print 1,5,0000_0111b,  "Choose number : "
    
    call scan_num
    
    mov ax, cx
    mov bx, 1
    cmp ax, bx
    je ONE_PLAYER
    
    mov ax, cx
    mov bx, 2
    cmp ax, bx
    je TWO_PLAYER
    
    print 20,5,0000_1100b,  "INVALID INPUT"
    jmp INPUT_GAME_MODE_AGAIN     
    
;;;;;;;;;;;; FOR ONE PLAYER !!;;;;;;;

ONE_PLAYER:
    clear_screen
     
    print 1,1,0000_0111b,  "Welcome to Deal or No Deal by BSIT-IS3A Group 6"
    print 1,2,0000_0111b,  "How to play Deal or No Deal game?"           
    print 1,3,0000_0111b,  "For One Player:"                                                            ;
    print 1,4,0000_0111b,  "1. Before the game begins, the player must choose a number. This number "
    print 1,5,0000_0111b,  "consists."
    print 1,6,0000_0111b,  "2. There are total of 20 briefcases with cash prize range 1 to 1000 pesos "
    print 1,7,0000_0111b,  "inside. Before the round begins the player must choose his/her own "
    print 1,8,0000_0111b,  "briefcase."
    print 1,9,0000_0111b,  "3. After choosing your briefcase, the player will now proceed to play the "
    print 1,10,0000_0111b, "game and choose a number of briefcase."
    print 1,11,0000_0111b, "4. After choosing a given number of briefacases, the Banker will give "
    print 1,12,0000_0111b, "an offer to the player."
    print 1,13,0000_0111b, "5. The player must decide whether to choose Deal or No Deal. Deal, means "
    print 1,14,0000_0111b, "accepting the offer presented and ending the game, or No Deal, rejecting "
    print 1,15,0000_0111b, "the offer and continuing the game until all briefcase are opened. "
    
    print 1,18,0000_1011b, "Press any key to start..."     
    
    ; Press Any key to Start   
    mov ah, 1
    int 21h          
    clear_screen                                                      

    mov al, 0
    mov x, al
    mov al,2 ;Set Y   
    mov y,al ;position        
    
    mov sc, 1
    mov ax, 1
    mov tc, ax ;Set Total case to 1
    mov cx, 21 ;Set number of loop 
    mov si, 0 ;Set index
    SET_MONEY_R:
         mov lolo,cx
         mov ax, si         ;move source index to tempindex
         mov tempindex, ax  
         
         mov ax, tc         ;move total case to ax to print
         print 1,y,0000_0111b,"Briefcase number "
         call print_num    
         
         rand_again:                      
         print 20,y,0000_0111b," : "
         print 23,y,0000_1110b,"Loading..."
           mov ah, 2ch                  ; get time 
           int 21h 
           mov al, dl
           sub ax, 11264                   ; second 
           mov temp, ax        
           
           mov ax, one
           mov bx, 0
           cmp ax, bx
           je skip_this_1       
           
           push cx
             mov ax, temp
             mov bx, 1
             mov cx, 5
             A1_1_5:
                cmp ax, bx
                je equal_A1_1_5 
                add bx, 20
             loop A1_1_5
             jmp skip_equal_A1
             
             equal_A1_1_5:
             mov cn[si], 1  
             mov one, 0
             jmp print_rand
             skip_equal_A1:   
           pop cx
           
           skip_this_1:
           ;5          
           mov ax, two
           mov bx, 0
           cmp ax, bx
           je skip_this_2
           
           push cx
             mov ax, temp
             mov bx, 2
             mov cx, 5
             A1_2_5:
                cmp ax, bx
                je equal_A1_2_5 
                add bx, 20
             loop A1_2_5
             jmp skip_equal_A2
             equal_A1_2_5:
             mov cn[si], 5  
             mov two, 0
             jmp print_rand
             skip_equal_A2:   
           pop cx
           
           skip_this_2:
           mov ax, three
           mov bx, 0
           cmp ax, bx
           je skip_this_3
           
           ;10
           push cx
             mov ax, temp
             mov bx, 3
             mov cx, 5
             A1_3_5:
                cmp ax, bx
                je equal_A1_3_5 
                add bx, 20
             loop A1_3_5
             jmp skip_equal_A3
             equal_A1_3_5:
             mov cn[si], 10 
             mov three, 0
             jmp print_rand
             skip_equal_A3:   
           pop cx
           
           skip_this_3:
           mov ax, four
           mov bx, 0
           cmp ax, bx
           je skip_this_4
           
           
           ;15
           push cx
             mov ax, temp
             mov bx, 4
             mov cx, 5
             A1_4_5:
                cmp ax, bx
                je equal_A1_4_5 
                add bx, 20
             loop A1_4_5
             jmp skip_equal_A4
             equal_A1_4_5:
             mov cn[si], 15
             mov four, 0
             jmp print_rand
             skip_equal_A4:   
           pop cx
           
           skip_this_4:
           mov ax, five
           mov bx, 0
           cmp ax, bx
           je skip_this_5
           
           ;20
           push cx
             mov ax, temp
             mov bx, 5
             mov cx, 5
             A1_5_5:
                cmp ax, bx
                je equal_A1_5_5 
                add bx, 20
             loop A1_5_5
             jmp skip_equal_A5
             equal_A1_5_5:
             mov cn[si], 20
             mov five, 0
             jmp print_rand
             skip_equal_A5:   
           pop cx
           
           skip_this_5:
           mov ax, six
           mov bx, 0
           cmp ax, bx   
           je skip_this_6
           
           ;25
           push cx
             mov ax, temp
             mov bx, 6
             mov cx, 5
             A1_6_5:
                cmp ax, bx
                je equal_A1_6_5 
                add bx, 20
             loop A1_6_5
             jmp skip_equal_A6
             equal_A1_6_5:
             mov cn[si], 25
             mov six, 0
             jmp print_rand
             skip_equal_A6:   
           pop cx
           
           skip_this_6:
           mov ax, seven
           mov bx, 0
           cmp ax, bx
           je skip_this_7
           
           
           ;30
           push cx
             mov ax, temp
             mov bx, 7
             mov cx, 5
             A1_7_5:
                cmp ax, bx
                je equal_A1_7_5 
                add bx, 20
             loop A1_7_5
             jmp skip_equal_A7
             equal_A1_7_5:
             mov cn[si], 30
             mov seven, 0
             jmp print_rand
             skip_equal_A7:   
           pop cx
                         
           skip_this_7:
           mov ax, eight
           mov bx, 0
           cmp ax, bx
           je skip_this_8
           
           ;35
           push cx
             mov ax, temp
             mov bx, 8
             mov cx, 5
             A1_8_5:
                cmp ax, bx
                je equal_A1_8_5 
                add bx, 20
             loop A1_8_5
             jmp skip_equal_A8
             equal_A1_8_5:
             mov cn[si], 35 
             mov eight, 0
             jmp print_rand
             skip_equal_A8:   
           pop cx
           
           skip_this_8:
           mov ax, nine
           mov bx, 0
           cmp ax, bx
           je skip_this_9
           
           ;50
           push cx
             mov ax, temp
             mov bx, 9
             mov cx, 5
             A1_9_5:
                cmp ax, bx
                je equal_A1_9_5 
                add bx, 20
             loop A1_9_5
             jmp skip_equal_A9
             equal_A1_9_5:
             mov cn[si], 50
             mov nine, 0
             jmp print_rand
             skip_equal_A9:   
           pop cx
           
           skip_this_9:
           mov ax, ten
           mov bx, 0
           cmp ax, bx
           je skip_this_10
           
           ;75
           push cx
             mov ax, temp
             mov bx, 10
             mov cx, 5
             A1_10_5:
                cmp ax, bx
                je equal_A1_10_5 
                add bx, 20
             loop A1_10_5
             jmp skip_equal_A10
             equal_A1_10_5:
             mov cn[si], 75 
             mov ten, 0
             jmp print_rand
             skip_equal_A10:   
           pop cx
           
           skip_this_10:
           mov ax, eleven
           mov bx, 0
           cmp ax, bx
           je skip_this_11
           
           ;100
           push cx
             mov ax, temp
             mov bx, 11
             mov cx, 5
             A1_11_5:
                cmp ax, bx
                je equal_A1_11_5 
                add bx, 20
             loop A1_11_5
             jmp skip_equal_A11
             equal_A1_11_5:
             mov cn[si], 100
             mov eleven, 0
             jmp print_rand
             skip_equal_A11:   
           pop cx
           
           skip_this_11:
           mov ax, twelve
           mov bx, 0
           cmp ax, bx
           je skip_this_12
           
           ;150
           push cx
             mov ax, temp
             mov bx, 12
             mov cx, 5
             A1_12_5:
                cmp ax, bx
                je equal_A1_12_5 
                add bx, 20
             loop A1_12_5
             jmp skip_equal_A12
             equal_A1_12_5:
             mov cn[si], 150
             mov twelve, 0
             jmp print_rand
             skip_equal_A12:   
           pop cx
           
           skip_this_12:
           mov ax, thirteen
           mov bx, 0
           cmp ax, bx
           je skip_this_13
           
           ;200
           push cx
             mov ax, temp
             mov bx, 13
             mov cx, 5
             A1_13_5:
                cmp ax, bx
                je equal_A1_13_5 
                add bx, 20
             loop A1_13_5
             jmp skip_equal_A13
             equal_A1_13_5:
             mov cn[si], 200
             mov thirteen, 0
             jmp print_rand
             skip_equal_A13:   
           pop cx
           
           skip_this_13:
           mov ax, fourteen
           mov bx, 0
           cmp ax, bx
           je skip_this_14
           
           ;250
           push cx
             mov ax, temp
             mov bx, 14
             mov cx, 5
             A1_14_5:
                cmp ax, bx
                je equal_A1_14_5 
                add bx, 20
             loop A1_14_5
             jmp skip_equal_A14
             equal_A1_14_5:
             mov cn[si], 250 
             mov fourteen, 0
             jmp print_rand
             skip_equal_A14:   
           pop cx
           
           skip_this_14:
           mov ax, fifteen
           mov bx, 0
           cmp ax, bx
           je skip_this_15
           
           ;300
           push cx
             mov ax, temp
             mov bx, 15
             mov cx, 5
             A1_15_5:
                cmp ax, bx
                je equal_A1_15_5 
                add bx, 20
             loop A1_15_5
             jmp skip_equal_A15
             equal_A1_15_5:
             mov cn[si], 300  
             mov fifteen, 0
             jmp print_rand
             skip_equal_A15:   
           pop cx
           
           skip_this_15:
           mov ax, sixteen
           mov bx, 0
           cmp ax, bx
           je skip_this_16
           
           ;350
           push cx
             mov ax, temp
             mov bx, 16
             mov cx, 5
             A1_16_5:
                cmp ax, bx
                je equal_A1_16_5 
                add bx, 20
             loop A1_16_5
             jmp skip_equal_A16
             equal_A1_16_5:
             mov cn[si], 350
             mov sixteen, 0
             jmp print_rand
             skip_equal_A16:   
           pop cx
           
           skip_this_16:
           mov ax, seventeen
           mov bx, 0
           cmp ax, bx
           je skip_this_17
           
           ;400
           push cx
             mov ax, temp
             mov bx, 17
             mov cx, 5
             A1_17_5:
                cmp ax, bx
                je equal_A1_17_5 
                add bx, 20
             loop A1_17_5
             jmp skip_equal_A17
             equal_A1_17_5:
             mov cn[si], 400
             mov seventeen, 0 
             jmp print_rand
             skip_equal_A17:   
           pop cx
           
           skip_this_17:
           mov ax, eighteen
           mov bx, 0
           cmp ax, bx
           je skip_this_18
           
           ;450
           push cx
             mov ax, temp
             mov bx, 18
             mov cx, 5
             A1_18_5:
                cmp ax, bx
                je equal_A1_18_5 
                add bx, 20
             loop A1_18_5
             jmp skip_equal_A18
             equal_A1_18_5:
             mov cn[si], 450 
             mov eighteen, 0
             jmp print_rand
             skip_equal_A18:   
           pop cx
           
           skip_this_18:
           mov ax, nineteen
           mov bx, 0
           cmp ax, bx
           je skip_this_19
           
           ;500
           push cx
             mov ax, temp
             mov bx, 19
             mov cx, 5
             A1_19_5:
                cmp ax, bx
                je equal_A1_19_5 
                add bx, 20
             loop A1_19_5
             jmp skip_equal_A19
             equal_A1_19_5:
             mov cn[si], 500 
             mov nineteen, 0
             jmp print_rand
             skip_equal_A19:   
           pop cx
           
           skip_this_19:
           mov ax, twenty
           mov bx, 0
           cmp ax, bx
           je skip_this_20
           
           ;1000
           push cx
             mov ax, temp
             mov bx, 20
             mov cx, 5
             A1_20_5:
                cmp ax, bx
                je equal_A1_20_5 
                add bx, 20
             loop A1_20_5
             jmp skip_equal_A20
             equal_A1_20_5:
             mov cn[si], 1000
             mov twenty, 0
             jmp print_rand 
             
             skip_equal_A20:   
           pop cx
           skip_this_20:
           
           jmp rand_again
           
           print_rand:
           
           mov ax, cn[si]
           mov temp, ax
            ;Input Checking
            push cx    ;push cx again
            mov si, 0
            mov cx, 20
            
            CHECK_INPUT_MONEY_R:  ;internal loop
               mov ax, ml[si]     ;store to casenumber in specific index
               mov bx, temp
               cmp ax, bx                              
               je EXIT_CIM_LOOP_R ;exit the loop if input is valid
               add si, 2
               
            loop CHECK_INPUT_MONEY_R 
         
         
         PRINT_INVALID_R:
            mov sc, 1               
            mov temp, 0 
            mov ax, tempindex
            mov si, ax
            mov cn[si], 0
            pop cx   ;pop the first cx
            JMP rand_again ;jump random input again  
            
            EXIT_CIM_LOOP_R: 
            mov ax, 0
            cmp ax, bx
            je PRINT_INVALID_R
            pop cx                           ;
            print 23,y,0000_1110b,"           "
            print 20,y,0000_1010b,"Okay"
            
            
           
         mov ml[si], 0      
         ;if total case = 20 then exit the loop 
         mov ax, tc
         mov bx, 20
         cmp ax, bx
         je START_GAME
         
         ;set again the original index from tempindex to si
         mov ax, tempindex
         mov si, ax      
         mov temp, 0
         add tc, 1  ; plus 1 to total case
         add y, 1 ;plus 1 to Y position 
         add si, 2 ; plus 2 to SI 
         mov cx, lolo
                         
    loop SET_MONEY_R
    jmp START_GAME        

;;;;;;;;;;;;FOR TWO PLAYER !!!;;;;;;;;;;;;;;;;  

TWO_PLAYER:  
    clear_screen
    print 1,1,0000_0111b,  "Welcome to Deal or No Deal by BSIT-IS3A Group 6"
    print 1,2,0000_0111b,  "How to play Deal or No Deal game?"           
    print 1,3,0000_0111b,  "For Two Player:"                                                            ;
    print 1,4,0000_0111b,  "1. For two player, the game will be played by one only and the other player"
    print 1,5,0000_0111b,  "will be the one who will assign the prize. After the play of first player,"
    print 1,6,0000_0111b,  "the second player will be the one to play the deal or no deal and the"
    print 1,7,0000_0111b,  "first player a while ago will now be the one assigning the prize. "
    print 1,8,0000_0111b,  "briefcase."
    print 1,9,0000_0111b,  "2. There are total of 20 briefcases with cash prize range 1 to 1000 pesos "
    print 1,10,0000_0111b, "inside. Before the round begins the player must choose his/her own "
    print 1,11,0000_0111b, "briefcase."
    print 1,12,0000_0111b, "3. After choosing your briefcase, the player will now proceed to play the "
    print 1,13,0000_0111b, "game and choose a number of briefcase."
    print 1,14,0000_0111b, "4. After choosing a given number of briefacases, the Banker will give an "
    print 1,15,0000_0111b, "offer to the player."
    print 1,16,0000_0111b, "5. The player must decide whether to choose Deal or No Deal. Deal, means "
    print 1,17,0000_0111b, "accepting the offer presented and ending the game, or No Deal, rejecting "
    print 1,18,0000_0111b, "the offer and continuing the game until all briefcase are opened."
    
    
    print 1,21,0000_1011b, "Press any key to start..."     
    
    ; Press Any key to Start   
    mov ah, 1
    int 21h          
    clear_screen 


;Briefcase Money Setup
   ;Display Money Table    
    print 1,1,0000_0111b,  "Enter the specified amount of money in brief case."
  
    print 43,2,0010_1011b,   "==============||================="   ;78
    print 43,3,0010_1011b,   "=      1      ||      100       ="   ;78
    print 43,4,0010_1011b,   "=             ||                ="
    print 43,5,0010_1011b,   "=      5      ||      150       ="      
    print 43,6,0010_1011b,   "=             ||                ="  
    print 43,7,0010_1011b,   "=      10     ||      200       ="  
    print 43,8,0010_1011b,   "=             ||                ="  
    print 43,9,0010_1011b,   "=      15     ||      250       ="  
    print 43,10,0010_1011b   "=             ||                ="  
    print 43,11,0010_1011b,  "=      20     ||      300       ="  
    print 43,12,0010_1011b,  "=             ||                ="  
    print 43,13,0010_1011b,  "=      25     ||      350       ="  
    print 43,14,0010_1011b,  "=             ||                ="      
    print 43,15,0010_1011b,  "=      30     ||      400       ="      
    print 43,16,0010_1011b,  "=             ||                ="
    print 43,17,0010_1011b,  "=      35     ||      450       ="
    print 43,18,0010_1011b,  "=             ||                ="
    print 43,19,0010_1011b,  "=      50     ||      500       ="
    print 43,20,0010_1011b,  "=             ||                ="
    print 43,21,0010_1011b,  "=      75     ||      1000      ="
    print 43,22,0010_1011b,  "==============||================="
   


   
    mov al, 0
    mov x, al
    mov al,2 ;Set Y   
    mov y,al ;position        
    
    mov sc, 1
    mov ax, 1
    mov tc, ax ;Set Total case to 1
    mov cx, 20 ;Set number of loop 
    mov si, 0 ;Set index
    SET_MONEY:
         
         mov ax, si         ;move source index to tempindex
         mov tempindex, ax  
         
         mov ax, tc         ;move total case to ax to print
         print 1,y,0000_0111b,"Briefcase number "
         call print_num    
         
         INPUT_AGAIN:                      
         print 20,y,0000_0111b," : "
         
         push cx ;push cx to secure the value of above cx
           call scan_num  ;enter briefcase money and store to ax 
           mov temp, cx        
           mov cn[si],cx
         pop cx  ;pop first cx 
  
            ;Input Checking
            push cx    ;push cx again
            mov si, 0
            mov cx, 20
            
            CHECK_INPUT_MONEY:  ;internal loop
               add sc, 2
               mov ax, ml[si]     ;store to casenumber in specific index
               mov bx, temp
               cmp ax, bx                              
               je EXIT_CIM_LOOP ;exit the loop if input is valid
               add si, 2
               
            loop CHECK_INPUT_MONEY 
            
            ;proceed here if input is not valid 
            PRINT_INVALID:
            print 29, y, 0000_1100b, "INVALID INPUT"
            print 23, y, 0000_1111b, "      "     
            mov sc, 1               
            mov temp, 0 
            mov ax, tempindex
            mov si, ax
            mov cn[si], 0
            pop cx   ;pop the first cx
            JMP INPUT_AGAIN ;jump t input again  
            
            EXIT_CIM_LOOP: 
            mov ax, 0
            cmp ax, bx
            je PRINT_INVALID
            pop cx
            
            ;44-56 
            ;50-51         
            ;59 -74         
            ;65-68
            
            mov ah,sc 
            mov bh,21
            cmp ah, bh
            jg RIGHT_COL     
            print 44,sc, 0100_1010b,"             "
            print 49,sc,0100_1010b," " 
            mov ax, ml[si]
            call print_num
            JMP PASS_RIGHT_COL
                
            RIGHT_COL:    
            sub sc, 20
            print 59,sc, 0100_1010b,"                "
            print 64,sc,0100_1010b," " 
            mov ax, ml[si]
            call print_num
                                   
            PASS_RIGHT_COL:
            mov ml[si], 0 ;set the default money value to zero to avoid duplication 
            mov temp, 0
            mov sc, 1
            print 29, y, 0000_1010b, "VALID INPUT  "
            
            jmp GO    
         
         GO:   
         
         ;if total case = 20 then exit the loop 
         mov ax, tc
         mov bx, 20
         cmp ax, bx
         je START_GAME
         
         ;set again the original index from tempindex to si
         mov ax, tempindex
         mov si, ax      
         mov temp, 0
         add tc, 1  ; plus 1 to total case
         add y, 1 ;plus 1 to Y position 
         add si, 2 ; plus 2 to SI 
         
                         
    loop SET_MONEY
    jmp START_GAME
    
    
    START_GAME:
    
    mov cx, 20
    mov si, 0
    tm_add_all:
       push cx
        mov cx, cn[si]
        add tm, cx 
       pop cx
        mov ax, tm
        add si, 2
       
    loop tm_add_all   
    
       print 1,23,0000_1011b, "Press any key to start..."     
       ; Press Any key to Start   
       mov ah, 1
       int 21h          
       clear_screen 

;Print Game Layout 
   
;Banker's Offer--------------------                               
    print 1,1,0010_1011b,  "o-Banker's Offer-o"
    print 1,2,0010_1011b,  "=================="
    print 1,3,0010_1011b,  "=                ="  
    print 1,4,0010_1011b,  "=                ="  
    print 1,5,0010_1011b,  "=                ="  
    print 1,6,0010_1011b,  "=                ="  
    print 1,7,0010_1011b,  "=                ="  
    print 1,8,0010_1011b,  "=                ="  
    print 1,9,0010_1011b,  "=                ="  
    print 1,10,0010_1011b, "=================="  
;Banker's Offer End----------------
                                                 
                                                 
;Case Money-----------------------    
    print 1,12,0010_1011b,  "=================="
    print 1,12,0010_1011b,  "oooooo-Money-ooooo"
    print 1,13,0010_1011b,  "=================="      
    print 1,14,0010_1011b,  "=   1   ||  100  ="  
    print 1,15,0010_1011b,  "=   5   ||  150  ="  
    print 1,16,0010_1011b,  "=   10  ||  200  ="  
    print 1,17,0010_1011b,  "=   15  ||  250  ="  
    print 1,18,0010_1011b,  "=   20  ||  300  ="  
    print 1,19,0010_1011b,  "=   25  ||  350  ="  
    print 1,20,0010_1011b,  "=   30  ||  400  ="  
    print 1,21,0010_1011b,  "=   35  ||  450  ="  
    print 1,22,0010_1011b,  "=   50  ||  500  ="      
    print 1,23,0010_1011b,  "=   75  ||  1000 ="      
    
;Briefcases   
    ;Row 1 briefcases
    mov x, 25
    mov y, 1     
    mov cx, 5               
    mov si, 0
    PRINT_CASE_V1:
        
       print x,y,0010_1011b,    "##"  
       sub x, 3
       add y, 1
       print x,y,0010_1011b, "########"
       add y, 1
       print x,y,0010_1011b, "########"  
       
       ;print num
       add x, 3
       print x,y,0010_1011b, "#"  
       add si, 1
       mov ax, si
       call print_num
       
       sub x, 1
       print x,y,0010_1011b, "#"  
       mov ax, 0
       call print_num
       
       sub x, 2
       add y, 1
       print x,y,0010_1011b, "########"
       
       mov y, 1
       add x, 13
    loop PRINT_CASE_V1 
    
    ;Row 2 briefcases
    mov x, 25
    mov y, 6     
    mov cx, 5 
    mov si, 5
    PRINT_CASE_V2:
        
       print x,y,0010_1011b,    "##"  
       sub x, 3
       add y, 1
       print x,y,0010_1011b, "########"
       add y, 1
       print x,y,0010_1011b, "########" 
       
       ;print num
       add si, 1 
       mov ax, si
       mov bx, 10
       cmp ax, bx
       jne not_equal_to_ten
       ;If equal to 10
       add x, 2
       print x,y,0010_1011b, "#"  
       call print_num  
       sub x, 2
       jmp SKIP_ETT
       
       ;if si is not equal to 10
       not_equal_to_ten:
       add x, 3
       print x,y,0010_1011b, "#"  
       call print_num
       
       sub x, 1
       print x,y,0010_1011b, "#"  
       mov ax, 0
       call print_num
       sub x, 2
       
       SKIP_ETT:
       add y, 1
       print x,y,0010_1011b, "########"
       
       mov y, 6
       add x, 13
    loop PRINT_CASE_V2 
        
    ;Row 3 briefcases
    mov x, 25
    mov y, 11     
    mov cx, 5
    mov si, 10 
    PRINT_CASE_V3:

       print x,y,0010_1011b,    "##"  
       sub x, 3
       add y, 1
       print x,y,0010_1011b, "########"
       add y, 1
       print x,y,0010_1011b, "########"  
       
       ;print num
       add si, 1
       mov ax, si
       add x, 2
       print x,y,0010_1011b, "#"  
       call print_num  
       sub x, 2
       
       add y, 1
       print x,y,0010_1011b, "########"
      
       mov y, 11
       add x, 13
    loop PRINT_CASE_V3 
    
    ;4
    mov x, 25
    mov y, 16     
    mov cx, 5 
    mov si, 15
    PRINT_CASE_V4:
    
       print x,y,0010_1011b,    "##"  
       sub x, 3
       add y, 1
       print x,y,0010_1011b, "########"
       add y, 1
       print x,y,0010_1011b, "########"
       
       ;print num
       add si, 1
       mov ax, si
       add x, 2
       print x,y,0010_1011b, "#"  
       call print_num  
       sub x, 2
       
       add y, 1
       print x,y,0010_1011b, "########"
       
          
       mov y, 16
       add x, 13
    loop PRINT_CASE_V4 


  print 74,1,0010_1011b,  "###"
  print 74,2,0010_1011b,  "# #"
  print 74,3,0010_1011b,  "# #"
  print 74,4,0010_1011b,  "#R#"
  print 74,5,0010_1011b,  "#O#"
  print 74,6,0010_1011b,  "#U#"
  print 74,7,0010_1011b,  "#N#"
  print 74,8,0010_1011b,  "#D#"
  print 74,9,0010_1011b,  "# #"
  print 74,10,0010_1011b, "#0#"
  print 74,11,0010_1011b, "# #"
  print 74,12,0010_1011b, "###"
  print 74,13,0010_1011b, "# #"
  print 74,14,0010_1011b, "# #"
  print 74,15,0010_1011b, "#P#"
  print 74,16,0010_1011b, "#I#"
  print 74,17,0010_1011b, "#C#"
  print 74,18,0010_1011b, "#K#"
  print 74,19,0010_1011b, "# #"
  print 74,20,0010_1011b, "#0#"
  print 74,21,0010_1011b, "# #"
  print 74,22,0010_1011b, "###"
  
    
 ;set num 
 mov si, 40
 mov cx, 20
 set_tn:
     sub si, 2
     mov tn[si], cx
 loop set_tn
 
  
 mov temp, 0  ;Set temp to zero to input Main Case
 
 ;UMI = User Main Input, CUMI Check User Main Input
 INPUT_UMI:
 print 24,22,0000_0111b,"Choose main briefcase number : "
 
 push cx
   call scan_num
   mov ax, cx   
   mov mc, cx
 pop cx
 
 push cx
   mov si, 0
   mov cx, 20
   ;Check user main input  
 
   CHECK_USER_MAIN_INPUT:
 
     mov bx, tn[si]
     cmp ax, bx   
     JE EXIT_CUMI  
     add si, 2   
 
   loop CHECK_USER_MAIN_INPUT
 pop cx   
 
 ;If invalid input
 INVALID_CUMI:
 print 60, 22, 0000_1100b, "INVALID INPUT"
 print 54,22,0000_0111b,"      "  
 JMP INPUT_UMI
     
  ;If input is valid proceed here.
 EXIT_CUMI:
 pop cx 
 mov bx, 0
 cmp ax, bx
 JE INVALID_CUMI
 

 ;Delete the current message                                 
 print 24,22,0000_0111b,"                                      ";;;
 print 60, 22, 0000_0111b, "             ";   
                                         
 ;Display Input Confirmation
 print 24,22,0000_0111b,"Are you sure you want "
 print 46,22,0000_1010b,"Briefcase    "
 print 56,22,0000_1010b," "
 mov ax, tn[si] ; Get the default case or chosen case and display
 call print_num     
 
 YN_INPUT: ;If invalid input jump here.
 print 24,23,0000_1100b,"No[0]" 
 print 29,23,0000_0111b," || " 
 print 33,23,0000_1011b,"Yes[1]"
 print 40,23,0000_0111b ," : "
  
 call scan_num  ;Input  0 or 1 onl
 mov ui, cx    ; store to UI
 
 mov ax, ui    ; Store to ax                 
 mov bx, 0     ; set bx to 0
 cmp ax, bx    ; then compare
 je A_NO ; Answer_NO
 
 mov bx, 1     ; Same as to A_No
 cmp ax, bx
 je A_YES ; Answer_YES 
 
 ;If invalid input
  print 45, 23, 0000_1100b, "INVALID INPUT"
  print 41,23,0000_0111b,"    ";;;
  JMP YN_INPUT ; Yes No Input
 
 
 A_NO: ; Answer is NO                                          
 
 ;Delete the current message                                   
   print 24,22,0000_0111b,"                                     ";;;
   print 23,23,0000_0111b,"                      ";;; 
   print 46,23,0000_0111b,"               ";;;
   print 41,23,0000_0111b,"    ";;;        
   jmp INPUT_UMI                               
 
 A_YES:                                                       
    print 24,22,0000_0111b,"                                    ";;;
   print 23,23,0000_0111b,"                        ";;; 
   print 46,23,0000_0111b,"                 ";;;
   print 41,23,0000_0111b,"    ";;;        
   mov mc_index_tmp, si
   mov tn[si], 0  ; Set to zero to disable the already chosen.
                                             
  ; CODE PA NG PALIT KULAY NG BRIEFCASE !!!!!
  ;;
  ;              
  mov mc_temp, 0              
  mov ax, mc
  JMP COLOR_THE_MAIN_CASE
  GO_BACK_TO_TOP:      
  mov al, 0100_1010b
  mov case_color, al
  mov mc_temp, 1    

    mov ml[0], 1
    mov ml[2], 5  
    mov ml[4], 10
    mov ml[6], 15
    mov ml[8], 20
    mov ml[10], 25
    mov ml[12], 30
    mov ml[14], 35
    mov ml[16], 50
    mov ml[18], 75    
    mov ml[20], 100
    mov ml[22], 150
    mov ml[24], 200
    mov ml[26], 250
    mov ml[28], 300
    mov ml[30], 350
    mov ml[32], 400
    mov ml[34], 450
    mov ml[36], 500
    mov ml[38], 1000
    
print 75,10,0010_1011b, "1"  
print 75,20,0010_1011b, "5"
    
mov r, 1
mov p, 0   
mov si, 0 
mov cx, 20 ;Set number of loop 
mov sc, 0         
LOOP_ROUND:        
     mov mc_money_tmp, cx                   
     mov cxlooptemp, cx   
     
     INPUT_NUMBER_CASE: ;UNC                                 ;
     print 24,22,0000_0111b,"Choose briefcase number : "  
     
     push cx ; push cx avoid replacing the value of cx number loop
       call scan_num
       mov ax, cx
       mov ui, cx 
     pop cx  ;pop
     
     ;;;;;;;;;;;;;;;;;;;;
     push cx
       mov si, 0 
       mov cx, 20
       CHK_INPUT:  
         ;add sc, 1
           mov ax, ui
           mov bx,tn[si]
           cmp ax, bx  
           JE EXIT_CHK_INPUT  
           add si, 2 
       loop CHK_INPUT
       
       INVALID_CHK_INPUT:
       ;If invalid input                       
     pop cx ; second cx  
       mov sc, 0                        
       mov si, 0
       print 60, 22, 0000_1100b, "INVALID INPUT"
       print 50,22,0000_0111b,"          "  
       
       JMP INPUT_NUMBER_CASE
     
        ;If input is valid proceed here.
      EXIT_CHK_INPUT:
         mov ax, ui
         mov bx, 0
         cmp ax, bx
      je INVALID_CHK_INPUT
     pop cx;2nd cx       
     
     push cx
      mov cx, cn[si]
      mov ax, cx
      mov temp, cx
     pop cx
     
     ;Delete the current message                                 
     print 24,22,0000_0111b,"                                      ";;;
     print 60, 22, 0000_0111b,"             ";;;   
         
     ;Display Input Confirmation
     print 24,22,0000_0111b,"Are you sure you want "
     print 46,22,0000_1010b,"Briefcase    "
     print 56,22,0000_1010b," "
     mov ax, ui ; Get the default case or chosen case and display
     call print_num     
 
     YN_CHK_INPUT: ;If invalid input jump here.
     print 24,23,0000_1100b,"No[0]" 
     print 29,23,0000_0111b," || " 
     print 33,23,0000_1011b,"Yes[1]"
     print 40,23,0000_0111b ," : "
     
     push cx
      call scan_num  ;Input  0 or 1 onl
      mov yn, cx    ; store to UI
     pop cx ; second cx  
     
      mov ax, yn    ; Store to ax                 
      mov bx, 0     ; set bx to 0
      cmp ax, bx    ; then compare
      je A_CHK_NO ; Answer_NO
     
     mov bx, 1     ; Same as to A_No
     cmp ax, bx
     je A_CHK_YES ; Answer_YES 
 
     ;If invalid input
     print 45, 23, 0000_1100b, "INVALID INPUT"
     print 42,23,0000_0111b,"    ";;;
     JMP YN_CHK_INPUT ; Yes No Input
 
 
     A_CHK_NO: ; Answer is NO                                          
 
     ;Delete the current message                                   
     print 24,22,0000_0111b,"                                     ";;;
     print 23,23,0000_0111b,"                     ";;; 
     print 45,23,0000_0111b,"              ";;;
     print 42,23,0000_0111b,"  ";;;        
        mov sc, 0                        
       mov si, 0
     
     jmp INPUT_NUMBER_CASE                              
 
     A_CHK_YES:                                                       
     print 24,22,0000_0111b,"                                    ";;;
     print 23,23,0000_0111b,"                       ";;; 
     print 45,23,0000_0111b,"                ";;;
     print 42,23,0000_0111b,"  ";;;        
        push cx
        mov ax, cn[si]
        ;mov a1000a, ax ;;;;;;
        mov cx, tm
        sub cx, ax
        mov tm, cx
        pop cx    
        
        mov ax, ui           
        COLOR_THE_MAIN_CASE:
        mov y, 1
        mov bx, 1
        cmp ax, bx
        JE pc_one
        
        mov bx, 2
        cmp ax, bx
        JE pc_two
        
        mov bx, 3
        cmp ax, bx
        JE pc_three
        
        mov bx, 4
        cmp ax, bx
        JE pc_four
        
        mov bx, 5
        cmp ax, bx
        JE pc_five   
        
        mov y, 6

        mov bx, 6
        cmp ax, bx
        JE pc_one
                
        mov bx, 7
        cmp ax, bx
        JE pc_two
        
        mov bx, 8
        cmp ax, bx
        JE pc_three
        
        mov bx, 9
        cmp ax, bx
        JE pc_four
        
        mov bx, 10
        cmp ax, bx
        JE pc_five
        
        mov y,11

        mov bx, 11
        cmp ax, bx
        JE pc_one
                
        mov bx, 12
        cmp ax, bx
        JE pc_two
        
        mov bx, 13
        cmp ax, bx
        JE pc_three
        
        mov bx, 14
        cmp ax, bx
        JE pc_four
        
        mov bx, 15
        cmp ax, bx
        JE pc_five
        
        mov y, 16    
        
        mov bx, 16
        cmp ax, bx
        JE pc_one
        
        mov bx, 17
        cmp ax, bx
        JE pc_two
        
        mov bx, 18
        cmp ax, bx
        JE pc_three
        
        mov bx, 19
        cmp ax, bx
        JE pc_four
        
        mov bx, 20
        cmp ax, bx
        JE pc_five
        
        
        pc_one:
          mov x, 25
          jmp PC_PRINT
        pc_two:
          mov x, 35   
          jmp PC_PRINT
        pc_three:
          mov x, 45   
          jmp PC_PRINT
        pc_four:
          mov x, 55   
          jmp PC_PRINT
        pc_five:
          mov x, 65   
          jmp PC_PRINT
        
        PC_PRINT:
        print x,y,case_color,    "##"  
        sub x, 3
        add y, 1
        print x,y,case_color, "########"
        add y, 1
        print x,y,case_color, "########"  
        add y, 1
        print x,y,case_color, "########"
        sub y, 1
        
        ;FOR MAIN
        mov ax, mc_temp
        mov bx, 1
        cmp ax, bx
        je SKIP_THIS_REG
        mov ax, mc
        mov bx, 1
        cmp ax, bx
        je ONE_MC
        
        mov bx, 2
        cmp ax, bx
        je TWO_MC
        
        mov bx, 3
        cmp ax, bx
        je THREE_MC
        
        mov bx, 4
        cmp ax, bx
        je FOUR_MC
        
        mov bx, 5
        cmp ax, bx
        je FIVE_MC
        
        mov bx, 6
        cmp ax, bx
        je SIX_MC
        
        mov bx, 7
        cmp ax, bx
        je SEVEN_MC
        
        mov bx, 8
        cmp ax, bx
        je EIGHT_MC
        
        mov bx, 9
        cmp ax, bx
        je NINE_MC
        
        mov bx, 10
        cmp ax, bx
        je TEN_MC
        
        mov bx, 11
        cmp ax, bx
        je ELEVEN_MC
        
        mov bx, 12
        cmp ax, bx
        je TWELVE_MC
        
        mov bx, 13
        cmp ax, bx
        je THIRTEEN_MC
        
        mov bx, 14
        cmp ax, bx
        je FOURTEEN_MC
        
        mov bx, 15
        cmp ax, bx
        je FIFTEEN_MC
        
        mov bx, 16
        cmp ax, bx
        je SIXTEEN_MC
        
        mov bx, 17
        cmp ax, bx
        je SEVENTEEN_MC
        
        mov bx, 18
        cmp ax, bx
        je EIGHTEEN_MC
        
        mov bx, 19
        cmp ax, bx
        je NINETEEN_MC
        
        mov bx, 20
        cmp ax, bx
        je TWENTY_MC
        
        ONE_MC:
        print 25,3,case_color, "01"  
        JMP GO_BACK_TO_TOP
        TWO_MC:
        print 35,3,case_color, "02"  
        JMP GO_BACK_TO_TOP
        THREE_MC:
        print 45,3,case_color, "03"  
        JMP GO_BACK_TO_TOP
        FOUR_MC:
        print 55,3,case_color, "04"  
        JMP GO_BACK_TO_TOP
        FIVE_MC:
        print 65,3,case_color, "05"  
        JMP GO_BACK_TO_TOP
        SIX_MC:
        print 25,8,case_color, "06"  
        JMP GO_BACK_TO_TOP
        SEVEN_MC:
        print 35,8,case_color, "07"  
        JMP GO_BACK_TO_TOP
        EIGHT_MC:
        print 45,8,case_color, "08"  
        JMP GO_BACK_TO_TOP
        NINE_MC:
        print 55,8,case_color, "09"  
        JMP GO_BACK_TO_TOP
        TEN_MC:
        print 65,8,case_color, "10"  
        JMP GO_BACK_TO_TOP
        ELEVEN_MC:
        print 25,13,case_color, "11"  
        JMP GO_BACK_TO_TOP
        TWELVE_MC:
        print 35,13,case_color, "12"  
        JMP GO_BACK_TO_TOP
        THIRTEEN_MC:
        print 45,13,case_color, "13"  
        JMP GO_BACK_TO_TOP
        FOURTEEN_MC:
        print 55,13,case_color, "14"  
        JMP GO_BACK_TO_TOP
        FIFTEEN_MC:
        print 65,13,case_color, "15"  
        JMP GO_BACK_TO_TOP
        SIXTEEN_MC:
        print 25,18,case_color, "16"  
        JMP GO_BACK_TO_TOP
        SEVENTEEN_MC:
        print 35,18,case_color, "17"  
        JMP GO_BACK_TO_TOP
        EIGHTEEN_MC:
        print 45,18,case_color, "18"  
        JMP GO_BACK_TO_TOP
        NINETEEN_MC:
        print 55,18,case_color, "19"  
        JMP GO_BACK_TO_TOP
        TWENTY_MC:
        print 65,18,case_color, "20"  
        JMP GO_BACK_TO_TOP
        
        ;FOR MAIN COLORING END
        SKIP_THIS_REG:
        mov ax, cn[si]
        
        mov bx, 1
        cmp ax, bx
        je pc_single
        
        mov bx, 5
        cmp ax, bx
        je pc_single
         
        mov bx, 10
        cmp ax, bx
        je pc_double
        
        mov bx, 15
        cmp ax, bx
        je pc_double
        
        mov bx, 20
        cmp ax, bx
        je pc_double
        
        mov bx, 25
        cmp ax, bx
        je pc_double
        
        mov bx, 30
        cmp ax, bx
        je pc_double
        
        mov bx, 35
        cmp ax, bx
        je pc_double
        
        mov bx, 50
        cmp ax, bx
        je pc_double
        
        mov bx, 75
        cmp ax, bx
        je pc_double
        
        mov bx, 100
        cmp ax, bx
        je pc_triple
        
        mov bx, 150
        cmp ax, bx
        je pc_triple
        
        mov bx, 200
        cmp ax, bx
        je pc_triple
        
        mov bx, 250
        cmp ax, bx
        je pc_triple
        
        mov bx, 300
        cmp ax, bx
        je pc_triple
        
        mov bx, 350
        cmp ax, bx
        je pc_triple
        
        mov bx, 400
        cmp ax, bx
        je pc_triple
        
        mov bx, 450
        cmp ax, bx
        je pc_triple
        
        mov bx, 500
        cmp ax, bx
        je pc_triple
        
        mov bx, 1000
        cmp ax, bx
        je pc_quad
        
        
        pc_single: 
        add x, 2
        print x,y,case_color, "-" 
        mov ax, cn[si]
        call print_num   
        add x, 2
        print x,y,case_color,"--"
        jmp skip_pc_all
        
        pc_double:
        add x, 2
        print x,y,case_color, "-"  
        mov ax, cn[si]
        call print_num   
        add x, 3
        print x,y,case_color,"-"  
        jmp skip_pc_all
        
        pc_triple: 
        add x, 2
        print x,y,case_color, "-"   
        mov ax, cn[si]
        call print_num 
        jmp skip_pc_all
        
        pc_quad:     
        add x, 1
        print x,y,case_color, "#" 
        mov ax, cn[si]
        call print_num  
        jmp skip_pc_all
        
        
        skip_pc_all:
        
        push cx
          mov cx, cn[si]
          mov ax, temp
          mov ax, cx
          mov temp, ax   
        pop cx
        mov tn[si], 0  ; Set to zero to disable the already chosen.
        mov cn[si], 0
     
        push cx
        mov sc, 0
        mov si, 0
        mov cx,20
        
        CHECK_INPUT_MONEY_LP:  ;internal loop
          add sc, 1
          mov ax, ml[si]   
          push cx
           mov cx, temp
           mov bx, cx
          
           cmp ax, bx                              
           je EXIT_CIM_LOOP_LP ;exit the loop if input is valid
          pop cx
          
          add si, 2
               
        loop CHECK_INPUT_MONEY_LP
        
        EXIT_CIM_LOOP_LP: 
        pop cx
        mov ah,sc 
        mov bh,10
        cmp ah, bh         
        jg RIGHT_COL_LP 
            
        add sc, 13
        print 2,sc, 0100_1010b,"       "
        print 4,sc,0100_1010b," " 
        mov ax, temp 
        call print_num
        
        JMP PASS_RIGHT_COL_LP
                
        RIGHT_COL_LP:      
        add sc, 3
        print 11,sc, 0100_1010b,"       "
        print 12,sc,0100_1010b," " 
        mov ax, temp
        call print_num    
        
        PASS_RIGHT_COL_LP:  
        mov ml[si], 0
        mov sc, 0                        
        mov si, 0
        SUB tc, 1           ;else "tc - 1"    
        
        JMP SKIP_THIS_1000  
     ;;;;;;;;;;;;;;THIS   
        
      GO_BACK_HERE_1000!:  
      mov cx, cxlooptemp
      
      
      SKIP_THIS_1000:
      mov temp, 0   
      
        ;CHECK NUMBER OF CASE
         mov ax, tc
         mov bx, 2
         cmp ax, bx
         Jg ROUNDCOUNT 
     ROUNDCOUNT:
     ;ROUND NUMBER CHECK
      mov ax, r
      mov bx, 1
      CMP ax, bx
      JE ROUNDONE 
      
      mov ax, r
      mov bx, 2
      CMP ax, bx
      JE ROUNDTWO 
      
      mov ax, r
      mov bx, 3
      CMP ax, bx
      JE ROUNDTHREE 
      
      mov ax, r
      mov bx, 4
      CMP ax, bx
      JE ROUNDFOURFIVE
      
      mov ax, r
      mov bx, 5
      CMP ax, bx
      JE ROUNDFOURFIVE 
      
      mov ax, r
      mov bx, 6
      CMP ax, bx
      JE ROUNDSIXSEVEN 
      
      mov ax, r
      mov bx, 7
      CMP ax, bx
      JE ROUNDSIXSEVEN 
        
    ;SUB ROUND NUMBER CHECK     
    ;5 4 3 2 2 1 1
    
    ;ROUND ONE
    ROUNDONE:    
      mov ax, tmp_r
      mov bx, 0   
      cmp ax, bx
      JE ONE_SET_PICK
      
      ONE_ROUND_BACK:  
      mov tmp_r, 1
      SUB p, 1
      mov ax, p
      mov bx, 0   
      CMP ax, bx
      JE NEXTROUND  ;IF 0 NEXT ROUND
      print 74,20,0010_1011b, "#"
      mov ax, p
      call print_num
      JMP SKIP_THIS ;ELSE JUMP TO INPUTCASE
    
      ONE_SET_PICK:
         mov ax,p
         add ax, 5
         mov p, ax
         JMP ONE_ROUND_BACK
    ;END ROUND ONE
    
    ;ROUND TWO
    ROUNDTWO:    
      mov ax, tmp_r
      mov bx, 0   
      cmp ax, bx
      JE TWO_SET_PICK
      
      TWO_ROUND_BACK:  
      mov tmp_r, 1
      SUB p, 1
      mov ax, p
      mov bx, 0   
      CMP ax, bx
      JE NEXTROUND  ;IF 0 NEXT ROUND
      print 74,20,0010_1011b, "#"
      mov ax, p
      call print_num
      
      JMP SKIP_THIS ;ELSE JUMP TO INPUTCASE
    
      TWO_SET_PICK:   
         mov ax,p
         add ax, 4
         mov p, ax
         JMP TWO_ROUND_BACK
    ;END ROUND TWO
    
    ;ROUND THREE
    ROUNDTHREE:    
      mov ax, tmp_r
      mov bx, 0   
      cmp ax, bx
      JE THREE_SET_PICK
      
      THREE_ROUND_BACK:  
      mov tmp_r, 1
      SUB p, 1
      mov ax, p
      mov bx, 0   
      CMP ax, bx
      JE NEXTROUND  ;IF 0 NEXT ROUND
      print 74,20,0010_1011b, "#"
      mov ax, p
      call print_num
      
      JMP SKIP_THIS ;ELSE JUMP TO INPUTCASE
    
      THREE_SET_PICK:
         mov ax,p
         add ax, 3
         mov p, ax
         JMP THREE_ROUND_BACK
    ;END ROUND THREE
    
    ;ROUND FOUR FIVE
    ROUNDFOURFIVE:    
      mov ax, tmp_r
      mov bx, 0   
      cmp ax, bx
      JE FOURFIVE_SET_PICK
      
      FOURFIVE_ROUND_BACK:  
      mov tmp_r, 1
      SUB p, 1
      mov ax, p
      mov bx, 0   
      CMP ax, bx
      JE NEXTROUND  ;IF 0 NEXT ROUND
      print 74,20,0010_1011b, "#"
      mov ax, p
      call print_num
        
      JMP SKIP_THIS ;ELSE JUMP TO INPUTCASE
    
      FOURFIVE_SET_PICK:
         mov ax,p
         add ax, 2
         mov p, ax
         JMP FOURFIVE_ROUND_BACK
    ;END ROUND FOUR FIVE
    
    ;ROUND SIX SEVEN
    ROUNDSIXSEVEN:    
      mov ax, tmp_r
      mov bx, 0   
      cmp ax, bx
      JE SIXSEVEN_SET_PICK
      
      SIXSEVEN_ROUND_BACK:  
      mov tmp_r, 1
      SUB p, 1
      mov ax, p
      mov bx, 0   
      CMP ax, bx
      JE NEXTROUND  ;IF 0 NEXT ROUND
      print 74,20,0010_1011b, "#"
      mov ax, p
      call print_num
     
      JMP SKIP_THIS ;ELSE JUMP TO INPUTCASE
    
      SIXSEVEN_SET_PICK:
         mov ax,p
         add ax, 1
         mov p, ax
         JMP SIXSEVEN_ROUND_BACK
    ;END ROUND SIX SEVEN
    
    
    
    ;next round
    NEXTROUND:    
      print 74,20,0010_1011b, "#"
      mov ax, p
      call print_num
      mov ax, r
      add ax, 1
      mov r, ax
      mov tmp_r, 0
      
    SHOW_BANKERS_OFFER:  
       mov ax, tm
       mov dx, 0
       idiv tc  ; ax = (dx ax) / num2.
       
       ;mov tm, ax 
       mov bo, ax
       mov ax, bo
       print 24,22,0000_0111b "Bankers Offer is now : "
       call print_num    ; print ax value.
            
       ;mov ax,r
       ;mov bx, 1
       ;CMP ax, bx
       ;JE PRINT_BANKERS_OFFER_TABLE_1
       
       mov ax,r
       mov bx, 2
       CMP ax, bx
       JE PRINT_BANKERS_OFFER_TABLE_2
       
       mov ax,r
       mov bx, 3
       CMP ax, bx
       JE PRINT_BANKERS_OFFER_TABLE_3
       
       mov ax,r
       mov bx, 4
       CMP ax, bx
       JE PRINT_BANKERS_OFFER_TABLE_4
    
       mov ax,r
       mov bx, 5
       CMP ax, bx
       JE PRINT_BANKERS_OFFER_TABLE_5
    
       mov ax,r
       mov bx, 6
       CMP ax, bx
       JE PRINT_BANKERS_OFFER_TABLE_6
    
       mov ax,r
       mov bx, 7
       CMP ax, bx
       JE PRINT_BANKERS_OFFER_TABLE_7
       
       mov ax,r
       mov bx, 8
       CMP ax, bx
       JE PRINT_BANKERS_OFFER_TABLE_8
         
         
    ;PRINT_BANKERS_OFFER_TABLE_1:
      ; print 6,3,0010_0111b,  " "   
     ;  mov ax, bo
       ;call print_num      
       ;JMP DEALORNODEAL     
       
    PRINT_BANKERS_OFFER_TABLE_2:
       print 6,3,0010_0111b,  " " 
       mov ax, bo
       call print_num    
       JMP DEALORNODEAL     
       
    PRINT_BANKERS_OFFER_TABLE_3:
       print 6,4,0010_0111b,  " "
       mov ax, bo
       call print_num    
       JMP DEALORNODEAL     
       
    PRINT_BANKERS_OFFER_TABLE_4:
       print 6,5,0010_0111b,  " "
       mov ax, bo
       call print_num    
       JMP DEALORNODEAL     
       
    PRINT_BANKERS_OFFER_TABLE_5:
       print 6,6,0010_0111b,  " "
       mov ax, bo
       call print_num    
       JMP DEALORNODEAL     
          
    PRINT_BANKERS_OFFER_TABLE_6:
       print 6,7,0010_0111b,  " "
       mov ax, bo
       call print_num    
       JMP DEALORNODEAL     
     
    PRINT_BANKERS_OFFER_TABLE_7:
       print 6,8,0010_0111b,  " "
       mov ax, bo
       call print_num    
       JMP DEALORNODEAL     
    
    PRINT_BANKERS_OFFER_TABLE_8:
        print 6,9,0010_0111b,  " "
        mov ax, bo
        call print_num    
        JMP DEALORNODEAL     
           
    ;DEAL OR NO DEAL   
    DEALORNODEAL:           
       ;RESET HIGHEST MONEY
       
       ;ASK USER, DEAL [0] OR NO DEAL [1]
       print 24,23,0000_0111b,  "DEAL     OR NO DEAL"   
       print 28,23,0000_1100b,  "[0]"
       print 43,23,0000_1011b,  "[1]"
          
       
       ;READ USER INPUT
       push cx
        call scan_num             
        mov ui, cx 
        mov ax, ui
       pop cx
         
       mov bx, 0
       cmp ax, bx
       je DEAL
       
       mov bx, 1
       cmp ax, bx
       je NODEAL            
                        
       print 50,23,0000_1100b,  "INVALID INPUT"   
       print 46,23,0000_0111b,  "    "   
       JMP DEALORNODEAL
       
    DEAL:                                                 
       print 24,22,0000_0111b "                            "
       print 24,23,0000_1011b,  "                                           ";   
       
       print 24,22,0000_0111b,  "            "   
       print 24,23,0000_0111b,  "Congratulations! You won : "   
       mov ax, bo
       call print_num 
       JMP GAME_EXIT
    NODEAL: 
     print 24,22,0000_0111b  "                               ";                                             
     print 24,23,0000_1011b,  "                                            ";   
     
     print 74,10,0010_1011b, "#"
     mov ax, r
     call print_num  
     
     mov bx, 2
     cmp ax, bx
     JE print_pick_2
     
     mov bx, 3
     cmp ax, bx
     JE print_pick_3
     
     mov bx, 4
     cmp ax, bx
     JE print_pick_45
     
     mov bx, 5
     cmp ax, bx
     JE print_pick_45
     
     mov bx, 6
     cmp ax, bx
     JE print_pick_67
     
     mov bx, 7
     cmp ax, bx
     JE print_pick_67
     
     print_pick_2:
     print 75,20,0010_1011b, "4"
     JMP SKIP_THIS
     print_pick_3:
     print 75,20,0010_1011b, "3"
     JMP SKIP_THIS
     print_pick_45:
     print 75,20,0010_1011b, "2"
     JMP SKIP_THIS                  
     print_pick_67:
     print 75,20,0010_1011b, "1"
     
       mov bo, 0 
       MOV ax, tc
       MOV bx, 2  
       CMP ax, bx
       JE F_NO_DEAL  
                         
                       
    SKIP_THIS:   
       
       mov cx,mc_index_tmp
       
       mov bo, 0 
       MOV ax, tc
       MOV bx, 2  
       CMP ax, bx
       JE F_NO_DEAL  
               
                                        
loop LOOP_ROUND
   
    
FINAL_ROUND:        


  ;Proceed here if there are two briefcase only.
  print 24,22,0000_0111b,  "FINAL ROUND"   
  print 24,23,0000_0111b,  "DEAL     OR NO DEAL"   
  print 28,23,0000_1100b,  "[0]"
  print 43,23,0000_1011b,  "[1]"
  F_DORNOD:
  call scan_num
  mov ax, cx
          
  mov bx, 0
  cmp ax, bx
  je F_DEAL
  
  mov bx, 1
  cmp ax, bx
  je F_NO_DEAL
   
  print 50,23,0000_1001b,  "INVALID INPUT"  
  mov ax, 0                                  
  JMP F_DORNOD  ;If invalid input again
  
  F_DEAL:                                  
    print 50,23,0000_1001b,  "             ";  
    print 24,22,0000_0111b,  "            "      ;
    print 24,23,0000_0111b,  "                    "   
    print 24,23,0000_0111b,  "Congratulations! You won : "   
    mov ax, bo
    call print_num 
    JMP GAME_EXIT
      
  F_NO_DEAL:                                
    print 50,23,0000_1001b,  "             ";
    print 24,22,0000_0111b,  "            "   
    print 24,23,0000_0111b,  "                    "   
    print 24,23,0000_0111b,  "Congratulations! You won : "   
    mov si, mc_index_tmp
    mov ax, cn[si]
    call print_num
    
GAME_EXIT:
 
mov cx, 20
mov si, 0

GAME_EXIT_LOOP:
        mov ax, mc_temp
        mov bx, 1
        cmp ax, bx
        je SKIP_TN_GE_LOOP       
        
        push cx
          mov cx, 20
          mov si, 0
          INNER_GE_LOOP:     
             ;mov ax, tn[si]       
             ;mov bx, mc
             ;cmp ax, bx
             ;JE INNER_GE_SKIP        
             
             mov ax, tn[si]
             mov bx, 0  
             cmp ax, bx                 
             JNE EXIT_INNER_GE_LOOP    
             
             ;INNER_GE_SKIP:
             add si, 2
          loop INNER_GE_LOOP  
        pop cx
          JMP EXIT_GAME_EXIT_LOOP
        
        SKIP_TN_GE_LOOP:
         mov ah, 1111_0000b    
         mov case_color, ah
         mov si, mc_index_tmp
         mov ax, mc
         jmp SKIP_EIGL ; exit inner ge loop
         
        EXIT_INNER_GE_LOOP: 
        pop cx
        mov ax, tn[si]
        
        SKIP_EIGL:
        mov y, 1
        mov bx, 1
        cmp ax, bx
        JE pc_one_GE
        
        mov bx, 2
        cmp ax, bx
        JE pc_two_GE
        
        mov bx, 3
        cmp ax, bx
        JE pc_three_GE
        
        mov bx, 4
        cmp ax, bx
        JE pc_four_GE
        
        mov bx, 5
        cmp ax, bx
        JE pc_five_GE   
        
        mov y, 6

        mov bx, 6
        cmp ax, bx
        JE pc_one_GE
                
        mov bx, 7
        cmp ax, bx
        JE pc_two_GE
        
        mov bx, 8
        cmp ax, bx
        JE pc_three_GE
        
        mov bx, 9
        cmp ax, bx
        JE pc_four_GE
        
        mov bx, 10
        cmp ax, bx
        JE pc_five_GE
        
        mov y,11

        mov bx, 11
        cmp ax, bx
        JE pc_one_GE
                
        mov bx, 12
        cmp ax, bx
        JE pc_two_GE
        
        mov bx, 13
        cmp ax, bx
        JE pc_three_GE
        
        mov bx, 14
        cmp ax, bx
        JE pc_four_GE
        
        mov bx, 15
        cmp ax, bx
        JE pc_five_GE
        
        mov y, 16    
        
        mov bx, 16
        cmp ax, bx
        JE pc_one_GE
        
        mov bx, 17
        cmp ax, bx
        JE pc_two_GE
        
        mov bx, 18
        cmp ax, bx
        JE pc_three_GE
        
        mov bx, 19
        cmp ax, bx
        JE pc_four_GE
        
        mov bx, 20
        cmp ax, bx
        JE pc_five_GE
        
        
        pc_one_GE:
          mov x, 25
          jmp PC_PRINT_GE
        pc_two_GE:
          mov x, 35   
          jmp PC_PRINT_GE
        pc_three_GE:
          mov x, 45   
          jmp PC_PRINT_GE
        pc_four_GE:
          mov x, 55   
          jmp PC_PRINT_GE
        pc_five_GE:
          mov x, 65   
          jmp PC_PRINT_GE
        
        PC_PRINT_GE:
        print x,y,case_color,    "##"  
        sub x, 3
        add y, 1
        print x,y,case_color, "########"
        add y, 1
        print x,y,case_color, "########"  
        add y, 1
        print x,y,case_color, "########"
        sub y, 1
        
        
        mov ax, cn[si]
        
        mov bx, 1
        cmp ax, bx
        je pc_single_GE
        
        mov bx, 5
        cmp ax, bx
        je pc_single_GE
         
        mov bx, 10
        cmp ax, bx
        je pc_double_GE
        
        mov bx, 15
        cmp ax, bx
        je pc_double_GE
        
        mov bx, 20
        cmp ax, bx
        je pc_double_GE
        
        mov bx, 25
        cmp ax, bx
        je pc_double_GE
        
        mov bx, 30
        cmp ax, bx
        je pc_double_GE
        
        mov bx, 35
        cmp ax, bx
        je pc_double_GE
        
        mov bx, 50
        cmp ax, bx
        je pc_double_GE
        
        mov bx, 75
        cmp ax, bx
        je pc_double_GE
        
        mov bx, 100
        cmp ax, bx
        je pc_triple_GE
        
        mov bx, 150
        cmp ax, bx
        je pc_triple_GE
        
        mov bx, 200
        cmp ax, bx
        je pc_triple_GE
        
        mov bx, 250
        cmp ax, bx
        je pc_triple_GE
        
        mov bx, 300
        cmp ax, bx
        je pc_triple_GE
        
        mov bx, 350
        cmp ax, bx
        je pc_triple_GE
        
        mov bx, 400
        cmp ax, bx
        je pc_triple_GE
        
        mov bx, 450
        cmp ax, bx
        je pc_triple_GE
        
        mov bx, 500
        cmp ax, bx
        je pc_triple_GE
        
        mov bx, 1000
        cmp ax, bx
        je pc_quad_GE 
        
        
        pc_single_GE: 
        add x, 2
        print x,y,case_color, "-" 
        mov ax, bx
        call print_num   
        add x, 2
        print x,y,case_color,"--"
        jmp skip_pc_all_GE
        
        pc_double_GE:
        add x, 2
        print x,y,case_color, "-"  
        mov ax, bx
        call print_num   
        add x, 3
        print x,y,case_color,"-"  
        jmp skip_pc_all_GE
        
        pc_triple_GE: 
        add x, 2
        print x,y,case_color, "-"   
        mov ax, bx
        call print_num 
        jmp skip_pc_all_GE
        
        pc_quad_GE:
        add x, 1
        print x,y,case_color, "#" 
        mov ax, bx
        call print_num  
        jmp skip_pc_all_GE
        
        skip_pc_all_GE:
        
        
        mov ax, cn[si]
        mov temp, ax   
        
        mov tn[si], 0  ; Set to zero to disable the already chosen.
        mov cn[si], 0
     
        push cx
        mov sc, 0
        mov si, 0
        mov cx,20
        
        CHECK_INPUT_MONEY_LP_GE:  ;internal loop
          add sc, 1
          mov ax, ml[si]   
          mov bx, temp
          cmp ax, bx                              
          je EXIT_CIM_LOOP_LP_GE ;exit the loop if input is valid
          
          add si, 2
               
        loop CHECK_INPUT_MONEY_LP_GE
        
        EXIT_CIM_LOOP_LP_GE: 
        pop cx
        
        mov ah,sc 
        mov bh,10
        cmp ah, bh         
        jg RIGHT_COL_LP_GE 
            
        add sc, 13
        print 2,sc, 0100_1010b,"       "
        print 4,sc,0100_1010b," " 
        mov ax, temp 
        call print_num
        
        JMP PASS_RIGHT_COL_LP_GE
                
        RIGHT_COL_LP_GE:      
        add sc, 3
        print 11,sc, 0100_1010b,"       "
        print 12,sc,0100_1010b," " 
        mov ax, temp
        call print_num    
        
        PASS_RIGHT_COL_LP_GE: 
        
        mov al, 0100_1010b
        mov case_color, al
        mov ml[si], 0         
        mov mc, 0
        mov mc_temp, 0 
        mov sc, 0                        
        mov si, 0
        
        mov ax, cx
        mov bx, 0
        cmp ax, bx
        je EXIT_GAME_EXIT_LOOP      
        
loop GAME_EXIT_LOOP 
       
EXIT_GAME_EXIT_LOOP:   
print 0,35,0000_0111b,  "Press any key to exit..."   
             
  mov ah, 1
  int 21h  

;add all the money / number_of_case
; jump again to loop if 1000
; double the cn arrange it                                                     

ret
     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; these functions are COPIED FROM EMU8086.INC ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;FOR USER INPUT READER PROCESSES

; gets the multi-digit SIGNED number from the keyboard,
; and stores the result in CX register:
SCAN_NUM        PROC    NEAR
        PUSH    DX
        PUSH    AX
        PUSH    SI
        
        MOV     CX, 0

        ; reset flag:
        MOV     CS:make_minus, 0

next_digit:

        ; get char from keyboard
        ; into AL:
        MOV     AH, 00h
        INT     16h
        ; and print it:
        MOV     AH, 0Eh
        INT     10h

        ; check for MINUS:
        CMP     AL, '-'
        JE      set_minus

        ; check for ENTER key:
        CMP     AL, 0Dh  ; carriage return?
        JNE     not_cr
        JMP     stop_input
not_cr:


        CMP     AL, 8                   ; 'BACKSPACE' pressed?
        JNE     backspace_checked
        MOV     DX, 0                   ; remove last digit by
        MOV     AX, CX                  ; division:
        DIV     CS: tenproc                 ; AX = DX:AX / 10 (DX-rem).
        MOV     CX, AX
        PUTC    ' '                     ; clear position.
        PUTC    8                       ; backspace again.
        JMP     next_digit
backspace_checked:


        ; allow only digits:
        CMP     AL, '0'
        JAE     ok_AE_0
        JMP     remove_not_digit
ok_AE_0:        
        CMP     AL, '9'
        JBE     ok_digit
remove_not_digit:       
        PUTC    8       ; backspace.
        PUTC    ' '     ; clear last entered not digit.
        PUTC    8       ; backspace again.        
        JMP     next_digit ; wait for next input.       
ok_digit:


        ; multiply CX by 10 (first time the result is zero)
        PUSH    AX
        MOV     AX, CX
        MUL     CS:tenproc              ; DX:AX = AX*10
        MOV     CX, AX
        POP     AX

        ; check if the number is too big
        ; (result should be 16 bits)
        CMP     DX, 0
        JNE     too_big

        ; convert from ASCII code:
        SUB     AL, 30h

        ; add AL to CX:
        MOV     AH, 0
        MOV     DX, CX      ; backup, in case the result will be too big.
        ADD     CX, AX
        JC      too_big2    ; jump if the number is too big.

        JMP     next_digit

set_minus:
        MOV     CS:make_minus, 1
        JMP     next_digit

too_big2:
        MOV     CX, DX      ; restore the backuped value before add.
        MOV     DX, 0       ; DX was zero before backup!
too_big:
        MOV     AX, CX
        DIV     CS:tenproc  ; reverse last DX:AX = AX*10, make AX = DX:AX / 10
        MOV     CX, AX
        PUTC    8       ; backspace.
        PUTC    ' '     ; clear last entered digit.
        PUTC    8       ; backspace again.        
        JMP     next_digit ; wait for Enter/Backspace.
        
        
stop_input:
        ; check flag:
        CMP     CS:make_minus, 0
        JE      not_minus
        NEG     CX
not_minus:

        POP     SI
        POP     AX
        POP     DX
        RET
make_minus      DB      ?       ; used as a flag.
SCAN_NUM        ENDP





; this procedure prints number in AX,
; used with PRINT_NUM_UNS to print signed numbers:
PRINT_NUM       PROC    NEAR
        PUSH    DX
        PUSH    AX

        CMP     AX, 0
        JNZ     not_zero

        PUTC    '0'
        JMP     printed

not_zero:
        ; the check SIGN of AX,
        ; make absolute if it's negative:
        CMP     AX, 0
        JNS     positive
        NEG     AX

        PUTC    '-'

positive:
        CALL    PRINT_NUM_UNS
printed:
        POP     AX
        POP     DX
        RET
PRINT_NUM       ENDP
                                  \
; this procedure prints out an unsigned
; number in AX (not just a single digit)
; allowed values are from 0 to 65535 (FFFF)
PRINT_NUM_UNS   PROC    NEAR
        PUSH    AX
        PUSH    BX
        PUSH    CX
        PUSH    DX

        ; flag to prevent printing zeros before number:
        MOV     CX, 1

        ; (result of "/ 10000" is always less or equal to 9).
        MOV     BX, 10000       ; 2710h - divider.

        ; AX is zero?
        CMP     AX, 0
        JZ      print_zero

begin_print:

        ; check divider (if zero go to end_print):
        CMP     BX,0
        JZ      end_print

        ; avoid printing zeros before number:
        CMP     CX, 0
        JE      calc
        ; if AX<BX then result of DIV will be zero:
        CMP     AX, BX
        JB      skip
calc:
        MOV     CX, 0   ; set flag.

        MOV     DX, 0
        DIV     BX      ; AX = DX:AX / BX   (DX=remainder).

        ; print last digit
        ; AH is always ZERO, so it's ignored
        ADD     AL, 30h    ; convert to ASCII code.
        PUTC    AL


        MOV     AX, DX  ; get remainder from last div.

skip:
        ; calculate BX=BX/10
        PUSH    AX
        MOV     DX, 0
        MOV     AX, BX
        DIV     CS:tenproc  ; AX = DX:AX / 10   (DX=remainder).
        MOV     BX, AX
        POP     AX

        JMP     begin_print
        
print_zero:
        PUTC    '0'
        
end_print:

        POP     DX
        POP     CX
        POP     BX
        POP     AX
        RET
PRINT_NUM_UNS   ENDP



tenproc             DW      10      ; used as multiplier/divider by SCAN_NUM & PRINT_NUM_UNS.
GET_STRING      PROC    NEAR
PUSH    AX
PUSH    CX
PUSH    DI
PUSH    DX

MOV     CX, 0                   ; char counter.

CMP     DX, 1                   ; buffer too small?
JBE     empty_buffer            ;

DEC     DX                      ; reserve space for last zero.


;============================
; Eternal loop to get
; and processes key presses:

wait_for_key:

MOV     AH, 0                   ; get pressed key.
INT     16h

CMP     AL, 0Dh                  ; 'RETURN' pressed?
JZ      exit_GET_STRING


CMP     AL, 8                   ; 'BACKSPACE' pressed?
JNE     add_to_buffer
JCXZ    wait_for_key            ; nothing to remove!
DEC     CX
DEC     DI
PUTC    8                       ; backspace.
PUTC    ' '                     ; clear position.
PUTC    8                       ; backspace again.
JMP     wait_for_key

add_to_buffer:

        CMP     CX, DX          ; buffer is full?
        JAE     wait_for_key    ; if so wait for 'BACKSPACE' or 'RETURN'...

        MOV     [DI], AL
        INC     DI
        INC     CX
        
        ; print the key:
        MOV     AH, 0Eh
        INT     10h

JMP     wait_for_key
;============================

exit_GET_STRING:

; terminate by null:
MOV     [DI], 0

empty_buffer:

POP     DX
POP     DI
POP     CX
POP     AX
RET
GET_STRING      ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; these functions are copied from emu8086.inc END;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

END


