#lang s-exp lang/plt-pretty-big

(provide ventana-historial-jugador ventana-historial-CPU)
(provide ventana-principal ventana-desacoplada-jugador ventana-desacoplada-CPU)

(require "funcionesCallback/callbackVentanas.rkt")


(define ventana-principal
  (new principal-frame%
       [label "Hundir la flota"]
       [width 700]
       [height 700]

       ;;[stretchable-width #f]	 
       ;;[stretchable-height #f]
       ))


(define ventana-desacoplada-jugador
  (new player-frame%
       [label "Tablero del jugador"]
       ))

(define ventana-desacoplada-CPU
  (new CPU-frame%
       [label "Tablero del contrincante"]
       ))

(define ventana-historial-jugador
  (new frame%
       [label "Historial disparos jugador"]
       [min-width 500]	 
       [min-height 300]
       [stretchable-width #f]	 
       [stretchable-height #f]
       )
  )

(define ventana-historial-CPU
  (new frame%
       [label "Historial disparos CPU"]
        [min-width 500]	 
       [min-height 300]
       [stretchable-width #f]	 
       [stretchable-height #f]
       )
  )

       
    
   