define SPRITE_WIDTH 8

define LOADER_LX 16
define LOADER_RX 43
define LOADER_Y 0
define LOADER_HEIGHT 9

define CEMENT_PLATFORM_Y 8
define CEMENT_PLATFORM_LX 0
define CEMENT_PLATFORM_RX 48 

define STATIONARY_PLATFORM_LEFT_X 13
define STATIONARY_PLATFORM_RIGHT_X 43
define STATIONARY_PLATFORM_TOP_Y 15
define STATIONARY_PLATFORM_BOTTOM_Y 22

define CONTAINER_LEFT_X 2
define CONTAINER_RIGHT_X 54
define LEVER_LEFT_X 10
define LEVER_LEFT_X_TOGGLE 11
define LEVER_RIGHT_X 52
define CONTAINER_TOP_Y 11
define CONTAINER_BOTTOM_Y 17
define LEVER_TOP_Y 11
define LEVER_BOTTOM_Y 17
define CONTAINER_HEIGHT 4

define TRUCK_Y 22
define TRUCK_LX 2
define TRUCK_RX 54
define TRUCK_HEIGHT 10

define DEATHPLANE_X 23
define DEATHPLANE_TOP_Y 0
define DEATHPLANE_BOTTOM_Y 31

define WALL_Y 23
define WALL_LX 20
define WALL_RX 43
define WALL_HEIGHT 9

define DOWN_ARROW_X 38
define DOWN_ARROW_Y 3
define UP_ARROW_X 24
define UP_ARROW_Y 26
define ARROW_HEIGHT 2

define PLAYER_HEIGHT 6

define LIVES_X 53
define LIVES_HEIGHT 3


define PLATFORM_HEIGHT 1
define LEVER_RELEASE_TIME 2

define CONTAINER_TOP_CEMENT_INITIAL_Y 14 ; base of top containers
define CONTAINER_BOTTOM_CEMENT_INITIAL_Y 20 ; base of bottom containers
define CEMENT_HEIGHT 1

define DT_DIV 4

define BUCKET_SPAWN_RND #0F
define BUCKET_SPAWN_RATE 3


JP reset
brk:
	RET
;Draw with height of register V0
;V3=X V4=Y
DRWG: 
	SHL V0,V0
	SHL V0,V0
DRWG_table:
	LD V2, V0 ;Bxxx quirk workaround
	JP V0, DRWG_table
	DRW V3, V4, 1
	JP DRWG_end
	DRW V3, V4, 2
	JP DRWG_end
	DRW V3, V4, 3
	JP DRWG_end
	DRW V3, V4, 4
DRWG_end:
	SHR V0, V0
	SHR V0, V0
	RET
reset:
	;setup
	CLS
	;Some interpreters do not zero initialize ST
	LD V0, 0
	LD ST, V0
	;Detect XO-CHIP and change the color 
	SE VF, VF
	dw #f000 ; LD I, ABS.16
	SE VF, VF
	dw #f201 ; PLN 2

	;draw the loaders
	LD V3, LOADER_LX
	LD V4, LOADER_Y
	LD I, loader_left
	DRW V3, V4, LOADER_HEIGHT
	LD V3, LOADER_RX
	LD I, loader_right
	DRW V3, V4, LOADER_HEIGHT

	;draw the left cement platform
	LD I, platform
	LD V4, CEMENT_PLATFORM_Y
	LD V3, CEMENT_PLATFORM_LX
	DRW V3, V4, PLATFORM_HEIGHT
	ADD V3, 8
	DRW V3, V4, PLATFORM_HEIGHT
	LD V3, CEMENT_PLATFORM_RX
	DRW V3, V4, PLATFORM_HEIGHT
	ADD V3, 8
	DRW V3, V4, PLATFORM_HEIGHT

	;draw the stationary platforms
	LD V3, STATIONARY_PLATFORM_LEFT_X
	LD V4, STATIONARY_PLATFORM_TOP_Y
	DRW V3, V4, PLATFORM_HEIGHT
	LD V5, STATIONARY_PLATFORM_RIGHT_X
	DRW V5, V4, PLATFORM_HEIGHT
	LD V4, STATIONARY_PLATFORM_BOTTOM_Y
	DRW V5, V4, PLATFORM_HEIGHT
	DRW V3, V4, PLATFORM_HEIGHT

	;draw the containers
	LD I, container
	LD V3, CONTAINER_LEFT_X
	LD V4, CONTAINER_TOP_Y
	DRW V3, V4, CONTAINER_HEIGHT
	LD V5, CONTAINER_RIGHT_X
	DRW V5, V4, CONTAINER_HEIGHT
	LD V4, CONTAINER_BOTTOM_Y
	DRW V3, V4, CONTAINER_HEIGHT
	DRW V5, V4, CONTAINER_HEIGHT

	;draw the truck
	LD I, truck
	LD V3, TRUCK_LX
	LD V4, TRUCK_Y
	DRW V3, V4, TRUCK_HEIGHT
	LD V3, TRUCK_RX
	DRW V3, V4, TRUCK_HEIGHT

	;draw death plane
	LD I, death_plane
	LD V3, DEATHPLANE_X
	LD V4, DEATHPLANE_TOP_Y
	LD V5, DEATHPLANE_BOTTOM_Y
	DRW V3, V4, 1
	DRW V3, V5, 1
	ADD V3, SPRITE_WIDTH
	DRW V3, V4, 1
	DRW V3, V5, 1

	;draw wall
	LD I, wall
	LD V3, WALL_LX
	LD V4, WALL_Y
	LD V5, WALL_RX
	DRW V3, V4, WALL_HEIGHT
	DRW V5, V4, WALL_HEIGHT
	LD I, down_arrow
	LD V3, DOWN_ARROW_X
	LD V4, DOWN_ARROW_Y
	DRW V3, V4, ARROW_HEIGHT
	LD I, up_arrow
	LD V3, UP_ARROW_X
	LD V4, UP_ARROW_Y
	DRW V3, V4, ARROW_HEIGHT
	
	;Detect XO-CHIP and change the color
	SE VF, VF
	dw #f000 ; LD I, ABS.16
	SE VF, VF
	dw #f101 ; PLN 1
	;JP debug_draw_all_player_positions
	CALL draw_player
	
	LD I, life_spr
	LD V3, LIVES_X
	LD V4, 0
	LD V5, 3
life_draw_loop:
	DRW V3, V4, LIVES_HEIGHT
	ADD V3, 4
	ADD V5, -1
	SE V5, 0
	JP life_draw_loop


	LD I, lever_left
	LD V3, LEVER_LEFT_X
	LD V4, LEVER_TOP_Y
	LD V5, LEVER_BOTTOM_Y
	DRW V3, V4, 2
	DRW V3, V5, 2
	LD I, lever_right
	LD V3, LEVER_RIGHT_X
	DRW V3, V4, 2
	DRW V3, V5, 2



	


main_game_loop:
	LD V1, DT
	SE V1, 0
	JP main_game_loop
	LD V1, DT_DIV
	LD DT, V1
	
	LD I, cur_lever
	LD V0, [I]
	SE V0, 0
	CALL process_lever_release
	CALL process_frame

	;update tick count
	LD I, time_since_last_tick
	LD V1, [I]
	ADD V0, 1
	;If speed=time_since_last_tick process the frame 
	SNE V1, V0 
	LD V0, 0
	LD I, time_since_last_tick
	LD [I], V1 ; Update the time struct
	SNE V0, 0
	CALL process_tick
	CALL process_input
	JP main_game_loop

;subroutines

process_frame:
	; Add 1 to frame counter
	LD I, frame_count
	LD V3, [I]
	LD V8, 1
	ADD V0, V8
	ADD V1, VF
	ADD V2, VF
	ADD V3, VF
	LD I, frame_count
	LD [I], V3


	; Once about every half minute, raise the speed
	LD V8, 1
	AND V8, V1
	OR V8, V0
	SE V8, 0
	RET
	LD I, speed
	LD V0, [I]
	SNE V0, 2
	RET
	ADD V0, -1
	LD I, speed
	LD [I], V0
	RET

define BUCKET_Y 4
define BUCKET_END_LX 0
define BUCKET_END_RX 59
define BUCKET_START_LX 12
define BUCKET_START_RX 47
define BUCKET_HEIGHT 4

define BUCKET_FULL_EMPTY_BOUNDARY_LX 8
define BUCKET_FULL_EMPTY_BOUNDARY_RX 51

define PLATFORM_START_RY 8
define PLATFORM_START_LY 29
define PLATFORM_END_LY 8
define PLATFORM_END_RY 29
define PLATFORM_RX 33
define PLATFORM_LX 23  
define PLATFORM_NOPLATFORM_BOUNDARY_LY 8
define PLATFORM_NOPLATFORM_BOUNDARY_RY 1


process_left_buckets:
	; Move Left Buckets Around
	LD I, buckets_pos_left
	LD V0, [I]
	LD V1, V0
	SNE V1, 0
	JP skip_move_left_bucket

	LD V3, BUCKET_END_LX
	LD V4, BUCKET_Y
	LD V8, -4
	LD V9, 0
	LD V0, BUCKET_HEIGHT
	LD VA, BUCKET_FULL_EMPTY_BOUNDARY_LX
	LD VB, BUCKET_HEIGHT

	LD I, empty_bucket
	CALL move_random_sprite
	;rotate the position bitmask
	LD I, buckets_pos_left
	LD V0, [I]
	LD V1, V0
	SHL V1, V1
	CALL drop_cement_left

skip_move_left_bucket:
	;Randomly Generate Left Bucket
	RND V7, BUCKET_SPAWN_RND
	LD VA, BUCKET_SPAWN_RATE
	SUB V7,VA
 	SNE VF, 0
	CALL add_bucket_left
	; save the position bitmask
	LD I, buckets_pos_left
	LD V0, V1
	LD [I], V0
	RET

add_bucket_left:
	LD V3, BUCKET_START_LX
	LD V4, BUCKET_Y
	LD V2, #10
	OR V1, V2
	LD I, full_bucket
	DRW V3, V4, BUCKET_HEIGHT
	RET

; Drop cement from bucket into left container
drop_cement_left:
	LD V8, #40 
	AND V8, V1
	SNE V8, 0
	RET
	LD I, cement_fill_level_top_left
	LD V0, [I]
	LD VB, 0
	SNE V0, 3
	JP miss_cement
	;increment cement
	ADD V0, 1
	LD I, cement_fill_level_top_left
	LD [I], V0
	LD V8, V0
	LD V3, CONTAINER_LEFT_X
	LD V4, CONTAINER_TOP_CEMENT_INITIAL_Y
	JP draw_cement

drop_cement_right:
	LD V8, #02
	AND V8, V1
	SNE V8, 0
	RET
	LD I, cement_fill_level_top_right
	LD V0, [I]
	LD VB, 1
	SNE V0, 3
	JP miss_cement
	ADD V0, 1
	LD I, cement_fill_level_top_right
	LD [I], V0

	;draw cement in right place
	
	LD V8, V0
	LD V3, CONTAINER_RIGHT_X
	LD V4, CONTAINER_TOP_CEMENT_INITIAL_Y
	JP draw_cement

process_right_buckets:
	; Move Right Buckets Around
	LD I, buckets_pos_right
	LD V0, [I]
	LD V1, V0
	SNE V1, 0
	JP skip_move_right_buckets

	LD V3, BUCKET_END_RX
	LD V4, BUCKET_Y
	LD V8, 4
	LD V9, 0
	LD V0, BUCKET_HEIGHT
	LD VA, BUCKET_FULL_EMPTY_BOUNDARY_RX
	LD VB, BUCKET_HEIGHT
	LD I, empty_bucket
	CALL move_random_sprite

	;rotate the position bitmask
	LD I, buckets_pos_right
	LD V0, [I]
	LD V1, V0
	SHR V1, V1

	;LD V5, 1
	CALL drop_cement_right
	
skip_move_right_buckets:
	;Randomly Generate Right Bucket
	LD V3, BUCKET_START_RX
	LD V4, BUCKET_Y
	RND V7, BUCKET_SPAWN_RND
	LD VA, BUCKET_SPAWN_RATE
	SUB V7,VA
 	SNE VF, 0
	CALL add_bucket_right
	
	; save the position bitmask
	LD I, buckets_pos_right
	LD V0, V1
	LD [I], V0
	RET
add_bucket_right:
	LD V3, BUCKET_START_RX
	LD V4, BUCKET_Y
	LD V2, #08
	OR V1, V2
	LD I, full_bucket
	DRW V3, V4, BUCKET_HEIGHT
	RET
process_left_platforms:
	; Move Left Platforms Around
	LD I, platforms_pos_left
	LD V0, [I]
	LD V1, V0
	SNE V1, 0
	JP skip_move_left_platforms

	LD V3, PLATFORM_LX
	LD V4, PLATFORM_END_LY
	LD V8, 0
	LD V9, -7
	LD V0, PLATFORM_HEIGHT
	LD VA, PLATFORM_NOPLATFORM_BOUNDARY_LY
	LD VB, 1
	LD I, no_platform
	CALL move_random_sprite

	;rotate the position bitmask
	LD I, platforms_pos_left
	LD V0, [I]
	SHL V0, V0
	; save the position bitmask (move_player needs it to be in memory)
	LD I, platforms_pos_left 
	LD [I], V0

	; If the player is on the platforms rotate them
	LD I, player_pos_struct
	LD V1, [I]
	LD V3, V0
	LD V4, V1
	SNE V3, 1
	CALL rotate_player_left_platforms


	LD I, platforms_pos_left
	LD V0, [I]
	LD V1, V0
skip_move_left_platforms:
	; Randomly Generate Left Platform
	LD I, ticks_to_next_platform_left
	LD V0, [I]
	SNE V0, 0
	CALL add_platform_left
	ADD V0, -1
	LD I, ticks_to_next_platform_left
	LD [I], V0

	; save the position bitmask
	LD I, platforms_pos_left 
	LD V0, V1
	LD [I], V0
	RET
add_platform_left:
	LD V3, PLATFORM_LX
	LD V4, PLATFORM_START_LY
	LD V2, #10
	OR V1, V2
	LD I, platform
	DRW V3, V4, PLATFORM_HEIGHT

	RND V7, 3
	ADD V7, 2
	LD V0, V7
	;LD V0, 1
	LD I, ticks_to_next_platform_left
	LD [I], V0
	RET

process_right_platforms:
	; Move Right Platforms Around
	LD I, platforms_pos_right
	LD V0, [I]
	LD V1, V0
	; LD VC, #0F
	; AND V1, VC
	SNE V1, 0
	JP skip_move_right_platforms

	LD V3, PLATFORM_RX
	LD V4, PLATFORM_END_RY
	LD V8, 0
	LD V9, 7
	LD V0, PLATFORM_HEIGHT
	LD VA, -128
	LD VB, 0
	LD I, platform
	CALL move_random_sprite

	; rotate the position bitmask
	LD I, platforms_pos_right
	LD V0, [I]
	SHR V0, V0
	; save the position bitmask (move_player needs it to be in memory)
	LD I, platforms_pos_right
	LD [I], V0


	; If the player is on the platforms rotate them
	LD I, player_pos_struct
	LD V1, [I]
	LD V3, V0
	LD V4, V1
	SNE V3, 2
	CALL rotate_player_right_platforms

	LD I, platforms_pos_right
	LD V0, [I]
	LD V1, V0
skip_move_right_platforms:
	; Randomly Generate Right Platform
	LD I, ticks_to_next_platform_right
	LD V0, [I]
	SNE V0, 0
	CALL add_platform_right
	ADD V0, -1
	LD I, ticks_to_next_platform_right
	LD [I], V0

	; save the position bitmask
	LD I, platforms_pos_right
	LD V0, V1
	LD [I], V0

	RET
add_platform_right:
	LD V3, PLATFORM_RX
	LD V4, PLATFORM_START_RY
	LD V2, #08
	OR V1, V2
	LD I, platform
	DRW V3, V4, PLATFORM_HEIGHT



	RND V7, 3
	ADD V7, 2
	LD V0, V7
	;LD V0, 1
	LD I, ticks_to_next_platform_right
	LD [I], V0
	RET

process_tick:
	; Add 1 to tick counter
	LD I, tick_count
	LD V3, [I]
	LD V8, 1
	ADD V0, V8
	ADD V1, VF
	ADD V2, VF
	ADD V3, VF
	LD I, tick_count
	LD [I], V3

	LD V8, 3
	AND V8, V0
	SNE V8, 0 
	CALL process_left_buckets

	LD I, tick_count
	LD V0, [I]
	LD V8, 3
	AND V8, V0
	SNE V8, 2 
	CALL process_right_buckets

	LD I, tick_count
	LD V0, [I]
	LD V8, 1
	AND V8, V0
	SNE V8, 0 
	CALL process_left_platforms

	; Move Right Platforms Around
	LD I, tick_count
	LD V0, [I]
	LD V8, 1
	AND V8, V0
	SNE V8, 1
	CALL process_right_platforms

	RET
	
; click_lever:
; 	LD VF, VF
; 	RET


; This moves 4 sprites based on an 4 bit bitmask
; moving the left nybble left and the right nybble right
; V3=end x
; V4=end y
; V8=delta x
; V9=delta y
; I = sprite
; V1 = bitmask (high nybble is occupied for left, low nybble for right)
; V0 = Height
; VA = optional X or Y boundary, -1 for no boundary
; VB = offset for new sprite after boundary
move_random_sprite:
	LD V5, 4
	;V7 is nonzero if right has stuff in it and 0 otherwise
	;presumably with stuff in the left
	LD V7, #0F 
	AND V7, V1
move_loop:
		SE V7, 0
		SHR V1, V1
		SNE V7, 0
		SHL V1, V1
		SNE VF, 0
		JP skip_draw
		LD V6, 2
		ADD V3, V8
		ADD V4, V9
		move_loop_inner:
			;Check if the bucket is before or after the boundary and set I 
			;accordingly 
			SNE V3,VA
			JP switch_sprite
			SE V4, VA
			JP dont_switch_sprite
		switch_sprite:
			ADD I, VB
			LD VA, -128
		dont_switch_sprite:

			; make sure it isn't drawn off screen
			LD VC, #3F
			SUBN VC, V3
			SE VF, 0
			JP out_of_bounds
			LD VC, #1F
			SUBN VC, V4
			SNE VF, 0
		not_out_of_bounds:
			CALL DRWG
		out_of_bounds:

			;go to next loop iteration
			SUB V3, V8 ;subtract vel from X
			SUB V4, V9 ;subtract vel from Y

			ADD V6, -1
			SE V6, 0
			JP move_loop_inner
		ADD V3, V8
		ADD V4, V9

	skip_draw:
		SNE V3,VA
		JP switch_sprite2
		SE V4, VA
		JP dont_switch_sprite2
	switch_sprite2:
		ADD I, VB
		LD VA, -128
	dont_switch_sprite2:
		SUB V3, V8
		SUB V4, V9

		ADD V5, -1
		SE V5, 0
		JP move_loop
	RET


; draw or erases player based on player_pos_struct
erase_player:
draw_player:
	LD I, player_pos_struct
	LD V1, [I]

	;calculate V5=(V1*4+V0)*6
	LD V5, V1
	SHL V5, V5
	SHL V5, V5
	ADD V5, V0
	SHL V5, V5
	LD V6, V5
	SHL V6, V6
	ADD V5, V6

	; draw the player in the right position
	LD I, player_pos_table_x
	ADD I, V0
	LD V0, [I]
	LD V3, V0

	LD I, player_pos_table_y
	ADD I, V1
	LD V0, [I]
	LD V4, V0
	LD I, player_spr_table
	ADD I, V5
	DRW V3, V4, PLAYER_HEIGHT
	RET

define Q4 4
define W5 5
define A7 7
define S8 8
define E6 6
define RD 13
define D9 9
define FE 14

process_input:
	CALL process_input_movement
	JP process_input_lever

define LEVER_BUTTON_BITMASK_LOW %01000000
define LEVER_BUTTON_BITMASK_HIGH %01100010

process_input_lever:

	LD I, prev_lever_input_state
	LD V0, [I]
	SE V0, 0
	JP check_lever_input_release


	; Test the lever key
	;LD V6, 0
	LD V6, E6
	LD V7, RD
	SKP V6
	SKNP V7
	JP push_lever
	
	LD V6, D9
	LD V7, FE
	
	SKP V6
	SKNP V7
	JP push_lever
	RET

push_lever:

	LD I, cur_lever
	LD V0, [I]
	SE V0, 0
	RET

	LD I, prev_lever_input_state
	LD V0, 1
	LD [I], V0

	LD I, player_pos_struct
	LD V1, [I]
	LD V3, V0
	LD V4, V1
	LD V5, 0

	; Check if the player is in X position 0 or 3 
	; Because the player is in a valid position 
	; X 0 or 3 is next to a lever
	SNE V3, 0
	ADD V5, 1

	SNE V3, 3
	ADD V5, 2

	;If not next to a lever return
	SNE V5, 0
	RET

	;If it's 2 then it's one of the bottom levers
	SNE V4, 2
	ADD V5, 2

	LD I, lever_struct
	LD V0, V5
	LD V1, LEVER_RELEASE_TIME
	LD [I], V1


	CALL toggle_lever_graphics
	JP release_cement


check_lever_input_release:
	; Test the lever key
	LD V6, E6
	LD V7, RD

	SKP V6
	SKNP V7
	RET

	LD V6, D9
	LD V7, FE

	SKP V6
	SKNP V7
	RET

	;Lever key is released
	LD V0, 0
	LD I, prev_lever_input_state
	LD [I], V0
	RET

process_lever_release:
	LD I, time_until_lever_release
	LD V0, [I]

	SNE V0, 0
	JP release_lever

	ADD V0, -1
	LD I, time_until_lever_release
	LD [I], V0

	RET
release_lever:
	CALL toggle_lever_graphics
	LD V0, 0
	LD I, cur_lever
	LD [I], V0

	RET




process_input_movement:

	;set V1 with the current horizontal direction
	LD V1, 0

	LD V6, A7
	LD V7, Q4
	SKP V6
	SKNP V7
	ADD V1, -1 

	LD V6, S8
	LD V7, W5	
	SKP V6
	SKNP V7
	ADD V1, 1 

	; get last frame's input
	LD I, nowdirection
	LD V0, [I]
	
	; Save it
	LD I, prevdirection
	LD [I], V1

	; Check if direction changed and isn't neutral
	SE V0, V1
	SNE V1, 0
	RET

	LD V3, V1
	LD I, player_pos_struct
	LD V1, [I]
	ADD V3, V0
	LD V4, V1


	; check if the player is in bounds
	SE V3, 4
	SNE V3, -1
	RET
	; Check if player is inside one of the walls
	SE V3, 0
	SNE V3, 3
	JP skip_check_V3
	LD V0, 1
	LD ST, V0
	JP move_player
skip_check_V3:
	SE V4, 0
	SNE V4, 3
	RET
	LD V0, 1
	LD ST, V0

;expects a VALID move (either moving or falling off,
; no moves to an illegal position) and processes it.
move_player:
	LD I, temp_storage
	LD [I], V4
	;erase old player
	CALL erase_player

	LD I, temp_storage
	LD V4, [I]

	LD V0, V3
	LD V1, V4
	LD I, player_pos_struct
	LD [I], V1

	CALL draw_player


	LD I, player_pos_struct
	LD V1, [I] 
	SNE V0, 1
	JP fall_check_platforms_left
	SNE V0, 2
	JP fall_check_platforms_right
	RET
fall_check_platforms_left:
	;I only really care about the y position so it's fine to clobber x
	LD I, platforms_pos_left
	LD V0, [I]

fall_check_left_loop:
	;check if the correct platform pos bit is set
	ADD V1, -1
	SHL V0, V0
	SE V1, -1
	JP fall_check_left_loop

	SNE VF, 0
	CALL fall
	RET
fall_check_platforms_right:
	;I only really care about the y position so it's fine to clobber x
	LD I, platforms_pos_right
	LD V0, [I]
	LD V8, 3
	SUBN V1, V8
fall_check_right_loop:
	;check if the correct platform pos bit is set
	ADD V1, -1
	SHR V0, V0
	SE V1, -1
	JP fall_check_right_loop

	SNE VF, 0
	CALL fall
	RET
define FALL_DIV 30
; takes over and plays the fall animation
fall:
fall_loop:
	LD V8, FALL_DIV
	LD DT, V8
fall_wait:
	LD V8, DT
	SE V8, 0
	JP fall_wait
	
	CALL erase_player
	;if animation is over hit the death barrier
	LD I, player_pos_struct
	LD V1, [I]
	SNE V1, 3
	JP hit_death_barrier

	; draw player one step down
	ADD V1, 1
	LD I, player_pos_struct
	LD [I], V1
	CALL draw_player
	LD V0, 4
	LD ST, V0
	JP fall_loop
; plays hit death barrier animation
define HIT_DEATH_DIV 90
hit_death_barrier_with_erase:
	CALL erase_player
hit_death_barrier:
	LD V8, HIT_DEATH_DIV
	LD DT, V8
	LD V8, 30
	LD ST, V8
hit_death_barrier_wait:
	LD V8, DT
	SE V8, 0
	JP hit_death_barrier_wait


	LD I, player_pos_struct
	LD V1, 1
	LD V0, 0
	LD [I], V1
	CALL draw_player

	JP lose_life_and_reset

rotate_player_left_platforms:
	SNE V4, 0
	JP hit_death_barrier_with_erase
	ADD V4, -1
	JP move_player

rotate_player_right_platforms:
	SNE V4, 3
	JP hit_death_barrier_with_erase
	ADD V4, 1
	JP move_player
; 
lose_life_and_reset:
	;decrement life counter
	LD I, lives
	LD V0, [I]
	ADD V0, -1
	
	;remove one of the lives
	LD I, life_spr
	LD V3, V0
	SHL V3, V3
	SHL V3, V3
	ADD V3, LIVES_X
	LD V4, 0
	DRW V3, V4, LIVES_HEIGHT


	;if the player ran out of lives display final score
	SNE V0, 0
	CALL show_score

	LD I, lives
	LD [I], V0
	RET
define CEMENT_MISS_DIV 15
define CEMENT_FLASH_COUNT 9
; VB - container that overflowed
; 
miss_cement:

	LD V9, 1
	AND V9, VB
	LD VA, 2
	AND VA, VB
	
	LD V5, CONTAINER_LEFT_X 
	LD V6, CONTAINER_TOP_CEMENT_INITIAL_Y

	SE V9,0
	LD V5, CONTAINER_RIGHT_X
	SE VA,0
	LD V6, CONTAINER_BOTTOM_CEMENT_INITIAL_Y


	LD V7, 0
	miss_cement_outer_loop:
		
		LD V8, 1
		blink_loop:
			LD V3, V5
			LD V4, V6
			CALL draw_cement
			ADD V8, 1
			SE V8, 4
			JP blink_loop


		LD V8, 5
		LD ST, V8

		LD V8, CEMENT_MISS_DIV
		LD DT, V8
		miss_cement_spinlock:
			LD V8, DT 
			SE V8, 0
			JP miss_cement_spinlock
		ADD V7, 1
		SE V7,CEMENT_FLASH_COUNT
		JP miss_cement_outer_loop
	LD I, cement_fill_levels
	ADD I, VB
	LD V0, 0
	LD [I],V0
	JP lose_life_and_reset

toggle_lever_graphics:
	LD V3, LEVER_LEFT_X_TOGGLE
	LD V4, LEVER_TOP_Y

	LD I, cur_lever
	LD V0, [I]
	ADD V0, -1
	LD V8, 1
	AND V8, V0
	LD V9, 2
	AND V9, V0

	SE V8, 0
	LD V3, LEVER_RIGHT_X

	SE V9, 0
	LD V4, LEVER_BOTTOM_Y

	LD I, lever_activate
	DRW V3, V4, 3
	RET
; Draw or remove cement
; V3 X Pos
; V4 Y Pos
; V8 fill_level
; Clobbers V0 V3 V4
remove_cement:
draw_cement:
	;draw cement in right place
	LD V0, 1
	AND V0, V8 ; shift X 1 left if V0 is even
	ADD V3, V0
	SUB V4, V8

	LD I, cement
	DRW V3, V4, CEMENT_HEIGHT
	RET

release_cement:
	LD I, cur_lever
	LD V0, [I]
	LD VB, V0
	ADD VB, -1
	LD V9, 1
	AND V9, VB
	LD VA, 2
	AND VA, VB
	
	LD V3, CONTAINER_LEFT_X 
	LD V4, CONTAINER_TOP_CEMENT_INITIAL_Y

	SE V9,0
	LD V3, CONTAINER_RIGHT_X
	SE VA,0
	LD V4, CONTAINER_BOTTOM_CEMENT_INITIAL_Y
	LD I, cement_fill_levels
	ADD I, VB
	LD V0, [I]
	LD V8, V0
	SNE V8, 0
	RET
	CALL remove_cement
	ADD V8, -1
	LD I, cement_fill_levels
	ADD I, VB
	LD V0, V8
	LD [I], V0

	LD VC, VA
	ADD VC, 2
	LD ST, VC
	
	SNE VA, 0
	CALL add_cement_row_down

	LD V8, 1
	SE VA, 0
	LD V8, 2
	CALL increment_score


	RET
;VB top container
add_cement_row_down:
	LD V3, CONTAINER_LEFT_X
	LD V4, CONTAINER_BOTTOM_CEMENT_INITIAL_Y

	SE V9,0
	LD V3, CONTAINER_RIGHT_X
	ADD VB, 2
	LD I, cement_fill_levels
	ADD I, VB
	LD V0, [I]
	SNE V0, 3
	JP miss_cement
	LD V8, V0
	ADD V8, 1
	CALL draw_cement

	LD I, cement_fill_levels
	ADD I, VB
	LD V0, V8
	LD [I], V0
	

	RET
;TODO
show_score:
	;PLN needs to be 3 to clear the screen properly

	SE VF, VF
	dw #f000 ; LD I, ABS.16
	SE VF, VF
	dw #f301 ; PLN 3
	CLS
	SE VF, VF
	dw #f000 ; LD I, ABS.16
	SE VF, VF
	dw #f101 ; PLN 1


	LD V3, 3
	LD V4, 14

	LD I, score
	LD V1, [I]
	LD V8, V0
	LD V9, V1
	LD I, temp_storage
	LD B, V8
	LD V2, [I]

	CALL draw_2_digits

	LD I, temp_storage
	LD B, V9
	LD V2, [I]

	CALL draw_2_digits
stuck:
	JP stuck

draw_2_digits:
	LD F, V1
	DRW V3, V4, 5
	ADD V3, 5

	LD F, V2
	DRW V3, V4, 5
	ADD V3, 5
	RET
;Wait for a reset

debug_draw_all_player_positions:
	LD VB,0
	debug_draw_all_player_positions_outer_loop:
		LD VA,0 
		debug_draw_all_player_positions_inner_loop:
			LD V0, VA
			LD V1, VB
			LD I, player_pos_struct
			LD [I], V1
			call draw_player
			ADD VA, 1
			SE VA, 4
			JP debug_draw_all_player_positions_inner_loop
		ADD VB, 1
		SE VB, 4
		JP debug_draw_all_player_positions_outer_loop

	JP stuck
;V8 - Amount to Increment
increment_score:
	LD I, score
	LD V1, [I]
	ADD V1, V8
	LD V9, V1
	LD VA, 100
	SUB V9, VA
	SNE VF, 0
	JP increment_score_skip
	LD V1, V9
	ADD V0, 1
	SNE V0, 100
	JP cap_score
increment_score_skip:
	LD I, score
	LD [I], V1
	RET
cap_score:
	LD V0, 99
	LD V1, 99
	JP increment_score_skip
end_code_segment:

;data 
OFFSET #900
;graphics data
;I need 2 because ADD I, Vx can only increment
;And I need it to go both ways
no_platform: db %00000000
platform: db %11111111
no_platform2: db %00000000

container:
	db 
		 %10000001,
		 %10000001,
		 %10000001,
		 %11111111
truck: 
	db  
		%01000010,
		%00100100,
		%01111110,
		%10000001,
		%10000001,
		%11100111,
		%10100101,
		%11111111,
		%01100110,
		%01100110
loader_left:
	db
		%01111000,
		%01111000,
		%01111000,
		%01111000,
		%01101000,
		%01011000,
		%01101000,
		%01111000,
		%11111000

loader_right:
	db
		%11110000,
		%11110000,
		%11110000,
		%11110000,
		%10110000,
		%11010000,
		%10110000,
		%11110000,
		%11111000
down_arrow:
	db
		%10100000,
		%01000000
up_arrow:
	db
		%01000000,
		%10100000
death_plane: db %01010101
wall:
	db
		%10000000,
		%10000000,
		%10000000,
		%10000000,
		%10000000,
		%10000000,
		%10000000,
		%10000000,
		%10000000

empty_bucket:
	db
		%01010000,
		%01010000,
		%01010000,
		%01110000
full_bucket:
	db
		%01110000,
		%01110000,
		%01110000,
		%01110000

player_spr_table:
	db ; 0,0 (impossible)
		0,0,0,0,0,0
	db ; 1,0
		%00001100,
		%10011000,
		%01100110,
		%00011000,
		%00011000,
		%00100100
	db ; 2,0
		%00110000,
		%10011000,
		%01100100,
		%00011110,
		%00011000,
		%00100100
	db ; 3,0 (impossible)
		0,0,0,0,0,0
	db ; 0,1
		%00011000,
		%00011000,
		%11100100,
		%00011010,
		%00011000,
		%00100100
	db ; 1,1
		%00110000,
		%00110010,
		%01001100,
		%10111000,
		%00100100,
		%00100010
	db ; 2,1
		%00110000,
		%00110000,
		%11001100,
		%00111010,
		%01001000,
		%01001000
	db ; 3,1
		%00011000,
		%00011000,
		%00100111,
		%01011000,
		%00011000,
		%00100100

	db ; 0,2
		%00011000,
		%10011000,
		%01100100,
		%00011010,
		%00011000,
		%00100100
	db ; 1,2
		%00011000,
		%01011000,
		%00100100,
		%00011010,
		%00101000,
		%01000100
	db ; 2,2
		%00011000,
		%00011000,
		%00100100,
		%01011010,
		%00011000,
		%00100100
	db ; 3,2
		%00011000,
		%00011001,
		%00100110,
		%01011000,
		%00011000,
		%00100100
	db ; 0,0 (impossible)
		0,0,0,0,0,0
	db ; 1,0
		%00001100,
		%00011000,
		%01100110,
		%10011001,
		%00011000,
		%00100100
	db ; 2,0
		%00110000,
		%00011001,
		%01100110,
		%10011000,
		%00011000,
		%00100100
	db ; 3,0 (impossible)
		0,0,0,0,0,0
life_spr:
	db 
		%01000000,
		%11100000,
		%01000000
cement: db %01010100
lever_left:
	db
		%01000000,
		%10000000
lever_right:
	db
		%10000000,
		%01000000
lever_activate:
	db 
		%10000000,
		%00000000,
		%10000000

;constant data
player_pos_table_x:
	db 13, 23, 33, 43
player_pos_table_y:
	db 2, 9, 16, 23


; variables
time_governing_struct: ; 6 bytes
time_since_last_tick: db 0
speed: db 12
frame_count: dw 0,0
tick_count: dw 0,0

buckets_pos:
;most significant nybble is for left buckets
buckets_pos_left: db %00000000
;least significant nybble is for right buckets
buckets_pos_right: db %00000000

;least significant nibble is the positions of the left platforms MSB is top.
platforms_pos_left: db %00000000
;least significant nibble is the positions of the right platforms MSB is top. 
platforms_pos_right: db %00000000

;coarse player position
player_pos_struct: 
player_pos_x: db 0
player_pos_y: db 1

;button states this frame and last frame
prevdirection:
	db 0
nowdirection:
	db 0
prev_lever_input_state:
	db 0
lives: db 3

;fill levels for all cement tubs
cement_fill_levels:
cement_fill_level_top_left: db 0
cement_fill_level_top_right: db 0
cement_fill_level_bottom_left: db 0
cement_fill_level_bottom_right: db 0

lever_struct:
cur_lever: db 0
time_until_lever_release: db 0
ticks_to_next_platform_left: db 0
ticks_to_next_platform_right: db 0

score:
score_hi:
	db 0
score_lo: 
	db 0
temp_storage: ;8 bytes
	db #cc, #cc, #cc, #cc,
		#cc, #cc, #cc, #cc
end_data_segment:



OFFSET #fd0
;metadata
dw end_code_segment-#200
dw end_data_segment-#900
OFFSET #fe0
;my signature
db #4e, #6f, #61, #6d, #20, #47, #69, #6c
db #6f, #72, #20, #28, #6f, #73, #68, #61
db #62, #6f, #79, #29, #20, #32, #30, #32
db #36, #20, #30, #42, #53, #44, #00, #FF