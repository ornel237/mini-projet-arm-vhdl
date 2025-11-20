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


### 6.2 Responsabilités concernant la publication du code source**

La publication de ce projet sur GitHub implique plusieurs responsabilités importantes afin d’assurer la qualité, la transparence et la sécurité du code diffusé. En tant que créateurs et mainteneurs du projet, nous devons :

* **Garantir la clarté du statut du projet**
  Préciser qu’il s’agit d’un projet académique réalisé dans le cadre d’un cours, et non d’un processeur destiné à un usage industriel.
  Le code est fourni *« tel quel »* (**as is**), sans garantie de performance, de sécurité ou de compatibilité.

* **Assurer une documentation suffisante**
  Le dépôt doit inclure un README clair, une organisation compréhensible (branches `src` et `sim`), et des explications sur les éléments testés par les bancs de test (`tb_cmp_check`, `tb_shifted_check`, etc.).

* **Maintenir la qualité du code publié**
  Les fichiers déposés doivent être lisibles, correctement organisés et ne pas contenir d’informations sensibles ou privées.

* **Assurer une gestion responsable des bugs**
  En cas de problème, un système d’issues doit être utilisé pour :

  * signaler les dysfonctionnements,
  * décrire les étapes de reproduction,
  * suivre les correctifs et les évolutions.

  Les correctifs doivent idéalement être développés dans des branches dédiées (`bugfix/*`) puis fusionnés après validation.

* **Respecter la licence et les droits d’auteurs**
  Toute réutilisation de code externe doit être compatible avec la licence du projet, et les sources doivent être citées correctement.

En résumé, publier du code sur GitHub ne consiste pas seulement à déposer des fichiers : cela implique une responsabilité envers les utilisateurs, la transparence des limites du projet et une gestion minimale de la maintenance.

---

### 6.3 Justification du choix d’une licence open source**

Le projet est distribué sous la licence **MIT**, une licence open source permissive très utilisée dans les projets éducatifs et de recherche. Ce choix est justifié par plusieurs raisons :

* **Grande liberté d’utilisation**
  La licence MIT autorise tout utilisateur à copier, modifier, redistribuer ou intégrer le code dans d’autres projets, y compris commerciaux. Cette liberté facilite la réutilisation du travail dans un contexte pédagogique ou pour d’autres projets d’étudiants.

* **Simplicité et lisibilité**
  Contrairement à des licences plus complexes (comme GPL ou Apache), la MIT est courte, facile à comprendre et ne impose pas de contraintes lourdes aux utilisateurs.

* **Protection juridique des auteurs**
  La licence précise clairement que le code est fourni sans garantie (« as is »).
  Cela protège les auteurs contre toute responsabilité liée à des erreurs, mauvaises utilisations ou incompatibilités du code.

* **Encouragement à la collaboration**
  Grâce à son caractère permissif, la licence MIT permet à d’autres développeurs ou étudiants d’améliorer librement le code et de contribuer sans contrainte.



     




