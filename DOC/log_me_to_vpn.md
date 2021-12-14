# log_me_to_vpn.sh

Sript pro automatické přihlašování do vpn přes cisco connect clienta.

## Template pro konfigurační soubor

Pojmenujte jej `.vpn.conf` a umístěte do stejného adresáře jako hlavní script (ideálně: */home/user/Shell/*).

```BASH
vpns=<vycet hlavicek odeleny mezerami> 
# <hlavicka zaznamu>
host=<server>
user=<uzivatelske.jmeno>
passwd=<heslo/nic>

#END
```
