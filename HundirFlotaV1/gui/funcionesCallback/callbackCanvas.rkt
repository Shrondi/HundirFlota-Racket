#lang s-exp lang/plt-pretty-big

(provide callback-canvas-archivador
         callback-tablero-jugador
         callback-tablero-CPU
         callback-canvas-auxiliar
         callback-numeros-fila
         callback-letras-columna
         callback-estado-barcos-jugador
         callback-estado-barcos-CPU
         callback-on-event-jugador
         callback-on-event-CPU)

(require "../../macros.rkt")
(require "../../funcionesDibujar.rkt")
(require "../../funcionesColocar.rkt")
(require "../../funcionesDisparar.rkt")
(require "../canvas.rkt")
(require "../botones.rkt")
(require "../../estructuras.rkt")


(define (callback-canvas-archivador c dc)
  ;; Usar un bitmap (imagen) creado es mas eficiente que redibujar
  ;; (En este caso sirve ya que la imagen sera estatica)
  (send dc clear)
  (send dc draw-bitmap bitmap-archivador 0 0)

  )

(define (callback-tablero-jugador c dc)
  (dibujar-flota-barcos dc flota-barcos-jugador)
  (dibujar-flota-barcos-disparos dc disparos-CPU)

  )

(define (callback-tablero-CPU c dc)
  (dibujar-cuadricula dc)
  (if mostrar-tablero-CPU (dibujar-flota-barcos (send tablero-CPU get-dc) flota-barcos-CPU))
  (dibujar-flota-barcos-disparos dc disparos-jugador)
  )

(define (callback-canvas-auxiliar c dc)

  (send dc set-alpha 0.5)
  (send dc set-brush "gainsboro" 'solid)
  (send dc draw-rectangle 0 0 (+ anchura-tablero 25) (+ altura-tablero 25))
 
  )

(define (callback-numeros-fila c dc)
  (dibujar-numeros-cuadricula dc)
  )

(define (callback-letras-columna c dc)
  (dibujar-letras-cuadricula dc)
  )

(define (callback-estado-barcos-jugador c dc)
  (dibujar-flota-disponible dc barcos-plantilla)
  )

(define (callback-estado-barcos-CPU c dc)
  (dibujar-flota-disponible dc barcos-plantilla-CPU)
  )

(define (callback-on-event-jugador evento)
  (let
      (
       (posicion-x (send evento get-x))
       (posicion-y (send evento get-y))
       )
    (cond
      ((equal? (send evento get-event-type) 'left-down)
       (colocar-barco-jugador posicion-x posicion-y #t (send tablero-jugador get-dc) (send estado-barcos-jugador get-dc) #t flota-barcos-jugador barcos-plantilla)) ;; Horizontal
      ((equal? (send evento get-event-type) 'right-down)
       (colocar-barco-jugador posicion-x posicion-y #t (send tablero-jugador get-dc) (send estado-barcos-jugador get-dc) #f flota-barcos-jugador barcos-plantilla)) ;; Vertical
      )

    (botones-tablero-formado)
        
    )

  )

(define (callback-on-event-CPU evento)
  (let
      (
       (posicion-x (send evento get-x))
       (posicion-y (send evento get-y))
       )
    (cond
      ((equal? (send evento get-event-type) 'left-down)
       (disparo-jugador posicion-x posicion-y flota-barcos-CPU barcos-plantilla-CPU disparos-jugador (send tablero-CPU get-dc) (send estado-barcos-CPU get-dc))
                  
       )
      )
    )

  )




