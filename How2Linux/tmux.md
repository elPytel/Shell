
# tmux

Tmux je terminálový multiplexer. Umožnuje vytvoření množství terminálů v jednom okně. Od tmuxu je možné se odpojit a připojit se pozdějí.

## Základní tmux příkazy:

tmux (zapne aplikaci tmux)

tmux new -s session-name (vytvoří nové sezení a pojmenuje jej)

tmux a (znovu otevře poslední sezení)

tmux attach -t session-name (znovu otevře specifické sezení)


- ctrl+b c (vytvoří nové okno)
- ctrl+b d (odpojí se od sezení)
- ctrl+b % (rozdělení terminálu vertikálně)
- ctrl+b " (rozdělení terminálu horizontálně)
- ctrl+b mezerník (auto přerovnání oken)
- ctrl+b n (následující tmux okno)
- ctrl+b šipka (dokud držíte ctrl, tak můžete šipkami měnit velikost sub okna)
- ctrl+b z (otevře dané sub okno na celou obrazovku/zmenší zpět)
- ctrl+b , (přejmenuje okno)

