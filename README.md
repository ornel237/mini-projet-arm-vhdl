# Mini-projet VHDL – Processeur ARM Single-Cycle

Ce dépôt contient le mini-projet réalisé dans le cadre du cours de microarchitecture à l’UQTR.  
Le projet implémente un processeur ARM simplifié, single-cycle, avec gestion des flags, l’instruction CMP et les opérations à registre décalé (shifted register).

---

## 🌿 Organisation du dépôt (avec branches)

Le dépôt est réparti en deux branches :

### Branche `src` (principale)
Contient tous les fichiers VHDL synthétisables :
- top_simple.vhd
- datapath.vhd
- controller.vhd
- fetch_unit.vhd
- regfile.vhd
- shifter.vhd
- extend.vhd
- ALU.vhd
- adderN.vhd
- mux4.vhd
- instr_mem.vhd
- data_mem.vhd
- flag_regs.vhd
- condcheck.vhd

Cette branche représente le design final du processeur.

---

### Branche `sim`
Contient tous les fichiers de simulation :
- tb_shifted_check.vhd  
- tb_cmp_check.vhd  
- tb_top.vhd  
- Instructions.txt  
- Instructions_SHIFTED.txt  
- Instructions_cmp.txt  
- ExpectedData.txt  
- ExpectedData_SHIFTED.txt  
- ExpectedData_CMP.txt  

Cette branche contient uniquement les éléments nécessaires aux tests comportementaux dans Vivado.

---

## 🔧 Simulation dans Vivado

1. Cloner la branche `src` pour obtenir le processeur.  
2. Cloner la branche `sim` pour obtenir les testbenchs et fichiers texte.  
3. Ajouter les fichiers dans Vivado en respectant leur catégorie :
   - Design Sources → fichiers `src`
   - Simulation Sources → fichiers `sim`
4. Lancer la simulation avec le banc de test souhaité.

---

## ⚠ Statut du projet

Ce projet est un **projet académique**.  
Le code est fourni **"as is"**, sans garantie de performance ni de sécurité.

---

## 📄 Licence

Ce projet est distribué sous la licence **MIT**.  
Voir le fichier `LICENSE` pour plus d'informations.

## 6. Pratiques de publication du code et gestion des correctifs sur GitHub

La publication de ce mini-projet sur GitHub permet non seulement de partager le code, mais aussi d’appliquer des pratiques professionnelles liées aux dépôts publics.  
Cette section présente différentes stratégies de publication, les responsabilités associées et la manière dont il faut réagir en cas de dysfonctionnement du code.


### 6.1 Gestion des bugs et dysfonctionnements (workflow de correction)

Lorsqu’un bug est découvert, il existe une procédure standard professionnelle à suivre :

1. **Créer une issue GitHub**  
   - expliquer le problème,  
   - préciser quel testbench a été utilisé,  
   - indiquer le comportement observé vs attendu,  
   - ajouter éventuellement des captures d’écran ou extraits de waveform.

2. **Reproduire et isoler le bug**  
   - relancer la simulation,  
   - identifier le module fautif (ex. `ALU.vhd`, `shifter.vhd`, `controller.vhd`).

3. **Corriger dans une branche dédiée**  
   - créer une branche nommée par exemple `bugfix/shifter-lsl` ou `bugfix/flags-overflow`,  
   - appliquer la correction,  
   - valider le correctif avec les bancs de test existants,  
   - ajouter un nouveau test si nécessaire.

4. **Fusionner le correctif**  
   - fusionner la branche de correction dans la branche source (`src`),  
   - fermer l’issue GitHub liée,  
   - documenter le correctif dans le message de commit ou dans un changelog léger.


### 6.2 Justification du choix d’une licence open source**

Le projet est distribué sous la licence **MIT**, pour plusieurs raisons :

* **Grande liberté d’utilisation**
  La licence MIT autorise tout utilisateur à copier, modifier, redistribuer ou intégrer le code dans d’autres projets, y compris commerciaux.

* **Simplicité et lisibilité**
   facile à comprendre et ne impose pas de contraintes lourdes aux utilisateurs.

* **Protection juridique des auteurs**
  Cela protège les auteurs contre toute responsabilité liée à des erreurs, mauvaises utilisations ou incompatibilités du code.

* **Encouragement à la collaboration**
 la licence MIT permet à d’autres développeurs ou étudiants d’améliorer librement le code et de contribuer sans contrainte.



     




