section .data
    output_file db 'output.txt', 0
    message db 'toto', 0

section .text
    global _start

_start:
    ; Ouvre le fichier output.txt
    mov eax, 5         ; sys_open call
    mov ebx, output_file  ; Pointeur vers le nom du fichier
    mov ecx, 0o1101     ; O_CREAT | O_WRONLY | O_TRUNC, mode octal
    mov edx, 0o777      ; Droits d'accès (lecture/écriture pour tout le monde)
    int 0x80

    cmp eax, 0xFFFFFFFF
    je exit

    ; Écrit "toto" dans le fichier output.txt
    mov edx, 4         ; Longueur du message
    mov ecx, message   ; Pointeur vers le message
    mov ebx, eax       ; Descripteur de fichier
    mov eax, 4         ; sys_write call
    int 0x80

exit:
    ; Termine le programme
    mov eax, 1         ; sys_exit call
    xor ebx, ebx       ; Exit code 0
    int 0x80
