.section .data
filename: .asciz "example.txt"
message:  .asciz "Hello, ARM World!\n"
msg_len = . - message

.section .text
.global _start

_start:
    // Apri il file in modalità append (O_WRONLY | O_APPEND), crealo se non esiste (O_CREAT)
    ldr r0, =filename       // Carica il nome del file in r0
    mov r1, #(1 | 1024 | 64) // O_WRONLY | O_APPEND | O_CREAT
    mov r2, #0644           // Permessi (usati solo con O_CREAT)

    // Numero della syscall open() è 5
    mov r7, #5              
    svc #0                  // Chiamata alla syscall

    // Salva il file descriptor
    mov r4, r0

    // Controlla l'errore
    cmp r0, #0
    blt error               // Se r0 < 0, c'è stato un errore

    // Scrivi il messaggio nel file
    mov r0, r4              // File descriptor
    ldr r1, =message        // Puntatore al messaggio
    mov r2, #msg_len        // Lunghezza del messaggio

    // Numero della syscall write() è 4
    mov r7, #4
    svc #0                  // Chiamata alla syscall

    // Chiudi il file
    mov r0, r4              // File descriptor
    mov r7, #6              // Numero della syscall close() è 6
    svc #0                  // Chiamata alla syscall

    // Terminare il programma
    mov r0, #0
    mov r7, #1              // Numero della syscall exit() è 1
    svc #0                  // Chiamata alla syscall

error:
    // Gestione dell'errore, termina il programma
    mov r0, #-1
    mov r7, #1
    svc #0
