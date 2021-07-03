SECTION "Players", WRAM0
INCLUDE "struct.inc"

  struct Player
  words 1, Health
  bytes 1, HealthDecimal1s
  bytes 1, HealthDecimal10s
  bytes 1, HealthDecimal100s

  words 1, MaxHealth
  bytes 1, MaxHealthDecimal1s
  bytes 1, MaxHealthDecimal10s
  bytes 1, MaxHealthDecimal100s

  bytes 1, Magic
  bytes 1, MagicDecimal1s
  bytes 1, MagicDecimal10s

  bytes 1, MaxMagic
  bytes 1, MaxMagicDecimal1s
  bytes 1, MaxMagicDecimal10s
  end_struct

wPlayers:
  dstructs Player, 4, wPlayer
;wPlayer0_Health





SECTION "Enemies",WRAM0

struct Enemy
  words 1, Health
  bytes 1, Magic

  end_struct

wEnemies:
  dstructs Enemy, 4, wEnemy

SECTION "General Varaibles", WRAM0
;General Variables

wController: db ;this is the controller input
wControllerXor: db
wTimer:db
wPointer:db
wMode:db
wTurn:db; 0=selecting charecter,1=overmenu/(attack magic item run)