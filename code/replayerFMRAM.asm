;================================
; The new replayer.
;
; Persistent RAM unswappable
;
;================================
;replay_vib_table:			dw 0			; pointer to the vibrato table
replay_Tonetable:			dw CHIP_ToneTable
replay_PSG_tonetable:		dw	0
replay_FM_tonetable:		dw	0
replay_period:			db	0			; Pitch table for playback

;auto_env_times			db	0
;auto_env_divide			db	0

envelope_ratiotype		db	0
envelope_ratio			db	0
envelope_correction		dw	0
envelope_period			dw	0

CHIP_Instrument			equ 0	
CHIP_Voice				equ 1
CHIP_Command			equ 2
CHIP_MacroPointer			equ 3	
CHIP_Note				equ 5		
CHIP_Volume				equ 6		
CHIP_Flags				equ 7	
	; 0 = note trigger
	; 1 = note active
	; 2 = envelope
	; 3 = command trigger
	; 4 = key trigger		; for fm note trigger	; Do not use for PSG!
	; 5 = sustain		; for fm note sustain	; Do not use for PSG!
	; 6 = custom voice trigger
	; 7 = PSG/SCC
CHIP_MacroStep			equ 8			; reset after note set
CHIP_ToneAdd			equ 9			; reset after note set
CHIP_VolumeAdd			equ 11		; reset after note set
CHIP_Noise				equ 12		; reset after note set


CHIP_cmd_ToneSlideAdd		equ 13		; reset after note set
;CHIP_cmd_VolumeSlideAdd	equ 15		; reset after note set
CHIP_cmd_NoteAdd			equ 15		; reset after note set
CHIP_cmd_ToneAdd			equ 16		; reset after note set
CHIP_cmd_VolumeAdd		equ 18		; reset after note set
CHIP_cmd_0				equ 19
CHIP_cmd_1				equ 20
CHIP_cmd_2				equ 21
CHIP_cmd_3				equ 22
CHIP_cmd_4_depth			equ 23	; pointer to the sine table
CHIP_cmd_4_step			equ 25
;CHIP_cmd_6				equ 26
CHIP_cmd_detune			equ 26

CHIP_cmd_9				equ 28
CHIP_cmd_A				equ 29		
CHIP_cmd_B				equ 30		
CHIP_cmd_E				equ 31
;CHIP_cmd_F				equ 31
CHIP_Timer				equ 32		; used for timing by all cmd's
CHIP_Step				equ 33		; only for VIBRATO???

CHIP_REC_SIZE			equ 34

; Moved to RAM > $c000 to free space for replayer code.
CHIP_Chan1			ds	CHIP_REC_SIZE
CHIP_Chan2			ds	CHIP_REC_SIZE
CHIP_Chan3			ds	CHIP_REC_SIZE
CHIP_Chan4			ds	CHIP_REC_SIZE
CHIP_Chan5			ds	CHIP_REC_SIZE
CHIP_Chan6			ds	CHIP_REC_SIZE
CHIP_Chan7			ds	CHIP_REC_SIZE
CHIP_Chan8			ds	CHIP_REC_SIZE


;--- AY SPECIFIC
AY_registers 
AY_regToneA 	dw	0	; Tone A freq low (8bit)
					; Tone A freq high (4bit)
AY_regToneB 	dw	0	; Tone B freq low
					; Tone B freq high
AY_regToneC 	dw	0	; Tone C freq low
					; Tone C freq high
AY_regNOISE 	db	0	; Noise freq (5bit)
AY_regMIXER 	db	0x38	;x3f	; Mixer control (1 = off, 0 = on)

AY_regVOLA 		db	0	; Chan A volume
AY_regVOLB 		db	0	; Chan B volume
AY_regVOLC		db	0	; Chan C volume

IFDEF TTSMS
;--- Values are used to be able to mute noise when chan is muted,
SN_regVOLNA		db	0
SN_regVOLNB		db 	0

GG_panning		db	0

SN_regVOLN:
ENDIF

AY_regEnvL 		db	0	; Volume Env Freq low (8bit)
SN_regNOISEold	
AY_regEnvH 		db	0	; Volume Env Freq high (4bit)
AY_regEnvShape 	db	0	; Volume Env Shape (4bit)
AY_VOLUME_TABLE   
	; No tail
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$01,$01,$01,$01,$01,$01,$01,$01,$01
	db $00,$00,$00,$00,$01,$01,$01,$01,$01,$01,$01,$01,$02,$02,$02,$02
	db $00,$00,$00,$01,$01,$01,$01,$01,$02,$02,$02,$02,$02,$03,$03,$03
	db $00,$00,$01,$01,$01,$01,$02,$02,$02,$02,$03,$03,$03,$03,$04,$04
	db $00,$00,$01,$01,$01,$02,$02,$02,$03,$03,$03,$04,$04,$04,$05,$05
	db $00,$00,$01,$01,$02,$02,$02,$03,$03,$04,$04,$04,$05,$05,$06,$06
	db $00,$00,$01,$01,$02,$02,$03,$03,$04,$04,$05,$05,$06,$06,$07,$07
	db $00,$01,$01,$02,$02,$03,$03,$04,$04,$05,$05,$06,$06,$07,$07,$08
	db $00,$01,$01,$02,$02,$03,$04,$04,$05,$05,$06,$07,$07,$08,$08,$09
	db $00,$01,$01,$02,$03,$03,$04,$05,$05,$06,$07,$07,$08,$09,$09,$0A
	db $00,$01,$01,$02,$03,$04,$04,$05,$06,$07,$07,$08,$09,$0A,$0A,$0B
	db $00,$01,$02,$02,$03,$04,$05,$06,$06,$07,$08,$09,$0A,$0A,$0B,$0C
	db $00,$01,$02,$03,$03,$04,$05,$06,$07,$08,$09,$0A,$0A,$0B,$0C,$0D
	db $00,$01,$02,$03,$04,$05,$06,$07,$07,$08,$09,$0A,$0B,$0C,$0D,$0E
	db $00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0A,$0B,$0C,$0D,$0E,$0F
	; Tail mode (1)
;	db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
;	db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
;	db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$02,$02,$02,$02
;	db $01,$01,$01,$01,$01,$01,$01,$01,$02,$02,$02,$02,$02,$03,$03,$03
;	db $01,$01,$01,$01,$01,$01,$02,$02,$02,$02,$03,$03,$03,$03,$04,$04
;	db $01,$01,$01,$01,$01,$02,$02,$02,$03,$03,$03,$04,$04,$04,$05,$05
;	db $01,$01,$01,$01,$02,$02,$02,$03,$03,$04,$04,$04,$05,$05,$06,$06
;	db $01,$01,$01,$01,$02,$02,$03,$03,$04,$04,$05,$05,$06,$06,$07,$07
;	db $01,$01,$01,$02,$02,$03,$03,$04,$04,$05,$05,$06,$06,$07,$07,$08
;	db $01,$01,$01,$02,$02,$03,$04,$04,$05,$05,$06,$07,$07,$08,$08,$09
;	db $01,$01,$01,$02,$03,$03,$04,$05,$05,$06,$07,$07,$08,$09,$09,$0A
;	db $01,$01,$01,$02,$03,$04,$04,$05,$06,$07,$07,$08,$09,$0A,$0A,$0B
;	db $01,$01,$02,$02,$03,$04,$05,$06,$06,$07,$08,$09,$0A,$0A,$0B,$0C
;	db $01,$01,$02,$03,$03,$04,$05,$06,$07,$08,$09,$0A,$0A,$0B,$0C,$0D
;	db $01,$01,$02,$03,$04,$05,$06,$07,$07,$08,$09,$0A,$0B,$0C,$0D,$0E
;	db $01,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0A,$0B,$0C,$0D,$0E,$0F
SCC_VOLUME_TABLE 
	; Tail mode off
	db $0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F
	db $0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0E
	db $0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0E,$0D
	db $0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0E,$0D,$0C
	db $0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0E,$0D,$0C,$0B
	db $0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0E,$0D,$0C,$0B,$0A
	db $0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0E,$0D,$0C,$0B,$0A,$09
	db $0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0E,$0D,$0C,$0B,$0A,$09,$08
	db $0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0E,$0D,$0C,$0B,$0A,$09,$08,$07
	db $0F,$0F,$0F,$0F,$0F,$0F,$0F,$0E,$0D,$0C,$0B,$0A,$09,$08,$07,$06
	db $0F,$0F,$0F,$0F,$0F,$0F,$0E,$0D,$0C,$0B,$0A,$09,$08,$07,$06,$05
	db $0F,$0F,$0F,$0F,$0F,$0E,$0D,$0C,$0B,$0A,$09,$08,$07,$06,$05,$04
	db $0F,$0F,$0F,$0F,$0E,$0D,$0C,$0B,$0A,$09,$08,$07,$06,$05,$04,$03
	db $0F,$0F,$0F,$0E,$0D,$0C,$0B,$0A,$09,$08,$07,$06,$05,$04,$03,$02
	db $0F,$0F,$0E,$0D,$0C,$0B,$0A,$09,$08,$07,$06,$05,$04,$03,$02,$01
	db $0F,$0E,$0D,$0C,$0B,$0A,$09,$08,$07,$06,$05,$04,$03,$02,$01,$00
	; Tail mode ON
;	db $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
;	db $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
;	db $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0D
;	db $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0D,$0C
;	db $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0D,$0C,$0B
;	db $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0D,$0C,$0B,$0A
;	db $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0D,$0C,$0B,$0A,$09
;	db $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0D,$0C,$0B,$0A,$09,$08
;	db $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0D,$0C,$0B,$0A,$09,$08,$07
;	db $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0D,$0C,$0B,$0A,$09,$08,$07,$06
;	db $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0D,$0C,$0B,$0A,$09,$08,$07,$06,$05
;	db $0E,$0E,$0E,$0E,$0E,$0E,$0D,$0C,$0B,$0A,$09,$08,$07,$06,$05,$04
;	db $0E,$0E,$0E,$0E,$0E,$0D,$0C,$0B,$0A,$09,$08,$07,$06,$05,$04,$03
;	db $0E,$0E,$0E,$0E,$0D,$0C,$0B,$0A,$09,$08,$07,$06,$05,$04,$03,$02
;	db $0E,$0E,$0E,$0D,$0C,$0B,$0A,$09,$08,$07,$06,$05,$04,$03,$02,$01
;	db $0E,$0E,$0D,$0C,$0B,$0A,$09,$08,$07,$06,$05,$04,$03,$02,$01,$00	




FM_DRUM_LEN		db	0	; Length of drum macro
FM_DRUM_MACRO	dw	0	; Pointer to drum macro data


;FM_softvoice_req	db	0	; Software voice requested
;FM_softvoice_set 	db	0	; Software voice currently loaded


;_KEYJAZZ_LINE:	db	0,0,0,0
;_KJ_PSG:		db	0,0,0,0
;_KJ_PSG2:		db	0,0,0,0
;_KJ_SCC:		db	0,0
;_KJ_DRM1:		db	0,0
;			db	0,0
;_KJ_DRM2:		db	0,0
;			db	0,0,0,0
;			db	0,0,0,0
;			db	0,0,0,0


;FM_Registers: 		; contains the registers values to write and value previously written
;FM_regToneA 	dw 0	; Tone A freq low (8bit)			; Tone A freq high (1bit)
;FM_regToneAb 	dw 0	; Tone A freq low (8bit)			; Tone A freq high (1bit)
;FM_regVOLA		db 0	; Chan A volume
;FM_regVOLAb		db 0	; Chan A volume
;FM_regToneB 	dw 0	; Tone B freq low					; Tone B freq high
;FM_regToneBb 	dw 0	; Tone B freq low					; Tone B freq high
;FM_regVOLB		db 0	; Chan B volume
;FM_regVOLBb		db 0	; Chan B volume
;FM_regToneC 	dw 0	; Tone C freq low					; Tone C freq high
;FM_regToneCb 	dw 0	; Tone C freq low					; Tone C freq high
;FM_regVOLC	 	db 0	; Chan C volume
;FM_regVOLCb	 	db 0	; Chan C volume
;FM_regToneD 	dw 0	; Tone D freq low					; Tone D freq high
;FM_regToneDb 	dw 0	; Tone D freq low					; Tone D freq high
;FM_regVOLD		db 0	; Chan D volume
;FM_regVOLDb		db 0	; Chan D volume
;FM_regToneE 	dw 0	; Tone E freq low					; Tone E freq high
;FM_regToneEb 	dw 0	; Tone E freq low					; Tone E freq high
;FM_regVOLE	  	db 0	; Chan E volume
;FM_regVOLEb	  	db 0	; Chan E volume
;FM_regToneF 	dw 0	; Tone E freq low					; Tone F freq high
;FM_regToneFb 	dw 0	; Tone E freq low					; Tone F freq high
;FM_regVOLF	  	db 0	; Chan F volume
;FM_regVOLFb	  	db 0	; Chan F volume

;DRUM_regToneBD	dw 0
;DRUM_regToneBDb	dw 0
;DRUM_regVolBD	db 0
;DRUM_regVolBDb	db 0
;DRUM_regToneSH	dw 0
;DRUM_regToneSHb	dw 0
;DRUM_regVolSH	db 0
;DRUM_regVolSHb	db 0
;DRUM_regToneCT	dw 0
;DRUM_regToneCTb	dw 0
;DRUM_regVolCT	db 0
;DRUM_regVolCTb	db 0
;FM_DRUM		db 0	; Percussion bits



;FM_DRUM1_LEN	db	0
;FM_DRUM1		dw	0	; pointer to BDrum macro
;FM_DRUM2_LEN	db	0
;FM_DRUM2		dw	0 	; pointer to SN+HHat macro
;FM_DRUM3_LEN	db	0
;FM_DRUM3		dw	0	; pointer to CYm_Tom macro


FM_regMIXER 	db	0	; x3f	; Mixer control (1 = off, 0 = on)

;_AUDITION_LINE:
;		db	0,0,0,0
;		db	0,0,0,0
;		db	0,0,0,0
;		db	0,0,0,0
;		db	0,0,0,0
;		db	0,0,0,0
;		db	0,0,0,0
;		db	0,0,0,0
_PRE_INIT_LINE:
		db	0,0,0,0
		db	0,0,0,0
		db	0,0,0,0
		db	0,0,0,0
		db	0,0,0,0
		db	0,0,0,0
		db	0,0,0,0
		db	0,0,0,0


psgport:	db	0
		
CHIP_FM_ToneTable:
	db   	0,0
	db	0ach,000h,0b7h,000h,0c2h,000h,0cdh,000h,0d9h,000h,0e6h,000h	; Oct 1
     	db	0f4h,000h,002h,001h,012h,001h,022h,001h,033h,001h,046h,001h
      db    0ach,002h,0b7h,002h,0c2h,002h,0cdh,002h,0d9h,002h,0e6h,002h ; Oct 2
      db    0f4h,002h,002h,003h,012h,003h,022h,003h,033h,003h,046h,003h
      db    0ach,004h,0b7h,004h,0c2h,004h,0cdh,004h,0d9h,004h,0e6h,004h ; Oct 3
      db    0f4h,004h,002h,005h,012h,005h,022h,005h,033h,005h,046h,005h
      db    0ach,006h,0b7h,006h,0c2h,006h,0cdh,006h,0d9h,006h,0e6h,006h ; Oct 4
      db    0f4h,006h,002h,007h,012h,007h,022h,007h,033h,007h,046h,007h
      db    0ach,008h,0b7h,008h,0c2h,008h,0cdh,008h,0d9h,008h,0e6h,008h ; Oct 5
      db    0f4h,008h,002h,009h,012h,009h,022h,009h,033h,009h,046h,009h
      db    0ach,00ah,0b7h,00ah,0c2h,00ah,0cdh,00ah,0d9h,00ah,0e6h,00ah ; Oct 6
      db    0f4h,00ah,002h,00bh,012h,00bh,022h,00bh,033h,00bh,046h,00bh
      db    0ach,00ch,0b7h,00ch,0c2h,00ch,0cdh,00ch,0d9h,00ch,0e6h,00ch ; Oct 7
      db    0f4h,00ch,002h,00dh,012h,00dh,022h,00dh,033h,00dh,046h,00dh
      db    0ach,00eh,0b7h,00eh,0c2h,00eh,0cdh,00eh,0d9h,00eh,0e6h,00eh ; Oct 8
      db    0f4h,00eh,002h,00fh,012h,00fh,022h,00fh,033h,00fh,046h,00fh
	
;	db   	0,0
;	db	0adh,000h,0b7h,000h,0c2h,000h,0cdh,000h,0d9h,000h,0e6h,000h	; Oct 1
;     db	0f4h,000h,003h,001h,012h,001h,022h,001h,034h,001h,046h,001h
;     db    0adh,002h,0b7h,002h,0c2h,002h,0cdh,002h,0d9h,002h,0e6h,002h ; Oct 2
;     db    0f4h,002h,003h,003h,012h,003h,022h,003h,034h,003h,046h,003h
;     db    0adh,004h,0b7h,004h,0c2h,004h,0cdh,004h,0d9h,004h,0e6h,004h ; Oct 3
;     db    0f4h,004h,003h,005h,012h,005h,022h,005h,034h,005h,046h,005h
;     db    0adh,006h,0b7h,006h,0c2h,006h,0cdh,006h,0d9h,006h,0e6h,006h ; Oct 4
;     db    0f4h,006h,003h,007h,012h,007h,022h,007h,034h,007h,046h,007h
;     db    0adh,008h,0b7h,008h,0c2h,008h,0cdh,008h,0d9h,008h,0e6h,008h ; Oct 5
;     db    0f4h,008h,003h,009h,012h,009h,022h,009h,034h,009h,046h,009h
;     db    0adh,00ah,0b7h,00ah,0c2h,00ah,0cdh,00ah,0d9h,00ah,0e6h,00ah ; Oct 6
;     db    0f4h,00ah,003h,00bh,012h,00bh,022h,00bh,034h,00bh,046h,00bh
;     db    0adh,00ch,0b7h,00ch,0c2h,00ch,0cdh,00ch,0d9h,00ch,0e6h,00ch ; Oct 7
;     db    0f4h,00ch,003h,00dh,012h,00dh,022h,00dh,034h,00dh,046h,00dh
;     db    0adh,00eh,0b7h,00eh,0c2h,00eh,0cdh,00eh,0d9h,00eh,0e6h,00eh ; Oct 8
;     db    0f4h,00eh,003h,00fh,012h,00fh,022h,00fh,034h,00fh,046h,00fh

IFDEF TTSMS
TRACK_ToneTable:
CHIP_ToneTable:	
	dw	0	;	Dummy value (note 0)
	dw $0001	     ; C1			
	dw $0001	     ; C#1			
	dw $0001	     ; D1			
	dw $0001	     ; D#1			
	dw $0001	     ; E1			
	dw $0001	     ; F1			
	dw $0001	     ; F#1			
	dw $0001	     ; G1
	dw $0001	     ; G#1	
	dw $0001         ; A1
	dw $0001         ; A#1/Bb1 
	dw $0001         ; B1	
	dw $0001	     ; C2			
	dw $0001	     ; C#2			
	dw $0001	     ; D2			
	dw $0001	     ; D#2			
	dw $0001	     ; E2			
	dw $0001	     ; F2			
	dw $0001	     ; F#2			
	dw $0001	     ; G2
	dw $0001	     ; G#2			
   
	dw $03F9      ;A2
	dw $03C0      ; A#2/Bb2 
	dw $038A      ;B2
	dw $0357      ;C3
	dw $0327      ; C#3/Db3 
	dw $02FA      ;D3
	dw $02CF      ; D#3/Eb3 
	dw $02A7      ;E3
	dw $0281      ;F3
	dw $025D      ; F#3/Gb3 
	dw $023B      ;G3
	dw $021B      ; G#3/Ab3 
	dw $01FC      ;A3
	dw $01E0      ; A#3/Bb3 
	dw $01C5      ;B3
	dw $01AC      ;C4
	dw $0194      ; C#4/Db4 
	dw $017D      ;D4
	dw $0168      ; D#4/Eb4 
	dw $0153      ;E4
	dw $0140      ;F4
	dw $012E      ; F#4/Gb4 
	dw $011D      ;G4
	dw $010D      ; G#4/Ab4 
	dw $00FE      ;A4
	dw $00F0      ; A#4/Bb4 
	dw $00E2      ;B4
	dw $00D6      ;C5
	dw $00CA      ; C#5/Db5 
	dw $00BE      ;D5
	dw $00B4      ; D#5/Eb5 
	dw $00AA      ;E5
	dw $00A0      ;F5
	dw $0097      ; F#5/Gb5 
	dw $008F      ;G5
	dw $0087      ; G#5/Ab5 
	dw $007F      ;A5
	dw $0078      ; A#5/Bb5 
	dw $0071      ;B5
	dw $006B      ;C6
	dw $0065      ; C#6/Db6 
	dw $005F      ;D6
	dw $005A      ; D#6/Eb6 
	dw $0055      ;E6
	dw $0050      ;F6
	dw $004C      ; F#6/Gb6 
	dw $0047      ;G6
	dw $0043      ; G#6/Ab6 
	dw $0040      ;A6
	dw $003C      ; A#6/Bb6 
	dw $0039      ;B6
	dw $0035      ;C7
	dw $0032      ; C#7/Db7 
	dw $0030      ;D7
	dw $002D      ; D#7/Eb7 
	dw $002A      ;E7
	dw $0028      ;F7
	dw $0026      ; F#7/Gb7 
	dw $0024      ;G7
	dw $0022      ; G#7/Ab7 
	dw $0020      ;A7
	dw $001E      ; A#7/Bb7 
	dw $001C      ;B7
	dw $001B      ;C8
	dw $0019      ; C#8/Db8 
	dw $0018      ;D8
	dw $0016      ; D#8/Eb8 
	dw $0015      ;E8
	dw $0014      ;F8
	dw $0013      ; F#8/Gb8 
	dw $0012      ;G8
	dw $0011      ; G#8/Ab8 
	dw $0010      ;A8
	dw $000F      ; A#8/Bb8 
	dw $000E      ;B8


	

	
	
ELSE
TRACK_ToneTable:	
CHIP_ToneTable:	
	dw	0
	dw    3420	,3229	,3047	,2876	,2715	,2562	,2419	,2283	,2155	,2034	,1920	,1812
	dw    1710	,1614	,1524	,1438	,1357	,1281	,1209	,1141	,1077	,1017	,960	,906
	dw    855	,807	,762	,719	,679	,641	,605	,571	,539	,508	,480	,453
	dw    428	,404	,381	,360	,339	,320	,302	,285	,269	,254	,240	,226
	dw    214	,202	,190	,180	,170	,160	,151	,143	,135	,127	,120	,113
	dw    107	,101	,95	,90	,85	,80	,76	,71	,67	,64	,60	,57
	dw    53	,50	,48	,45	,42	,40	,38	,36	,34	,32	,30	,28
	dw    27	,25	,24	,22	,21	,20	,19	,18	,17	,16	,15	,14

ENDIF

; Ghost buffer 1
;FM_ghost1:		ds 64	;(ins, vol, tone+1, tone)*16
;
;FM_ghost2:		ds 64	;(ins, vol, tone+1, tone)*16
;FM_ghost3:		ds 64	;(ins, vol, tone+1, tone)*16
;
;
;
;FM_ghost1_stat:	db 0;#1	; status. 0=off 
;FM_ghost1_read:	db 0;#1	; read offset
;FM_ghost1_write:	db 0;#1	; write offset
;FM_ghost1_source:	dw 0;#2	; source channel address
;FM_ghost1_dest:	dw 0;#2	; source channel address
;FM_ghost1_detune:	db 0;#1	; fine tune 
;FM_ghost1_vol:	db 0;#1	; volume 
;
;; Ghost buffer 2
;FM_ghost2_stat:	db 0;#1	; status. 0=off 
;FM_ghost2_read:	db 0;#1	; read offset
;FM_ghost2_write:	db 0;#1	; write offset
;FM_ghost2_source:	dw 0;#2	; source channel address
;FM_ghost2_dest:	dw 0;#2	; source channel address
;FM_ghost2_detune:	db 0;#1	; fine tune 
;FM_ghost2_vol:	db 0;#1	; volume 
;
;; Ghost buffer 3
;FM_ghost3_stat:	db 0;#1	; status. 0=off 
;FM_ghost3_read:	db 0;#1	; read offset
;FM_ghost3_write:	db 0;#1	; write offset
;FM_ghost3_source:	dw 0;#2	; source channel address
;FM_ghost3_dest:	dw 0;#2	; source channel address
;FM_ghost3_detune:	db 0;#1	; fine tune 
;FM_ghost3_vol:	db 0;#1	; volume 
;
;; Generuc Ghost vars
;FM_ghost_delay:	db 0;#1	; delay in (steps) -> tics = speed/2 (max 16)
;FM_ghost_detune:	db 0;#1	; fine tune 
;FM_ghost_vol:	db 0;#1	; volume 




;===========================================================
; ---	replay_play
; Plays the	data according to	the current	replay_mode
; 
;
;===========================================================
replay_play:
	ld	a,(replay_mode)
	and	a
	ret	z	; Replay mode = 0	is silent
	
	dec	a
	jr.	z,replay_mode1	; play music normal
	dec	a
	jr.	z,replay_mode2	; keyjazz
	dec	a
	jr.	z,replay_mode3	; note audition
	dec	a
	jr.	z,replay_mode4	; [ENTER] looped play
	dec	a
	jr.	z,replay_mode5	; stepped playback
	;--- DEBUG
	XOR	A
	LD	(replay_mode),A
	ret

;===========================================================
; ---	replay_init
; Initialize all data for playback
; 
; 
;===========================================================
replay_init:
	; fail save. Check if the replayer is loaded in RAM

	ld	a,(swap_block)
	and	a
	jr.	z,replay_init_cont	; loaded; continue to loaded code.
	
	xor	a
	call	swap_loadblock
	
	jr.	replay_init_cont				

;===========================================================
; ---	replay_stop
; Silence all channels
; 
; 
;===========================================================
replay_stop:
	xor	a
	ld	(replay_mode),a
	ld	(FM_regMIXER),a
	ld	a,00100000b	
	ld	(FM_DRUM),a

	ld	b,6
	ld	hl,FM_Registers+1
	ld	de,6
	xor	a
0:
;	res	4,(hl)
	ld	(hl),a	; reset keyon etc
	add	hl,de
;	ld	(hl),$8	; set volume to silence
;	add	hl,de	
	djnz	0b
	
	call	drum_defaults_set

	ld    a,$f0
      ld    (FM_regVOLA),a
      ld    (FM_regVOLB),a
      ld    (FM_regVOLC),a
      ld    (FM_regVOLD),a
      ld    (FM_regVOLE),a
      ld    (FM_regVOLF),a

IFDEF TTSMS
	;--- Silence the SN7 PSG
      xor	a
	ld	(AY_regVOLA),a
	ld	(AY_regVOLB),a
	ld	(AY_regVOLC),a
	ld	(SN_regVOLN),a

ELSE	
	;--- Silence the AY3 PSG chip
	ld	a,0x3f
	ld	(AY_regMIXER),a
	; Remove envelope
	; Envelope could continue
	ld	a,(AY_regVOLA)
	and	$0f
	ld	(AY_regVOLA),a
	ld	a,(AY_regVOLB)
	and	$0f
	ld	(AY_regVOLB),a
	ld	a,(AY_regVOLC)
	and	$0f
	ld	(AY_regVOLC),a
ENDIF	

      call  replay_route
	ret


;--- Sets the drum default register values.
drum_defaults_set:
	;--- DRUM default values
	ld	a,(drum_type)
	and	1	; This to prevent wrong values
	add	a
	ld	hl,DRM_DEFAULTS
	add	a,l
	ld	l,a
	jr.	nc,99f
	inc	h
99:
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
	
	ld	de,DRUM_regToneBD
	ld	bc,18
	ldir
	ret


replay_set_rhythmmode:
	ld	a,0x0e
	;-- load the new values
	out	(FM_WRITE),a	; Select rythm register
	
	ld	b,$20		; 7 cycles
	ld	a,b			; 4 cycles	; dummy code for delay
	out	(FM_DATA),a	

	ret

