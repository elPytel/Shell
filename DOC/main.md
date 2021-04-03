
# Dokumentace
Pro veští scripty/aplikace:
* # [backup](backup.md) 
* # [mount_SMB](mount_SMB.md)


## Instalačky

### install_all.sh
Script pro aktualizaci a nainstalování všech dalších zmíněných aplikací.

### bat.sh

Nainstaluje batcat, rozšířenou verzi aplikace cat. Poté nastaví alias bat -> batcat.

### clock.sh

Nainstaluje tty-clock, digitální hodiny v terminálu. Nastaví alias clock -> tty-clock -tbc (t - 12 hodinový formát, b - bold - tučné písmo, c - vycentruje hodiny).

### fonts.sh

Stáhne UbuntuMono Nerd Font z www.nerdfonts.com a rozbalí do adresáře: `/usr/share/fonts` a poté nechá aktualizovat font-cache.

### git.sh

Naistaluje git a nastaví aliasay:
```BASH
# some git aliases:
alias gt='git status'
alias gd='git add . '
alias gp='git push'
alias gc='git commit -a'
```
Poté uživatele vyzve, aby nakonfiguroval své git jméno a email a nastaví autentifikaci tokenem, aby nikdy nevypršela.

### htop.sh
Nainstaluje htop a nastaví jeho výchozí konfiguraci.

### lsd.sh
Nainstaluje **LSD - LSDelux**, rozšířenou verzi příkazu ls s podporou ikon, pro správnou funkci je neprve potřeba nainstalovat správný font pomocí: *fonts.sh*. Alias nastaví tak, aby se nejdříve vepisovali adresáře a až potom soubory.

### python.sh
Nainstaluje Python3, popřípadě provede jeho aktualizaci.

### ranger.sh
Nainstaluje aplikaci Ranger, pokročilý prohlížeč souborů v terminálu.

#### ranger_devicons.sh
Nainstaluje plugin do Rangeru, který podporuje vykreslování ikon. Pro správnou funkci je nezbytný Nerf font (pro jeho instalaci použijte: fonts.sh).

#### ueberzug.sh
Nainstaluje plugin do Rangeru, který umožnuje zobrazovat previue pro obrázky (více méně, alespoň občas).

### trash.sh
Nainstaluje trash-cli, terminálový interface pro "koš". Nastaví alias rm -> trash, aby se místo odstranění soubory přesouvali pouze do koše.

### wordgrinder.sh
Nainstaluje aplikaci Wordgrinder, pokročilý textový editor pro práci v terminálu. Nastaví alias word -> wordgrinder.

## Tools

### colors.sh

Konfigurační script pro importování barev do terminálu. 

### get_curent_user.sh

Slouží pro nalezení akturální neootovského uživatele, který spustil instalční script.
