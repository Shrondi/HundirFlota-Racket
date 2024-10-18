#lang s-exp lang/plt-pretty-big

(provide callback-temporizador-cuenta-atras
         callback-temporizador-cronometro)


(require "../../funcionesDisparar.rkt")
(require "../../estructuras.rkt")
(require "../../macros.rkt")
(require "../mensajes.rkt")
(require "../temporizadores.rkt")
(require "../paneles.rkt")
(require "../canvas.rkt")
(require "../botones.rkt")


(define (callback-temporizador-cuenta-atras)
  
  (valor-cuenta-atras! (- valor-cuenta-atras 1))
          
  (if turno-jugador
      (send mensaje-estado set-label (string-append "Va a comenzar la partida..." "\n" "¡Empiezas tú!" "\n" "\t" "\t" (number->string valor-cuenta-atras)))
      (send mensaje-estado set-label (string-append "Va a comenzar la partida..." "\n" "¡Empieza el contrincante!" "\n\t\t" (number->string valor-cuenta-atras)))
      )
          
  (cond
    ((< valor-cuenta-atras 0)
     (send temporizador-cuenta-atras stop)
     (send panel-estado add-child mensaje-cronometro)
     (send temporizador-cronometro start 1000)
     (cond
       (turno-jugador
                      (send boton-reiniciar enable #t)
                      (send canvas-CPU-auxiliar show #f)
                      (send canvas-jugador-auxiliar show #t)
                      (send mensaje-estado set-label (string-append "Tu turno" "\n" "¡Dispara!")))
       (else
        (send boton-reiniciar enable #f)
        (send mensaje-estado set-label (string-append "Turno del contrincante" "\n" "¡Espere!"))
        (disparo-CPU dificultad-CPU flota-barcos-jugador barcos-plantilla disparos-CPU (send tablero-jugador get-dc) (send estado-barcos-jugador get-dc)))
       )
     )
    )

  )

(define (callback-temporizador-cronometro)

  (valor-segundos! (+ segundos 1))
  (when (= segundos 60)
    (valor-segundos! 0)
    (valor-minutos! (+ minutos 1)))
  (send mensaje-cronometro set-label
        (format "⏱ ~a:~a" minutos (if (< segundos 10) (format "0~a" segundos) segundos))
        )

  )



