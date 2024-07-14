section .bss
    buffer resb 32
    file_descriptor resd 1

section .text
    global _start

_start:
    ; Ouvre le fichier /dev/input/event3
    mov eax, 5           ; sys_open
    mov ebx, clavier_ev3  ; Nom du fichier /dev/input/event3
    mov ecx, 0           ; O_RDONLY (lecture seule)
    int 80h

    mov dword [file_descriptor], eax  ; Stocke le descripteur de fichier retourné

    ; Lecture et affichage des événements du clavier de manière continue
read_loop:
    mov eax, 3        ; sys_read
    mov ebx, dword [file_descriptor]  ; Utilise le descripteur de fichier stocké
    mov ecx, buffer
    mov edx, 32       ; Taille du buffer
    int 80h

    ; Affiche le contenu lu du fichier /dev/input/event3
    mov eax, 4        ; sys_write
    mov ebx, 1        ; file descriptor 1 (stdout)
    mov ecx, buffer
    int 80h

    ; Retourne à la lecture continue des événements du clavier
    jmp read_loop

section .data
    clavier_ev3 db "/dev/input/event3", 0
