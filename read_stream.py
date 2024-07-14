import datetime
import warnings
warnings.filterwarnings("ignore")

# Non du fichier du flux binaire
file = "stream"

# Association des octets à une touche
# Cette association peut varier d'un driver à l'autre et donc d'une version à l'autre du kernel
keycodes = {b'\x39': ' ', b'\x10': 'a', b'\x30': 'b', b'\x2e': 'c', b'\x20': 'd', b'\x12': 'e', b'\x21': 'f', b'\x22': 'g', b'\x23': 'h', b'\x17': 'i', b'\x24': 'j', b'\x25': 'k', b'\x26': 'l', b'\x27': 'm', b'\x31': 'n', b'\x18': 'o', b'\x19': 'p', b'\x1e': 'q', b'\x13': 'r', b'\x1f': 's', b'\x14': 't', b'\x16': 'u', b'\x2f': 'v', b'\x2c': 'w', b'\x2d': 'x', b'\x15': 'y', b'\x11': 'z'}

# fonction pour séparer les bytes dans un tableau
def even_splits(string,size):
    res = [string[i:i+size] for i in range(0, len(string), size)]
    return res

# Ouvrir le fichier de flux
with open(file, 'rb') as file:
    contenu_binaire = file.read()

# Regrouper sous forme d'éléments d'un tableau le flux en faisant des groupes de 32 bytes
taille_decoupage = 32
tab = even_splits(contenu_binaire,taille_decoupage)

full_sentence = ''

# Parcourir les groupes et extraire la touche pressée et son timestamp
for elem in tab:
    # si le pattern de pression de touche est présent, alors on prend le groupe en considération
    if(b'\x00\x04\x00\x04\x00' in elem):
        # On calcule la date de la pression
        timestamp = int.from_bytes(elem[:4], byteorder='little')
        pretty_date = datetime.datetime.utcfromtimestamp(timestamp)
        # On détermine la lettre de la touche à l'aide du tableau d'association
        try:
            key = keycodes[elem[12:13]]
            full_sentence += key
            print(f"{pretty_date} : {key}")
        except Exception:
            pass
print(full_sentence)
