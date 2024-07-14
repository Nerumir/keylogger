section .data
    log_file db 'log.txt', 0
    fd      dd 0  ; Variable pour stocker le descripteur de fichier

section .text
    global _start

_start:
    ; Ouvre le fichier output.txt
    mov eax, 5         ; sys_open call
    mov ebx, log_file  ; Pointeur vers le nom du fichier
    mov ecx, 0o1102     ; O_CREAT | O_WRONLY | O_TRUNC, mode octal
    mov edx, 0o777      ; Droits d'accès (lecture/écriture pour tout le monde)
    int 0x80

    cmp eax, 0xFFFFFFFF
    je exit

    ; Stocke le descripteur de fichier dans la variable fd
    mov [fd], eax

capture_key:
    mov eax, 3         ; sys_read call
    mov ebx, 0         ; STDIN
    mov ecx, buffer
    mov edx, 1         ; Taille du buffer
    int 0x80

    mov eax, 4         ; sys_write call
    mov ebx, [fd]      ; Descripteur de fichier de log.txt
    mov ecx, buffer
    mov edx, 1         ; Taille du buffer
    int 0x80

    jmp capture_key

exit:
    mov eax, 1         ; sys_exit call
    xor ebx, ebx       ; Code de sortie 0
    int 0x80

section .bss
    buffer resb 1
