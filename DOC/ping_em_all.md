# ping_em_all.sh

Script, který prohledá siť v zadaném rozsahu a zazanamená všechny nalezené IP adresy náležící připojeným počítačům.

```
COMMANDS:
  -h --help 	 print this text
  -d --debug	 enable debug output
  -n --network	 setup network, expect: xxx.xxx.xxx.xxx
  -m --mask		 setup mask, expect: xxx.xxx.xxx.xxx
  -c --cycle	 setup number of ping cycles.
  -s --sleep	 setup sleep time in sec, expect: x.x
  -T --time		 setup thread gap time.
  -f --file		 setup output file name.
  -F --toFile	 send output to file.
```

* Umožnuje výsput do souboru/terminálu. 
* Zadání IP adresy sítě a rozsahu zvoleného maskou.
* Časových rozestupů mezi vlákny a opakování pingů.
* Počet zaslaných pingů.
