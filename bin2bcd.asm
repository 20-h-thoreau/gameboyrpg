bcd16:: ;takes input hl and outputs through cddee
  ; Bits 15-13: Just shift left into A (12 c)
  xor a
  ld d,a
  ld c,a
  add hl,hl
  adc a
  add hl,hl
  adc a
  add hl,hl
  adc a

  ; Bits 12-8: Shift left into A and DAA (33 c)
  ld b,4
.l1:
  add hl,hl
  adc a
  daa
  dec b
  jr nz,.l1

  ; Bits 7-0: Shift left into E, DAA, into D, DAA, into C (76 c)
  ld e,a
  rl d
  ld b,9
.l2:
  add hl,hl
  ld a,e
  adc a
  daa
  ld e,a
  ld a,d
  adc a
  daa
  ld d,a
  rl c
  dec b
  jr nz,.l2

  ret
