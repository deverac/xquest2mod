; Replace a single byte of a file.
;
; To build:
;    debug < hed.asm
;
; Usage:
;    hed.com  OFFSET  VAL  file.bin
;
; The max value of OFFSET is 'FFFFFFFF'; the max value of VAL is 'FF'. The hex
; values of OFFSET and VAL are not validated; non-hex values are accepted, but
; will result in unexpected behavior.
; During processing, the command line is mangled.
;
; This program is free software; it is released under the GNU General Public License version 2.
;
a
jmp 10e                ;---.
mov ah, 9              ;   |    AH=9 Print string$ to stdout
mov dx, 1db            ;   |    DS:DX String$ to print
int 21                 ;   |
mov ax, 4c01           ;   |    AH=4c Exit. AL=01 Error code
int 21                 ;   |
;                      ;   |
;                      ;   |
;                      ;   |    [___Make filename ASCIIZ___]
xor ax, ax             ;<--'    Zero
xor bx, bx             ;        Zero
mov bl, byte ptr [80]  ;        Copy command-line length
cmp bl, 0              ;        Is zero?
je 102                 ;--^     Exit with err
add bl, 81             ;        Add command-line offset
mov byte ptr [bx], al  ;        Terminate command line with \00 (ASCIIZ)
;                      ;
;                      ;        [___Consume spaces___]
mov bx, 80             ;        Reset BX to start of command-line parameters
inc bl                 ;<---.
cmp byte ptr [bx], 0   ;    |   Is eol?
je 109                 ;--^ |   Exit with err
cmp byte ptr [bx], 20  ;    |   Is space?
je 123                 ;----'   Read another char
;                      ;
;                      ;        Read offset; Convert ascii to ord
xor ax, ax             ;        Zero
xor cx, cx             ;        Zero
xor dx, dx             ;        Zero
;                      ;
;                      ;        [___Convert ascii OFFSET to ord___]
shl cx, 4              ;<----.  Move...
mov al, dh             ;     |    ...hi-nyble...
shr al, 4              ;     |      ...of DH...
add cx, ax             ;     |        ...to lo-nyble of CL
;                      ;     |
shl dx, 4              ;     |  Make space for incoming value
cmp byte ptr [bx], 60  ;     |  
jb 14a                 ;---. |  Is lowercase?
sub byte ptr [bx], 20  ;   | |  Convert to upper case
cmp byte ptr [bx], 41  ;<--' |
jb 152                 ;---. |  Is A-F?
sub byte ptr [bx], 7   ;   | |  Prep for ord conversion
sub byte ptr [bx], 30  ;<--' |  Convert to ord val
add dl, byte ptr [bx]  ;     |  Add to OFFSET
inc bx                 ;     |  Move to next char
cmp byte ptr [bx], 0   ;     |  Is eol?
je 109                 ;---^ |  Exit with err
cmp byte ptr [bx], 20  ;     |  Is space?
jne 135                ;-----'  Repeat
push dx                ;        Save lo-word offset
push cx                ;        Save hi-word offset
;                      ;
;                      ;        [___Consume spaces___]
inc bl                 ;<---.   Move to next char
cmp byte ptr [bx], 0   ;    |   Is eol?
je 109                 ;--^ |   Exit with err
cmp byte ptr [bx], 20  ;    |   Is space?
je 164                 ;----'   Read another char
;                      ;
;                      ;        [___Convert ascii VAL to ord___]
xor dx, dx             ;        Zero
shl dx, 4              ;<----.  Make space for incoming val
cmp byte ptr [bx], 60  ;     |  
jb 17d                 ;---. |  Is lowercase?
sub byte ptr [bx], 20  ;   | |  Convert to upper-case
cmp byte ptr [bx], 41  ;<--' |
jb 185                 ;---. |  Is A-F?
sub byte ptr [bx], 7   ;   | |  Prep for ord conversion
sub byte ptr [bx], 30  ;<--' |  Convert to ord val
add dl, byte ptr [bx]  ;     |  Add to VAL
inc bx                 ;     |  Move to next char
cmp byte ptr [bx], 0   ;     |  Is eol?
je 109                 ;--^  |  Exit with err
cmp byte ptr [bx], 20  ;     |  Is space?
jne 172                ;-----'  Repeat
mov byte ptr [81], dl  ;        Store vale in command line
;                      ;
;                      ;        [___Consume spaces___]
inc bl                 ;<----.  Move to next char
cmp byte ptr [bx], 0   ;     |  Is eol?
je 109                 ;--^  |  Exit with err
cmp byte ptr [bx], 20  ;     |  Is space?
je 19b                 ;-----'  Repeat
;                      ;
;                      ;
;                      ;        [___Open file___]
mov dx, bx             ;        DS:DX -> ASCIIZ filename
mov ax, 3d02           ;        AH=3d Open file, AL=02 read/write
int 21                 ;        On err, set CF. On success AX has file handle
jc 109                 ;--^     Exit with err
mov bx, ax             ;        Copy returned file handle to BX
;                      ;
;                      ;        [___Seek file position___]
mov ax, 4200           ;        AH=42 fn, AL=0 seek from start
pop cx                 ;        Hi-word of offset
pop dx                 ;        Lo-word of offset
int 21                 ;        On err, set CF. On success, DX:AX has new file pos
jc 109                 ;--^     Exit with err
;                      ;
;                      ;        [___Write file___]
;                      ;        BX holds file handle
mov cx, 1              ;        Number of bytes to write
mov dl, 81             ;        DS:DX-> pointer to data
mov ah, 40             ;        AH=40 write file
int 21                 ;        On err, set CF
jc 109                 ;--^     Exit with err
;                      ;
;                      ;        [___Close File____]
;                      ;        BX holds file handle
mov ah, 3e             ;        AH=3e Close file
int 21                 ;        On err, set CF
jc 109                 ;--^     Exit with err
;                      ;
;                      ;        [___Exit___]
mov ax, 4c00           ;        AH=4c Exit. AL=00 Error code
int 21                 ;
;                      ;
db "Replace a single byte of a file.", d, a
db "Usage: hed.com  OFFSET  VAL  file.bin", d, a
db "       OFFSET (max: FFFFFFFF) and VAL (max: FF) must be hex chars", d, a
db "       Hex values are not validated.$"
; A blank line to complete assembling.

; Specify filesize, name, write and quit.
r cx 28c
n hed.com
w
q
