# backup.sh
Soubory:
* backup.sh
* .backup.conf
Závislosti:
* colors.sh

Skript slouží pro zálohování, respektive synchronizaci souborů mezi disky.
```BASH
backups=<vycet odeleny mezrerami>
# <prarametr>=<volba>   <je v mountu?>
# <hlavicka zaznamu>
options=<parametry pro rsync>
source=<absolutni cesta>        false
destination=<releativni cesta z /media/user/>   true
#END
```
Skript podporuje zálohování více záznamů. Stačí ve stejném formátu přidal další blok. První řádek souboru obsahuje za `backups=` výčet NÁZVŮ oddělený mezerami všech bloků konfigurace. každý blok začíná `# <NAZEV>` a končí `#`.

Nekteré možné parametry pro rsync:
* -a                    archyvuj (vse kopiruje identicky, -rlptgoD)
* -r                    rekurzivně (pro složky)
* -h                    lidsky čitelné
* -u, --update          přesune jen soubory s novějším datem
* -n, --dry-run         běh na zkoušku (testování)
* -v                            verbose - vykecává se
* -z, --compress        komprimace pro komunikaci po siti
* -p, --perms           zachovej opravnění
* -P, --progress        vypíše postup
* --delete              smaže "odstraněné" soubory i z cílového adresáře

