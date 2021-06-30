INCLUDE "hardware.inc"

def pointercharecter equ $7f

def playerhp EQU $c000 ;players hp
def playerhp1 EQU $c001

def p1hp EQU $c000
def p1hp1 EQU $c001

def p2hp EQU $c002
def p2hp1 EQU $c003

def p3hp EQU $c004
def p3hp1 EQU $c005

def p4hp EQU $c006
def p4hp1 EQU $c007

def p1maxhp equ $c008
def p1maxhp1 equ $c009

def p2maxhp equ $c00a
def p2maxhp1 equ $c00b

def p3maxhp EQU $c00c
def p3maxhp1 EQU $c00d

def p4maxhp EQU $c00e
def p4maxhp1 EQU $c00f

def enemyhp EQU $c010 ;enemies hp

def controller EQU $c010
def controllerdif EQU $c011
def hpones EQU $c101
def hptens EQU $c102
def hphundreds EQU $c103
def hpthousands EQU $c104


def hp1s EQU $c101
def hp10s EQU $c102
def hp100s EQU $c103

def p2hp1s EQU $c104
def p2hp10s EQU $c105
def p2hp100s EQU $c106

def p3hp1s EQU $c107
def p3hp10s EQU $c108
def p3hp100s EQU $c109

def p4hp1s EQU $c10a
def p4hp10s EQU $c10b
def p4hp100s EQU $c10c

def pointer equ $c10d;this is how we tell where they are pointing
def mode equ $c020; 0=selecting charecter,1=overmenu/(attack magic item run)
def turn equ $c021


def p1maxhp1s equ $c111
def p1maxhp10s equ $c112
def p1maxhp100s equ $c113

def p2maxhp1s equ $c114
def p2maxhp10s equ $c115
def p2maxhp100s equ $c116

def p3maxhp1s equ $c117
def p3maxhp10s equ $c118
def p3maxhp100s equ $c119

def p4maxhp1s equ $c11a
def p4maxhp10s equ $c11b
def p4maxhp100s equ $c11c


def timer EQU $c100

def startinghp EQU $30
def startinghp1 EQU $00

def maxhp EQU $0f
def maxhp1 EQU $27


def enemymaxhp equ $20

SECTION "vblank vector", ROM0[$40]
  reti
  
SECTION "header", ROM0[$100]

reset:
  di
  jp start

REPT $150-$104
  db 0
endr

SECTION "Main", ROM0

start:
 


.waitvblank 
  ld a,[rLY] ;test if screen is in vblank
  cp 144
  jr c, .waitvblank


  ld b,$ff
  ld c,$1f  ;set us up to clear ram
  ld hl,$c000

  xor a ;set a to 0
  ld [rLCDC],a ;turn off the lcd by writting 0 to this register  
  
.clearram
  ld [hli],a
  dec b
  jp nz, .clearram
  ld b,$ff
  dec c
  jp nz, .clearram



  ld hl,$9000 ;adress we copy to
  ld de, font ;adress we copy from
  ld bc, fontend-font;allows us to know how much to copy

.copyfont

  ld a,[de];grabs first byte of the font
  ld [hli],a; puts that byte into vram
  inc de
  dec bc
  ld a,b
  or c ; since dec bc doesnt affect zero flag, this will let us tell when bc = 0
  jr nz, .copyfont

  ld hl,$9983
  ld de,tk
  call copystring

  ld hl,$9987
  ld de,hr
  call copystring
  
  ld hl,$998b
  ld de,bp
  call copystring

  ld hl,$998f
  ld de,kf
  call copystring

  ld hl,$99a1
  ld de,hpstring

  call copystring

  call copymenu ;this will load the attack item &c. menu up

;load player hps

  ld a,startinghp
  ld [playerhp],a
  ld a,startinghp1
  ld [playerhp1],a

  ld a,startinghp
  ld [p2hp],a
  ld a,startinghp1
  ld [p2hp1],a

  ld a,startinghp
  ld [p3hp],a
  ld a,startinghp1
  ld [p3hp1],a

  ld a,startinghp
  ld [p4hp],a
  ld a,startinghp1
  ld [p4hp1],a




;load player max hp

  ld a,startinghp
  ld [p1maxhp],a
  ld a,startinghp1
  ld [p1maxhp1],a

  ld a,startinghp
  ld [p2maxhp],a
  ld a,startinghp1
  ld [p2maxhp1],a

  ld a,startinghp
  ld [p3maxhp],a
  ld a,startinghp1
  ld [p3maxhp1],a

  ld a,startinghp
  ld [p4maxhp],a
  ld a,startinghp1
  ld [p4maxhp1],a




  ld bc,p1maxhp1s ;this loads the max hp into ram as a decimal value
  call p1hptoram
  ld bc,p2maxhp1s
  call p2hptoram
  ld bc,p3maxhp1s
  call p3hptoram
  ld bc,p4maxhp1s ;this crashes the game for some reason XP
  call p4hptoram

  ld a,4
  ldh [$80],a
  ld b,3
  ld hl,$99e1;give hl the starting adress
  ld de,p1maxhp100s ;give de where were loading from
  ld a,$2f
  ld [hli],a
.hpdisplayloop ;this is used to show max hp
  ld a,[de] ; give highest digit to a
  add $30
  ld [hli],a
  dec de
  dec b
  jr nz, .hpdisplayloop
  ld b,3
  ldh a,[$80]
  sub a,1
  jr z, .done
  inc hl
  ldh [$80],a
  ld a,$2f
  ld [hli],a;puts a slash before the symbol
  ld a,e ;this moves de up 6 so that it goes to nexct charecter and 100s place
  add a,6
  ld e,a
  
  
  jr .hpdisplayloop  

.done

  

  

;this is where our initial hp stuff needs to go, not in main









;init display registers
  ld a,%11100100
  ld [rBGP],a ;sets the pallete

  ld a,%11100100
  ld [rOBP0],a ;sets the pallete 0 for objects

  ld a,%11100100
  ld [rOBP1],a ;sets the pallete 1 for objects


  xor a ;clear a
  ld [rSCY],a
  ld [rSCX],a ;sets the x and y offset to 0
  
  ld [rNR52],a ;turns off sound

  ld a,%10000011
  ld [rLCDC],a;ff40




  ld a,$01
  ld [rIE],a
  ei

  ld bc,hp1s
  call p1hptoram
  ld bc,p2hp1s
  call p2hptoram
  ld bc,p3hp1s
  call p3hptoram
  ld bc,p4hp1s
  call p4hptoram
  jp loop

  

Section "copythestringtoscreen", ROM0
copystring:
  ld a,[de]
  ld [hli],a
  inc de
  and a; check if byte is 0, ie the ending byte
  jr nz, copystring
  ret






SECTION "gameloop",ROM0
main:
  call readcontroller 
  ld a,[mode]
  cp $01
  jp z, .overmenu 


  ld a,[controllerdif];controller dif is a xor between last framses controller input and this frames, thus the difrence ebtween the two
  jp z, .dontdec
  and %00100000 ;this means the controller hbaspressed left ;need to make it so it doesnt go again when let fo
  ld b,a
  ld a,[controller]
  and a,b ;this takes the difrence from last frame and the current fram and ands them, thus if its zero, the button has been released not pressed
  jr z, .notleft

.leftpress  
  ld a,[pointer]
  dec a
  and $03;this will chang eonc ewe add enenimes
  ld [pointer],a
  jp loop


.notleft
  ld a,[controllerdif]
  and %00010000;if right is pressed
  ld b,a
  ld a,[controller]
  and a,b 
  jr z, .nochangeinpointer

.rightpress
  ld a,[pointer]
  inc a
  and $03;this will change once we add enenimes, but for now theres only 3 positions it could be in
  ld [pointer],a
  jp loop

.nochangeinpointer

  ld a,[controllerdif]
  
  and $01;check a button ;when pressed=0

  jp z, .dontdec

  ld b,a
  ld a,[controller]
  and a,b
  jp z, .dontdec

  ld hl, p1hp
  ld a,[pointer]
  add a,a
  add a,l
  ld l,a


  ld a,[hli]
  ld c,a
  ld a,[hl];loads the selected player hp into hl
  ld b,a
  

  ld a,b
  or c
  jr z, .dontdec ;if their hp is zero, it does nothing

;do your changes to hp here
.attack ;we should make this a subroutine and use something to tell who is being attacked and who is attacking 

  dec bc
  

;; we need to test for an underflow here if we increase our damage beyond one
  
  ld a,b
  ld [hld],a
  ld a,c
  ld [hl],a





  ld bc,hp1s ;this loads the max hp into ram as a decimal value
  call p1hptoram
  ld bc,p2hp1s
  call p2hptoram
  ld bc,p3hp1s
  call p3hptoram
  ld bc,p4hp1s ;this crashes the game for some reason XP
  call p4hptoram

  ld a,1
  ld [mode],a ;this moves us to the menu once we have selected the person to attack

  xor a
  ld [pointer],a;intiialize the pointer sicne we will be moving 
.dontdec




  jp loop

.overmenu

;down up l r

  ld a,[controllerdif]
  and %00010000
  ld b,a
  ld a,[controller]
  and a,b 
  jr z, .overmenunoright


.overmenurightpress
  ld a,[pointer]
  inc a
  and $03
  ld [pointer],a
  jp loop



.overmenunoright
  ld a,[controllerdif]
  and %00100000;if right is pressed
  ld b,a
  ld a,[controller]
  and a,b 
  jr z, .overmenunoleft


.overmenuleftpress 
  ld a,[pointer]
  dec a
  and $03
  ld [pointer],a
  jp loop


.overmenunoleft

  ld a,[controllerdif]

  and %10000000 ;down
  ld b,a
  ld a,[controller]
  and a,b 
  jr z, .overmenunotdown
 

.overmenudownpress  
  ld a,[pointer]
  add 2
  and $03
  ld [pointer],a
  jp loop

.overmenunotdown

  ld a,[controllerdif]

  and %01000000 ;down
  ld b,a
  ld a,[controller]
  and a,b 
  jr z, .overmenunotup
 

.overmenuppress  
  ld a,[pointer]
  sub 2
  and $03
  ld [pointer],a
  jp loop


.overmenunotup


.dontdecovermenu
  jp loop










SECTION "vblankloop",ROM0
loop:
  halt
  jp vblank




SECTION "vblank",ROM0



vblank:
  ld a,[timer]
  inc a
  ld [timer],a
  ld a,4
  ldh [$80],a;this keeps track of the number of charecters in our party to fill out

  ld b,3
  ld hl,$99c2;give hl the starting adress
  ld de,hp100s ;give de where were loading from

.hpdisplayloop
  ld a,[de] ; give highest digit to a
  add $30
  ld [hli],a
  dec de
  dec b
  jr nz, .hpdisplayloop
  ld b,3
  inc hl
  ld a,e ;this moves de up 6 so that it goes to nexct charecter and 100s place
  add a,6
  ld e,a
  ldh a,[$80]
  inc hl
  sub a,1
  jr z, .done
  ldh [$80],a

  jr .hpdisplayloop  

.done



;  ld a,[mode]
;  cp $01
;  jp z, .menupointer

  ld a,pointercharecter
  ld [$fe02],a;adress of the sprite in tilemap

  ld a,%10000000;this may need to be edited
  ld [$fe03],a; sprite 0 atributes

  ld a,$2f
  ld [$fe00],a;this. sets the x and y 
  ld [$fe01],a

  jp .donewithpointer




.menupointer
;we could fanangle this to make it work for the 
  
  ld hl,pointermenudata;loads the address of the list of places the pointer symbole could go
  ld a,[pointer]

  add a,a
  ld c,a
  ld b,0
  add hl,bc
  ld a,[hli]
  ld c,a
  ld a,[hl]
  ld b,a
  ld h,b
  ld l,c

  ld a,pointercharecter
  ld [hl],a
  jp .donewithpointer


.donewithpointer
  jp main


;----------------------------------------------------subroutines-------------------------------------------
section "attack pointer subroutine",ROM0
attackpointer:
  ld hl,pointerdata;loads the address of the list of places the pointer symbole could go
  ld a,[pointer]
  add a,a
  ld c,a
  ld b,0
  add hl,bc
  ld a,[hli]
  ld c,a
  ld a,[hl]
  ld b,a
  ld h,b
  ld l,c

  ld a,pointercharecter
  ld [hl],a
  ret

section "copythe main attack etc. menu text data into ram",ROM0
copymenu:
  
;9822.    982a
;94 or 6 22

  ld hl,$9822
  ld de,attackstring
  call copystring

  ld hl, $982a
  ld de, magicstring
  call copystring

  ld hl, $9862
  ld de, itemstring
  call copystring

  ld hl, $986a
  ld de, runstring
  call copystring
  ret

Section "playerhptoramsubroutines",ROM0
p1hptoram:
  
  ld a,[p1hp]
  ld l,a
  ld a,[p1hp1];loads player hp into hl
  ld h,a
  call hptoram; this takes bc (there area of ram it writes to) and hl (the bin number to be turned to dec) 
  ret

p2hptoram:

  ld a,[p2hp]
  ld l,a
  ld a,[p2hp1]
  ld h,a
  call hptoram
  ret

p3hptoram:

  ld a,[p3hp]
  ld l,a
  ld a,[p3hp1]
  ld h,a
  call hptoram
  ret

p4hptoram:

  ld a,[p4hp]
  ld l,a
  ld a,[p4hp1]
  ld h,a
  call hptoram
  ret

Section "hp2ram", ROM0
hptoram:
  push bc
  call bcd16;takes input hl and outputs through cddee
  pop bc



  ld a,e
  and $0f
  ld [bc],a
  inc bc

  ld a,e
  swap a
  and $0f
  ld [bc],a
  inc bc
  
  ld a,d
  and $0f
  ld [bc],a
  inc bc
  ret


Section "bin2dec", ROM0
;converthextodecimal
INCLUDE "bin2bcd.asm"



SECTION "controller i/o", ROM0 ;no inputs, outputs controller as D U L R St Sl B A
readcontroller:

  ld a,P1F_GET_BTN
  ld [rP1],a
  call killtime
  ld a, [rP1]
  and $0f
  ld b,a  

  ld a,P1F_GET_DPAD
  ld [rP1],a
  call killtime
  ld a,[rP1]
  and $0f
  swap a
  or a,b
  ld b,a
  ld a,[controller];this gets last frames cotnroller
  xor a,b;finds whats changed since last frame ie. are they holding the button down?
  ld [controllerdif],a
  ld a,b
  ld [controller],a
  ret




SECTION "fontdata",ROM0

font:
INCBIN "font.chr"
fontend:

SECTION "textdata",ROM0

hpstring:
  db "HP:",0

mpstring:
  db "Mp:",0

attackstring:
  db "attack",0

magicstring:
  db "magic",0

itemstring:
  db "item",0

runstring:
  db "run",0

placeholdernames:

tk:
  db "TK",0

hr:
  db "HR",0
  
bp:
  db "BP",0

kf:
  db "KF",0
 
section "killtime",ROM0
killtime:
  reti



Section "pointerdata", ROM0
pointerdata:
  db $82,$99,$86,$99,$8a,$99,$8e,$99 ;this tells the pointer where on screen to point
pointerdataend:
pointermenudata:
  db $21,$98,$29,$98,$61,$98,$69,$98;tells where to put pointers when menu is poped up
pointermenudataend:
