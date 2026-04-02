; nasm -f win64 main.asm -o main.obj
; clang main.obj -o main.exe -L../raylib/lib -lraylib -lopengl32 -lgdi32 -lwinmm
; .\main.exe
; or call everything in one line:
; nasm -f win64 main.asm -o main.obj&&clang main.obj -o main.exe -L../raylib/lib -lraylib -lopengl32 -lgdi32 -lwinmm&&.\main.exe
; nasm -f win64 main.asm -o main.obj&&clang main.obj -o main.exe -L../raylib/lib -lraylib -lopengl32 -lgdi32 -lwinmm -lmsvcrt&&.\main.exe
; nasm -f win64 main.asm -o main.obj&&clang main.obj -o main.exe -L../raylib/lib -lraylibdll -lopengl32 -lgdi32 -lwinmm&&copy ..\raylib\lib\raylib.dll . && .\main.exe

default rel  ; Enables RIP-relative addressing by default (important for 64-bit position-independent code).

; Declares functions from raylib. These will be resolved during linking. 
extern InitWindow
extern SetTargetFPS
extern WindowShouldClose
extern IsKeyDown
extern BeginDrawing
extern ClearBackground
extern DrawText
extern DrawCircleV
extern EndDrawing
extern CloseWindow
extern PollInputEvents

section .data
    SCREEN_WIDTH  dd 800
    SCREEN_HEIGHT dd 450

    half          dd 0.5
    speed         dd 2.0
    radius        dd 50.0

    ; Null-terminated C strings.
    msg db "move the ball_pos with arrow keys",0
    title db "Raylib ASM",0

    ; key codes (raylib)
    KEY_RIGHT equ 262
    KEY_LEFT  equ 263
    KEY_UP    equ 265
    KEY_DOWN  equ 264
    

    RAYWHITE  db 245,245,245, 255 
    DARKGRAY  db  80, 80, 80, 255
    MAROON    db 190, 33, 55, 255

section .bss
    ball_pos resq 1      ; Reserves 8 bytes (64 bits). Vector2 {x, y}

section .text
    global main ; Entry point exported as main.

main:
    sub rsp, 56 ; Allocates stack space. Required for: Windows ABI shadow space (32 bytes) + Stack alignment (16-byte aligned) + scractch space (8 bytes)

    ; InitWindow(int width, int height, const char *title)
    mov ecx, [SCREEN_WIDTH]
    mov edx, [SCREEN_HEIGHT]
    lea r8, [title]
    call InitWindow

    ; SetTargetFPS(60)
    mov ecx, 60
    call SetTargetFPS

    ; ball_pos.x = width * 0.5
    cvtsi2ss xmm0, dword [SCREEN_WIDTH]
    mulss xmm0, [half]
    movss [ball_pos], xmm0

    ; ball_pos.y = height * 0.5
    cvtsi2ss xmm0, dword [SCREEN_HEIGHT]
    mulss xmm0, [half]
    movss [ball_pos+4], xmm0

.loop:
    call WindowShouldClose
    test eax, eax
    jnz .end

    call PollInputEvents    ; explicitly update input state

    ; RIGHT
    mov ecx, KEY_RIGHT
    call IsKeyDown
    test eax, eax
    jz .not_key_right_down
    movss xmm0, [ball_pos]
    addss xmm0, dword [speed]
    movss [ball_pos], xmm0

.not_key_right_down:
    ; LEFT
    mov ecx, KEY_LEFT
    call IsKeyDown
    test eax, eax
    jz .not_key_left_down
    movss xmm0, [ball_pos]
    subss xmm0, dword [speed]
    movss [ball_pos], xmm0

.not_key_left_down:
    ; UP
    mov ecx, KEY_UP
    call IsKeyDown
    test eax, eax
    jz .not_key_up_down
    movss xmm0, [ball_pos+4]
    subss xmm0, dword [speed]
    movss [ball_pos+4], xmm0

.not_key_up_down:
    ; DOWN
    mov ecx, KEY_DOWN
    call IsKeyDown
    test eax, eax
    jz .not_key_down_down
    movss xmm0, [ball_pos+4]
    addss xmm0, dword [speed]
    movss [ball_pos+4], xmm0

.not_key_down_down:
    ; Draw
    call BeginDrawing

    mov eax, dword [RAYWHITE]
    mov ecx, eax
    call ClearBackground

    ; DrawText(msg, 10, 10, 20, color)
    lea rcx, [msg]
    mov edx, 10
    mov r8d, 10
    mov r9d, 20
    mov eax, dword [DARKGRAY]
    mov qword [rsp+32], rax
    call DrawText

    ; DrawCircleV(Vector2 pos, float radius, Color color)
    mov rcx, [ball_pos]
    movss xmm1, [radius]
    mov r8d, dword [MAROON]
    call DrawCircleV

    call EndDrawing
    jmp .loop

.end:
    call CloseWindow
    xor eax, eax
    add rsp, 56 ; Restore stack
    ret ;  return
