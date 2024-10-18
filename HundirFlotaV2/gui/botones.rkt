#lang s-exp lang/plt-pretty-big

(provide boton-mostrar-tablero-CPU)
(provide boton-iniciar-partida boton-salir boton-salir-menu boton-ayuda boton-ayuda-menu)
(provide boton-historial-jugador boton-historial-CPU)
(provide boton-anclar/desanclar-jugador boton-anclar/desanclar-CPU)
(provide boton-espera-inicial boton-espera-disparos)
(provide botones-tablero-formado)
(provide boton-flota-aleatoria boton-barco-aleatorio)
(provide boton-limpiar-tablero)
(provide boton-confirmar-tablero)
(provide boton-archivador boton-guardar-tablero boton-guardar-fichero)
(provide boton-aumentar boton-disminuir boton-reiniciar)

(require racket/lazy-require)

(require "ventana.rkt")
(require "dialogos.rkt")
(require "../funcionesColocar.rkt")
(require "../estructuras.rkt")
(require "paneles.rkt")
(require "paneles.rkt")
(lazy-require ["funcionesCallback/callbackBotones.rkt" (callback-boton-iniciar-partida
                                                        callback-boton-salir
                                                        callback-boton-ayuda
                                                        callback-boton-flota-aleatoria
                                                        callback-boton-barco-aleatorio
                                                        callback-boton-limpiar-tablero
                                                        callback-boton-confirmar-tablero
                                                        callback-boton-archivador
                                                        callback-boton-guardar-fichero
                                                        callback-boton-guardar-tablero
                                                        callback-boton-disminuir
                                                        callback-boton-aumentar
                                                        callback-boton-historial-jugador
                                                        callback-boton-historial-CPU
                                                        callback-boton-anclar/desanclar-jugador
                                                        callback-boton-anclar/desanclar-CPU
                                                        callback-boton-espera-inicial
                                                        callback-boton-espera-disparos
                                                        callback-boton-espera-hunt
                                                        callback-boton-espera-target
                                                        callback-boton-nueva-partida
                                                        callback-boton-reiniciar
                                                        callback-boton-mostrar-tablero-CPU)])

(define boton-iniciar-partida
  (new button% [label "Iniciar partida"]
       [parent panel-menu]
       [callback callback-boton-iniciar-partida]
       )
  )

(define boton-ayuda
(new button% [label "Ayuda"]
       [parent panel-encabezado]
       [style '(deleted)]
       [horiz-margin 45]
       [callback callback-boton-ayuda]
       )
  )

(define boton-ayuda-menu
(new button% [label "Ayuda"]
       [parent panel-menu]
       [callback callback-boton-ayuda]
       )
  )


(define boton-salir-menu
  (new button%
       [label "Salir"]
       [parent panel-menu]
       [callback callback-boton-salir]
       )
  )

(define boton-salir
  (new button%
       [label "Salir"]
       [horiz-margin 10]
       [parent dialogo-ganador]
       [callback callback-boton-salir]
       )
  )

(define boton-reiniciar
  (new button%
       [label "Reiniciar"]
       [style '(deleted)]
       [horiz-margin 45]
       [parent panel-encabezado]
       [callback callback-boton-reiniciar]
       )
  )

(define (botones-tablero-formado)
  (cond
    ((flota-colocada? barcos-plantilla)
     (send boton-barco-aleatorio enable #f)
     (send boton-confirmar-tablero enable #t)
     (send boton-guardar-tablero enable #t))
    )
  )

(define boton-flota-aleatoria
  (new button% [label "Generar flota"]
       [parent panel-horizontal-botones-generar]
       [style '(deleted)]
       [callback callback-boton-flota-aleatoria]
       [horiz-margin 5]
       [vert-margin 20]
       )
  )




(define boton-barco-aleatorio
  (new button% [label "Generar barco"]
       [parent panel-horizontal-botones-generar]
       [style '(deleted)]
       [callback callback-boton-barco-aleatorio]
       [horiz-margin 5]
       [vert-margin 20]
       )
  )



(define boton-limpiar-tablero
  (new button% [label "Limpiar tablero"]
       [parent panel-horizontal-pie]
       [style '(deleted)]
       [horiz-margin 20]
       [callback callback-boton-limpiar-tablero]
       )
  )




(define boton-confirmar-tablero
  (new button% [label "Confirmar"]
       [parent panel-horizontal-pie]
       [style '(deleted)]
       [enabled #f]
       [horiz-margin 20]
       [callback callback-boton-confirmar-tablero]
       )
  )


(define boton-archivador
  (new button% [label "Archivador"]
       [parent panel-horizontal-botones-opciones-archivador]
       [style '(deleted)]
       [enabled #t]
       [callback callback-boton-archivador]
       [horiz-margin 5]
       [vert-margin 20]
       )
  )



(define boton-guardar-tablero
  (new button% [label "Guardar tablero"]
       [parent panel-horizontal-botones-opciones-archivador]
       [style '(deleted)]
       [enabled #f]
       [callback callback-boton-guardar-tablero]
       [horiz-margin 5]
       [vert-margin 20]
       )
  )

(define boton-guardar-fichero
  (new button% [label "Guardar"]
       [parent dialogo-guardar-tablero]
       [enabled #f]
       [callback callback-boton-guardar-fichero]
       )
  )


(define boton-disminuir
  (new button%
       [label "Disminuir"]
       [horiz-margin 20]
       [style '(deleted)]
       [parent panel-encabezado]
       [callback callback-boton-disminuir]
       )
  )

(define boton-aumentar
  (new button%
       [label "Aumentar"]
       [horiz-margin 20]
       [style '(deleted)]
       [parent panel-encabezado]
       [callback callback-boton-aumentar]
       )
  )


(define boton-nueva-partida
  (new button%
       [label "Nueva partida"]
       [parent dialogo-ganador]
       [horiz-margin 10]
       [callback callback-boton-nueva-partida]
       )
  )

(define boton-anclar/desanclar-jugador
  (new button%
       ;[label "📌"]
       [label "Desanclar"]
       [style '(deleted)]
       [parent panel-vertical-secundario-jugador]
       [callback callback-boton-anclar/desanclar-jugador]
       )
  )

(define boton-anclar/desanclar-CPU
  (new button%
      ;;; [label "📌"]
       [label "Desanclar"]
       [style '(deleted)]
       [parent panel-vertical-secundario-CPU]
       [callback callback-boton-anclar/desanclar-CPU]
       )
  )

(define boton-historial-jugador
  (new button%
       ;;[label "📋"]
       [label "HD"]
       [style '(deleted)]
       [horiz-margin 10]
       [parent panel-horizontal-disparos-jugador]
       [callback callback-boton-historial-jugador]
       )
  )


(define boton-historial-CPU
  (new button%
       ;;[label "📋"]
       [label "HD"]
       [style '(deleted)]
       [horiz-margin 10]
       [parent panel-horizontal-disparos-CPU]
       [callback callback-boton-historial-CPU]
       )
  )

(define boton-espera-inicial
  (new slider%
       [parent panel-vertical-tiempos-espera]
       [label "Tiempo espera \"Hunt\": "]
       [style '(horizontal)]
       [min-value 0]
       [init-value 1]
       [max-value 10]
       [callback callback-boton-espera-inicial]
       )
)

(define boton-espera-disparos
  (new slider%
       [parent panel-vertical-tiempos-espera]
       [label "Tiempo espera \"Target\": "]
       [style '(horizontal)]
       [min-value 0]
       [init-value 2]
       [max-value 10]
       [callback callback-boton-espera-disparos]
       )
)


(define boton-mostrar-tablero-CPU
  (new button%
       [label "Mostrar tablero \n del contrincante"]
       [horiz-margin 10]
       [parent dialogo-ganador]
       [callback callback-boton-mostrar-tablero-CPU]
       )
  )