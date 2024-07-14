#!/bin/bash

# Vérifier si le nombre d'arguments est correct
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <fichier.asm>"
    exit 1
fi

# Assigner le nom du fichier asm en argument à une variable
asm_file=$1

# Compiler le fichier asm en un fichier objet
nasm -f elf32 -o "${asm_file%.*}.o" "$asm_file"

# Lié le fichier objet pour créer un exécutable
ld -m elf_i386 -o "${asm_file%.*}" "${asm_file%.*}.o"

# Supprimer le fichier objet
rm "${asm_file%.*}.o"
