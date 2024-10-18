#lang s-exp lang/plt-pretty-big




(provide list-of-lines)
(provide cargar-tablero!)
(provide mostrar-ganador)
(provide turno-inicial-jugador?)
(provide tablero->fichero)
(provide fichero->tablero)
(provide obtener-rutas-ficheros-tableros)

(require racket/lazy-require)
(require racket/string)


(require math/base)

(require "funcionesLogica.rkt")
(require "estructuras.rkt")
(lazy-require ["funcionesDibujar.rkt" (dibujar-flota-barcos)])
(lazy-require ["funcionesLimpiar.rkt" (limpiar-canvas-tablero)])
(lazy-require ["funcionesLimpiar.rkt" (limpiar-canvas-estado-flota)])
(lazy-require ["gui/funcionesCallback/callbackBotones.rkt" (callback-habilitar-boton-reiniciar)])
(require "gui/dialogos.rkt")
(require "gui/mensajes.rkt")
(require "gui/temporizadores.rkt")
(require "gui/canvas.rkt")



(define (mostrar-ganador jugador)

  (send temporizador-cronometro stop)
  
  (cond
    ((eq? jugador 'JUGADOR)
     (send mensaje-estado set-label "¡Enhorabuena! \n ¡Has ganado!")
     (send mensaje-dialogo-ganador set-label "¡Enhorabuena! \n ¡Has ganado!")
     )
    (else
     (send mensaje-estado set-label "Lo siento... \n ¡Has perdido!")
     (send mensaje-dialogo-ganador set-label "Lo siento... \n ¡Has perdido!")
     )
    )

  (send tablero-CPU enable #f)
  (send canvas-jugador-auxiliar show #f)
  (send canvas-CPU-auxiliar show #f)
  (callback-habilitar-boton-reiniciar)
  (send dialogo-ganador show #t)
    
  )

#|

|#

(define (turno-inicial-jugador?)

  (if (= (random-integer 0 2) 0) #f #t)
  )



(define (tablero->fichero flota-barcos nombre-tablero descripcion-tablero ruta-fichero)

 (call-with-output-file ruta-fichero
    (lambda (out)
      (write (list (list 'nombre-tablero nombre-tablero) (list 'descripcion-tablero descripcion-tablero) (list 'tablero flota-barcos)) out))
    )
  )

(define (fichero->tablero ruta-fichero)

  (call-with-input-file ruta-fichero
    (lambda (in)
      (let* ((data (read in))
             (nombre (cadr (assoc 'nombre-tablero data)))
             (descripcion (cadr (assoc 'descripcion-tablero data)))
             (tablero (cadr (assoc 'tablero data))))
        (list nombre descripcion tablero))))
  )

(define (obtener-rutas-ficheros-tableros ruta)
    
  (define (user-readable? f)
    (member 'read (file-or-directory-permissions (build-path ruta f))) ;; Se usa build-path para obtener una ruta completa
    )

  (let
      (
       (lista-ficheros  (sort (directory-list ruta) path<?))
       )
    (map (lambda (f) (if (user-readable? f) (build-path ruta f))) lista-ficheros)
    )
  )



(define (cargar-tablero! tablero-leido plantilla-barcos dc dc-estado-flota)
  
  (reiniciar-tablero! flota-barcos-jugador)
  (reiniciar-plantilla-barcos! plantilla-barcos)
  
  (cambiar-numero-barcos! plantilla-barcos 0)
  (cambiar-tablero-jugador! tablero-leido)

  (limpiar-canvas-tablero dc)
  
  (dibujar-flota-barcos dc flota-barcos-jugador)
  
  (limpiar-canvas-estado-flota dc-estado-flota plantilla-barcos)
  )


;; Fuente del algoritmo: https://rosettacode.org/wiki/Word_wrap#Scheme
;; word wrap, using greedy algorithm with minimum lines
(define (simple-word-wrap str width)
  (let loop ((words (string-split str)) ;; En el codigo original string-split era string-tokenize (hacen los mismo)
             (line-length 0)
             (line '())
             (lines '()))
    (cond ((null? words)
           (reverse (cons (reverse line) lines)))
          ((> (+ line-length (string-length (car words)))
              width)
           (if (null? line) 
             (loop (cdr words) ; case where word exceeds line length
                   0
                   '()
                   (cons (list (car words)) lines))
             (loop words ; word must go to next line, so finish current line
                   0
                   '()
                   (cons (reverse line) lines))))
          (else
            (loop (cdr words) ; else, add word to current line
                  (+ 1 line-length (string-length (car words)))
                  (cons (car words) line)
                  lines)))))


;; Variante de la funcion show-para (funcion del link dado)
;; La funcion devuelve una lista donde cada string es una linea del texto
(define (list-of-lines text width)
  (map (lambda (line) (string-join line " "))
            (simple-word-wrap text width)))
