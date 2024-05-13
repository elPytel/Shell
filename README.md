# Shell
Všechny moje bashové skripty.

Předpokládaná cesta k tomuto repozitáři je v home, tedy: */home/user/Shell/...*

## Úvod v BASHi
* [tady](/How2BASH/main.md)


## Dokumetace
* [tady](/DOC/main.md)


## instalers

Složka installers obsahuje skripty s automatickou instalací aplikací a jejich následnou konfigurací.

### Instalce Bash scriptů
Pro úspěšné nainstolování scriptů v tomto repozitáři je potřeba spustit:

```BASH
./Shell/installers/install_my_shell_scripts.sh
```
- Tento skript vytvoří symbolický link do `/usr/local/bin/`.
- Vznikne tak statická cesta pro načítání knihoven `.shlib`.

```BASH
./Shell/installers/bashrc_updater.sh
```
- Vytvoření souboru `.bash_environment`, který po spuštění počítače přidá do proměnné PATH cestu k tomuto repozitáři.
- Umožnuje uživateli spouštět skripty z v kořenovém adresáři tohoto repozitáře odkudkoliv.

### TODO

 - [ ] předělat debug na DEBUG=$true
