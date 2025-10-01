README - Script d’inventaire et de chiffrement PowerShell
=========================================================

Nom du script :
VOLET E – PRISE D’INVENTAIRE ET CONSERVATION DANS UN CSV AMELIORER.ps1

Description :
--------------
Ce script permet de collecter les informations matérielles d’un ordinateur
(ordinateur, CPU, RAM, disque C:, administrateurs locaux), et d’ajouter
une ligne d’inventaire dans un fichier CSV. Il propose également des
fonctions avancées pour supprimer l’historique, comparer les relevés,
et chiffrer/déchiffrer les données pour sécuriser les informations.

Fichiers générés :
------------------
- inventaire.csv           : CSV classique contenant les relevés.
- inventaire.enc           : fichier chiffré binaire illisible dans Excel.
- inventaire_dechiffre.csv : CSV temporaire généré lors du déchiffrement.

Paramètres disponibles :
------------------------
-CsvFile <chemin>       : Permet de choisir le nom et l’emplacement du fichier CSV. 
                          Par défaut : 'inventaire.csv' dans le dossier du script.

-ClearHistory           : Supprime le fichier CSV ou .enc existant avant d’ajouter la
                          nouvelle ligne. Utile pour repartir à zéro.

-Encrypt                : Active le chiffrement AES du fichier. Le CSV sera
                          transformé en fichier binaire illisible (.enc).

-Decrypt                : Déchiffre un fichier chiffré .enc et le sauvegarde
                          sous le nom '_dechiffre.csv'. Nécessite la clé de chiffrement.

-Compare                : Compare le dernier relevé avec l’historique existant
                          et affiche le résultat dans Out-GridView.

Fonctionnement :
----------------
1. Collecte des informations matérielles et des administrateurs locaux.
2. Si -ClearHistory est activé, suppression de l’ancien fichier.
3. Ajout d’une nouvelle ligne d’inventaire dans le CSV.
4. Si -Compare est activé, affiche la différence avec le dernier relevé.
5. Si -Encrypt est activé, chiffrement AES en binaire et suppression du CSV original.
6. Si -Decrypt est activé, déchiffre le fichier .enc et génère un CSV lisible.

Exemples de commandes :
------------------------
# 1. Collecte simple et ajout au CSV
.\VOLET E ... AMELIORER.ps1

# 2. Collecte et chiffrement en un seul passage
.\VOLET E ... AMELIORER.ps1 -Encrypt

# 3. Supprimer l’historique et créer un fichier chiffré
.\VOLET E ... AMELIORER.ps1 -ClearHistory -Encrypt

# 4. Déchiffrement d’un fichier chiffré
.\VOLET E ... AMELIORER.ps1 -Decrypt

# 5. Comparer le dernier relevé avec le fichier existant
.\VOLET E ... AMELIORER.ps1 -Compare

# 6. Utilisation d’un fichier CSV personnalisé
.\VOLET E ... AMELIORER.ps1 -CsvFile "C:\Chemin\inventaire_perso.csv"

Notes importantes :
------------------
- Pour le chiffrement/déchiffrement, il faut toujours utiliser la même clé AES.
- Le fichier chiffré est illisible dans Excel et Bloc-notes.
- La comparaison avec -Compare permet de visualiser les modifications rapidement.
- Le script fonctionne avec PowerShell 5.1 et plus.

Recommandations :
-----------------
- Stocker la clé AES de manière sécurisée.
- Ne jamais ouvrir le fichier .enc directement dans Excel, sinon il sera illisible.
- Tester le script dans un environnement contrôlé avant déploiement.

Auteur :
--------
Florian Clolus

Version :
---------
1.0 – Script complet avec chiffrement/déchiffrement, comparaison et suppression d’historique.

