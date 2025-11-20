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

---

### 6.1 Stratégies possibles de publication du code

Il existe plusieurs façons d’organiser un dépôt GitHub :

- **Une seule branche principale publique**  
  Toute modification est poussée directement dans la branche principale.  
  C’est simple, mais cela rend l’historique plus difficile à analyser et manque d’isolation pour les tests.

- **Branches de développement + versions stables (releases)**  
  Les nouvelles fonctionnalités et modifications sont d’abord développées dans des branches dédiées, puis fusionnées quand elles sont stables.  
  Des versions taguées (*releases*), telles que `v1.0`, peuvent ensuite être créées pour partager une version précise du projet.

Dans ce projet, nous avons choisi une approche simple avec deux branches :
- **`src`** : regroupe les fichiers VHDL synthétisables (design du processeur).  
- **`sim`** : regroupe les bancs de test et les fichiers associés aux simulations.

Cette séparation permet de clarifier ce qui fait partie du processeur et ce qui sert uniquement aux tests dans Vivado.

---

### 6.2 Responsabilités liées à la publication du code sur GitHub

La publication du projet impose plusieurs responsabilités importantes :

- Indiquer clairement qu’il s’agit d’un **projet académique**, non destiné à un usage industriel.
- Fournir le code **“tel quel” (as is)**, c’est-à-dire sans garantie d’exactitude, de performance ou de sécurité.
- Documenter les **fonctionnalités réellement implémentées et testées**, par exemple :
  - instructions supportées,
  - bancs de test disponibles : `tb_cmp_check`, `tb_shifted_check`, `tb_top`.
- Être honnête concernant les **limites**, les **comportements non implémentés**, ou les **modules non testés**.
- Respecter la licence MIT et les licences externes lors de réutilisation de code.

Ces responsabilités garantissent la transparence et aident les utilisateurs à comprendre la portée réelle du projet.

---

### 6.3 Gestion des bugs et dysfonctionnements (workflow de correction)

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




