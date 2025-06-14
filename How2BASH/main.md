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


## Cykly

### For & posloupnosti

Vygenerovaná poslouponosti pomocí: {} - "brace expansion"

`{<start>..<stop>}` nebo `{<start>..<stop>..<krok>}` 

Použití:

`{1..10}`

`{0..2..20}`

Využitím příkazu `seq`.

`seq <start> <stop>`

`seq <start> <inkrement> <stop>`

Seq je pokročilejší.

Použití cyklu for each:
```
for <promená> in <výčet>
do
	<příkazy>
done
```
Cyklus "C-style for":
```
for (( initializer; condition; step )); do
  shell_COMMANDS
done
```

## Porovnávání
### String
- =, ==	vraci true, pokud se stringy schodují.
	- =	používejte s [
	- ==	používejte s [[
- ">", < porovnání dle abecedního pořadí.
- -z string	True, pokud je délka stringu nulová.
- -n string	True, pokud je délka stringu nenulová.

Příklad použití:

`[[ "string1" == "string2" ]] && echo "Equal" || echo "Not equal"`

### Čísla

* -eq	Equal
* -ne	Not equal
* -lt	Less than
* -le	Less than or equal
* -gt	Greater than
* -ge	Greater than or equal

### Ternární opreátor

`echo $(( a < b ? a : b ))`

^^ vytiskne vetsi z a/b.

## Výstup
`echo "<string>"`
Za zmínku stojí přepínače: 
 - `-n`, nevloží na konec řádku zalomení
 - `-e`, povolí interpretaci escape sekvencí (\n, \t, barev...)

### Formátovaný výstup
Formatovaný výstup pomocí příkazu printf umožnujě tisknout na výstup se standardním formátováním.
* `%s` - tisk stringů
	* `%<minlen>.<maxlen>s`
* `%d` - tisk celých čísel

Použití:
```BASH
printf "%.25s...\n" "dataURI: DFASDFKAJELKJDFSADFMLAKFJLSKDJFAJSDFL"
echo "${yourvar:0:25}..."
```

## Časování

Uspání procesu na určitý čas umožnuje příkaz `sleep <sec>`, očekává argument počet vteřin, na jak dlouho se má uspat. Zvládne vyhodnotit i desetiny sekund `sleep 0.1` nebo `sleep 1.0e-1`.

Pro mnohem menší časové intervaly lze použít příkaz `usleep <us>`, který uspí proces na požadovaný počet microsekund.

Použití:

`usleep 1000` uspí proces na 1ms.

## Výchozí textový editor
Umožnuje vybrat defaultní textový editor v systému (Vi, Vim, Nano,...), spouští příkaz: `$ select-editor`.

## Cron
Cron je terminálová aplikace umožnující časování jednotlivých scriptů, co kdy a jak se má provést. Umožnuje výběr přesné minuty, hodiny, dny v měsíci, měsíce v roce, případně i dne v týdnu a příkazuči sekvence příkazů, které se v ten okamžik mají provést.
Intuitivná záhlaví pro Cron [zde](https://gist.github.com/elPytel/6211e39e9e54a8acdc71f8bf2eda8f89#file-crontab-e-header).

Rootův cron má tu výhodu, že se implicitně spuští s rootovským oprávněním:

`$ sudo crontab -e`

Uživatelův cron:

`$ crontab -e`

Přepínače:
* `-e`	edit
* `-l`	lis

Spuštění příkazu ihned po spuštění systému:
```BASH
# run script after reboot
`@reboot yourScriptPath`
```

Další specifické časy:

`@reboot, @yearly or @annually, @monthly, @weekly, @daily, @hourly, @midnight`
