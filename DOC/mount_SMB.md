# mount_SMB.sh
Script pro automatické mountování síťových disků podle konfiguračního scriptu.

Help pro tento script `./mount_NAS.sh`.
```
USE:
  mount_NAS.sh COMMAND [none=all | conf_name]

COMMANDS:
  -m --mount  		 to mount selected network drive
  -u --unmount		 to unmount selected network drive
  -l --list   		 list of mounted drves
  -c --connections	 print all configurated connections
```

## Template pro konfikurační soubor 
Pojmenujte jej `.mount.conf` a umístěte do stejného adresáře jako hlavní script (ideálně: */home/user/Shell/*).
```BASH
drives=<vycet hlavicek odeleny mezerami>
# <hlavicka zaznamu> 
name=<nazev>
service=smb-share
server=<nazev serveru>
share=<cesta ke sdilenemu adresari>

# <hlavicka zaznamu>
name=<nazev>
service=google-drive
host=gmail.com
user=<uzivatelske jmeno>

# END
```
- `<nazev>` specifikuje symbolicky link, který se vytvoří do: */media/user/*

Pokud odkaz na tento script přidáte mezi **Aplikace spuštěné po přihlášení** (*/home/user/Shell/mount_NAS.sh -m*), tak se vám vždy po spuštění počítače automaticky připoji všechny dostupné disky ze záznamu.
