#lang s-exp lang/plt-pretty-big

(provide callback-elecciones-tableros
         callback-elecciones-dificultad-CPU)


(require "../../funciones.rkt")
(require "../../funcionesLimpiar.rkt")
(require "../../macros.rkt")
(require "../../estructuras.rkt")
(require "../canvas.rkt")
(require "../botones.rkt")
(require "../paneles.rkt")


(define (callback-elecciones-tableros c e)

  (let*
      (
       (lista-ficheros (obtener-rutas-ficheros-tableros ruta-archivador-tableros))
       (eleccion (- (send c get-selection) 1))
       (numero-tableros (length lista-ficheros))
       )
    (cond
      ((negative-integer? eleccion) (limpiar-tablero (send tablero-jugador get-dc) (send estado-barcos-jugador get-dc) flota-barcos-jugador barcos-plantilla))
      ((and (>= eleccion 0) (< eleccion numero-tableros))
       (let*
           (
            (ruta-fichero (list-ref lista-ficheros eleccion))
            (tablero-leido (caddr (fichero->tablero ruta-fichero)))
            )
         (cargar-tablero! tablero-leido barcos-plantilla (send tablero-jugador get-dc) (send estado-barcos-jugador get-dc))
         (botones-tablero-formado)
         )
       )
      )
    )
  )

(define (callback-elecciones-dificultad-CPU r e)
  
  (let
      (
       (seleccion (send r get-selection))
       )
    
    (cambiar-dificultad-CPU! seleccion)

    (cond
      ((= seleccion 0)
       (send boton-espera-inicial set-label "Tiempo espera inicial: ")
       (send boton-espera-disparos set-label "Tiempo espera disparos: ")
       )
      ((or (= seleccion 1) (= seleccion 2))
       (send boton-espera-inicial set-label "Tiempo espera \"Hunt\": ")
       (send boton-espera-disparos set-label "Tiempo espera \"Target\": ")
       )))
  )


    