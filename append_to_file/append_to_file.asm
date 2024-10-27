.section .data
buf: .zero 100
buf_len = 100
filename: .asciz "example.txt"
message: .ascii "Append the text you want to add to file\n"
msg_len = . - message

.section .text
.global _start

_start:
	// Print message
	ldr r1, =message
	mov r2, #msg_len
	bl print

	// Open (or create if it doesn't exist) example.txt
	ldr r0, =filename
	mov r1, #0x441		// file flags set to writeonly, create
	mov r2, #0644 		// file permissions
	bl open
	
	// Save file descriptor
	mov r4, r0

	// Check any errors
	cmp r0, #0
	blt error

	ldr r1, =buf
	mov r2, #buf_len
	bl scan

	// Write inside file
	mov r2, r0 		// save the length of last string read from user
	mov r0, r4
	ldr r1, =buf
	bl write
	
	// Close file
	mov r0, r4
	bl close

	// Close process
	mov r0, #0
	bl return

print:
	mov r7, #4
	mov r0, #1
	svc #0
	mov pc, r14

scan:
	mov r7, #3
	mov r0, #2
	svc #0
	mov pc, r14

write:
	mov r7, #4
	svc #0
	mov pc, r14

read:
	mov r7, #3
	svc #0
	mov pc, r14

open:
	mov r7, #5
	svc #0
	mov pc, r14

close:
	mov r7, #6
	svc #0
	mov pc, r14

return:
	mov r7, #1
	svc #0

error:
	// Gestione dell'errore, termina il programma
	mov r0, #1
	mov r7, #1
	svc #0
