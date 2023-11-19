# ft_turing
recreating a turing machine in ocaml in the realm of 42 Paris corriculum

Pour la machine lievre,

'|' separe les instructions de l'input

la lecture des instructions se fait de droite a gauche
'$' debute une instruction 
suivis par une lettre (ici: A B ou C) etant le nom d'etat de l'instruction
suivis par un caractere lu dans l'input "1", ".", "+", "=" 
chacune des lettre va enclancher une instruction

qui finira par un caractere a ecrire, une direction pour le curseur
et le prochain nom d'etat d'instruction a activer

exemple:
A>11A$ cette instruction sera lu si nous sommes dans l'etat A et que notre curseur a rencontrer un '1' dans l'input
elle declanchera une ecriture de 1 a cette endroit suivis d'un deplacement a droite et restera dans l'etat A

--------------------------------------------------

il faudra peut etre echaper les $ avec un backslash
les instructions possibles a ecrire dans l'autre sens:
$A11>A => "A>11A\$"
$A+1>B => "B>1+A\$"
$B11>B => "B>11B\$"
$B=.<C => "C<.=B\$"
$C1.<H => "H<.1C\$"
