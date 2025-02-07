# LightTool

Tool to split forest for foreground/background pourpose


1 - Artist : Will manually create a place a closer(Mendatory) spline, called 'little circle'
2 - Script : Duplicate 'little circle' , it will be used for outside part of forest , BG 

3 - Script : Create a big spline (Size of the bounding box of the forest selection), called 'big circle', take 20% of the margin to be sure

3 - Créer une grande spline sous forme de cercle qui fera la taille de la bounding box de la sélection du forest(Pour englober tout le forest), appelons la 'grand cercle' -> Je pense qu'on peut prendre de la marge a cause de l'etape 9.
4 - Merge un des petits cercles au grand cercle grâce au modifier Edit Spline -> Attach
Nous avons maintenant un petit cercle , et un grand cercle avec un trou dans la forme du petit cercle.
5 - Sélectionner et dupliquer les forest qui seront impactés par le split, puis les renommer.
6 - Utiliser des layers pour les ranger.
7 - Sélectionner les éléments forest d'origine , et puis un par un , créer un layer , assigner 'grand cercle' au layer.
8 - Etape 7 mais avec les le forest dupliqué et assigner cette fois a 'petit cercle'
Paramètres des deux nouveaux layers de forest :
Cocher Exclude
Thickness 0
Fallof :
-Density Off
-Scale Off
9 - En terme de linking :
Spline_Small_Ext doit être le parent de Spline_Big_Int