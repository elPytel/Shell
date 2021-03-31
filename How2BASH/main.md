# How2Bash
## Proč to píšu?
Rozhodl jsem se že napíši stručný úvod do skriptovacího jazyka Bash. Plánuji z něj hlavně čerpat já, neboť mě značně bzrdí při práci neustále skákat mezi prohlížečem, kde pořád do kola googlím ty stejné příkazy a Vimem.

## Forma
Většina internetových zdrojů co se týče jazyka podání je výhradně anglicky, je to asi lepší než aby to bylo čínsky, ale já jsem se rozhodl ty to poznámky psát výhradně česky.

## Proměnné
Bash si na typy proměných moc nepotrpí. Představte si že ke všemu vnitřně přistupuje jako kdyby to byl string, tedy řetězec (pole) znaků a je mu jedno, zda jste zrovna měli na mysli číslo (int, nedej bože double), pole, nebo textový soubor.
#TODO
```
Kód.
```

## Podmínky
Podmíněné příkazy jsou základním nástrojem pro větvení běhu programu. Pokud že *exit code* výrazu v podmínce nabývá hodnoty 0 (tedy `true`), tak se pokračuje k vykonání `then` části kódu. Jestliže však výraz nabývá 1 a jiné hotnoty (`false`), tak považován za nepravdivý a pokračuje se dál bez vykonání podmíněné části programu.
```Bash
if <podmínky>; then
	<příkazy pro splněný if>
elif <jiná podmínka>; then
	<příkazy pro splněný elif>
else
	<příkaz který se vykoná vždy když není splněna žádná z předchozích podmínek>
fi
```
Části elif a else a jejich větvě nejsou nutné, zbylá klíčová slova však v kódu být musí. Blok tedy musí být uzavřen slovem fi (if po zpátku)!

#TODO
Někdy se může stát že nám nebude stačit pouze podmínění jedním příkazem.

Může se stát 
```Bash
case $proměná in
	"text")	<příkazy k vykonání> ;;
	"první" | "druhá")
		# umožnuje vybíraz z více várazů spojených pomocí nebo *or, |*
		<dlouhý blok kódu přes více řádků>
	;;
	*)
		# defoultní případ
	;;
esac
```


## Cikly
```
for <promená> in <výčet>
do
	<příkazy>
done
```

## Formátový výstup
printf "%.25s...\n" "dataURI: DFASDFKAJELKJDFSADFMLAKFJLSKDJFAJSDFL"
echo "${yourvar:0:25}..."
