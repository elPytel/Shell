# Shell
Všechny moje bashové skripty.

Předpokládaná cesta k tomuto repozitáři je v home, tedy: */home/user/Shell/...*

## Úvod v BASHi
* [tady](/How2BASH/main.md)


## Dokumetace
* [tady](/DOC/main.md)


## installers

Složka installers obsahuje skripty s automatickou instalací aplikací a jejich následnou konfigurací.

### Instalce Bash scriptů
Pro úspěšné nainstolování scriptů v tomto repozitáři je potřeba spustit:

> [!warning]
> Script `install_my_shell_scripts.sh` očekává že složka `Shell` je v home adresáři aktuálního uživatele.

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

#### Nastavení podpory `.shlib` souborů ve VS Code
Zmáčkněte `Ctrl+Shift+P` a vyberte `Change Language Mode` a `Configure File Association for '.shlib'` a
vyberte `Shell Script`.

### TODO

- [ ] předělat debug na `DEBUG=$true`
- [ ] Aktulizovat všechny programy, aby tahali knihovny z `/usr/local/bin`
