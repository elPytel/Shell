
# Dokumentace
Pro věští scripty/aplikace:
* ## [backup](backup.md) 
* ## [mount_SMB](mount_SMB.md)

## Scripty
Já jsem si přidal *~/Shell* do `PATH`, takže všechny tyto scripty mohu spouštět bez cesty.

### connect_to_mobile.sh
Spustí aplikaci **scrcpy**, která umožnuje zobrazení displeje, telefonu, který je připojený přes USB, a má povolené vývojářké možnosti.

### defoult_terminal.sh
Vyvolá výběrové okno pro volkbu výchozího emulátoru terminálu.

### git_init.sh
Umožnuje inizializovat **GitHub** repozitář ve zvoleném adresáři.

### lights0ff.sh
Po spuštění zhasne displej notebooku.

### updater.sh
Vyžádá rootovská oprávnění a poté provede aktualizaci.

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

### sec2time.sh
Převede $1 (počet sekund) na standardní formát času a vypíše ho do stdout.

### get_curent_user.sh

Slouží pro nalezení akturální neootovského uživatele, který spustil instailční script.

### yes_no

Rozpozná $1 ano/ne a vrátí 0/1 jako exit value.
```
0	Y,y,Yes,yes
1	N,n,No,no
2	*
```
