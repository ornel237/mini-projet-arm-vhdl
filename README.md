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
