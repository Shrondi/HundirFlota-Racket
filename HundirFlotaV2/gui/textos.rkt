#lang s-exp lang/plt-pretty-big

(provide texto-historial-jugador texto-historial-CPU)
(provide texto-estadisticas-jugador texto-estadisticas-CPU)
(provide texto-nombre-fichero)
(provide texto-nombre-tablero)
(provide texto-descripcion-tablero)


(require racket/string)
(require "dialogos.rkt")
(require "paneles.rkt")
(require "../macros.rkt")
(require "mensajes.rkt")
(require "botones.rkt")
(require "ventana.rkt")

  
(define texto-nombre-fichero
  (new text-field%
       [label "Nombre del fichero"]
       [parent dialogo-guardar-tablero]
       [vert-margin 5]
       [horiz-margin 10]
       [min-width 350]	 
       [min-height 20]	 
       [stretchable-width #f]	 
       [stretchable-height #f]
      [callback
        (lambda (t c)
          (send mensaje-informar-archivador set-color "tomato")
          (cond
            ((non-empty-string? (send t get-value))
              (cond
                ((file-exists? (build-path ruta-archivador-tableros (send t get-value)))
                 (send mensaje-informar-archivador set-label "Ya existe un fichero con el mismo nombre")
                 (send t set-field-background (make-object color% "Tomato"))
                 (send boton-guardar-fichero enable #f)
                 )
                (else
                 (send boton-guardar-fichero enable #t)
                 (send t set-field-background  #f)
                 (send mensaje-informar-archivador set-label "")
                 )
                ))
            (else (send mensaje-informar-archivador set-label "El nombre del fichero no puede estar vacío")
                  (send boton-guardar-fichero enable #f)
                  (send t set-field-background (make-object color% "Tomato"))
                  )
            )
              )]
       )
  )


(define texto-nombre-tablero
  (new text-field%
       [label "Nombre del tablero"]
       [parent conjunto-panel-archivador]
       [min-width 350]	 
       [min-height 20]
       [vert-margin 5]
       [horiz-margin 10]
       [stretchable-width #f]	 
       [stretchable-height #f]
       )
  )

(define texto-descripcion-tablero
  (new text-field%
       [label "Descripcion del tablero"]
       [parent conjunto-panel-archivador]
       [style '(multiple vertical-label)]
       [vert-margin 5]
       [horiz-margin 10]
       [min-width 350]	 
       [min-height 200]	 
       [stretchable-width #f]	 
       [stretchable-height #f]
       )
  )

(define texto-estadisticas-jugador
  (new editor-canvas%
       [parent panel-horizontal-disparos-jugador]
       [editor (new text% [tab-stops (list 5)])]
       [enabled #f]
       [style '(deleted no-border no-hscroll no-vscroll no-focus transparent)]
       [min-width 660]
       [min-height 40]
       )
  )

(define texto-estadisticas-CPU
  (new editor-canvas%
       [parent panel-horizontal-disparos-CPU]
       [editor (new text% [tab-stops (list 5 )])]
       [enabled #f]
       [style '(deleted no-border no-hscroll no-vscroll no-focus transparent)]
       [min-width 660]
       [min-height 40]
       )
  )


(define editor-canvas-history%
  (class editor-canvas%
    (define/override (on-event evento)
      ;; No hace nada: Si se recibe algun evento de raton se ignora
      ;; Motivo: Aunque el estilo 'no-focus evita la entrada de teclado pero no la de raton
      ;; y hace que el texto siguiente a escribir se inserte donde se hizo click con el raton
      ;; Extra: El campo [enable #f] de la clase por defecto, evita entradas de teclado y raton pero hace que el scrolling no funcione
      #f
      )
    (super-new)
    )
  )

(define texto-historial-jugador
  (new editor-canvas-history%
       [parent ventana-historial-jugador]
       [editor (new text%)]
       [style '(transparent no-focus no-hscroll auto-vscroll)]
       [min-width 500]	 
       [min-height 300]
       [stretchable-width #f]	 
       [stretchable-height #f]
       )
  )


(define texto-historial-CPU
  (new editor-canvas-history%
       [parent ventana-historial-CPU]
       [editor (new text%)]
       [style '(transparent no-focus no-hscroll auto-vscroll)]
       [min-width 500]	 
       [min-height 300]
       [stretchable-width #f]	 
       [stretchable-height #f]
       )
  )


