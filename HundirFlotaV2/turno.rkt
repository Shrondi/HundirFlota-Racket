#lang s-exp lang/plt-pretty-big

(provide cambiar-turno)

(require "gui/mensajes.rkt")
(require "gui/canvas.rkt")
(require "gui/botones.rkt")
(require racket/lazy-require)
(lazy-require ["funcionesDisparar.rkt" (disparo-CPU)])
(require "macros.rkt")
(require "estructuras.rkt")

(define (cambiar-turno quien-disparo)
  
  (cond
    ;; Si el disparo sobre agua fue de la CPU -> Cambiar turno a JUGADOR
    ((eq? quien-disparo 'CPU)
     (send boton-reiniciar enable #t)
     ;;(send panel-tablero-CPU delete-child canvas-CPU-auxiliar)
     ;;(send panel-tablero-jugador add-child canvas-jugador-auxiliar)
     (send canvas-CPU-auxiliar show #f)
     (send canvas-jugador-auxiliar show #t)
     (send mensaje-estado set-label (string-append "Tu turno" "\n" "¡Dispara!"))
     )

    ;; Si el disparo sobre agua fue del JUGADOR -> Cambiar turno a CPU
    ((eq? quien-disparo 'JUGADOR)
     (send boton-reiniciar enable #f)
     ;;(send panel-tablero-CPU add-child canvas-CPU-auxiliar)
     ;;(send panel-tablero-jugador delete-child canvas-jugador-auxiliar)
     (send canvas-CPU-auxiliar show #t)
     (send canvas-jugador-auxiliar show #f)
     (send mensaje-estado set-label (string-append "Turno del contrincante" "\n" "¡Espere!"))
     (disparo-CPU dificultad-CPU flota-barcos-jugador barcos-plantilla disparos-CPU (send tablero-jugador get-dc) (send estado-barcos-jugador get-dc))
     )
    )
      
  )


