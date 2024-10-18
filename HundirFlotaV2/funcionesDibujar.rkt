#lang s-exp lang/plt-pretty-big


(provide dibujar-barco)
(provide dibujar-letras-cuadricula)
(provide dibujar-numeros-cuadricula)
(provide dibujar-cuadricula)
(provide dibujar-disparo-barco)
(provide dibujar-disparo-agua)
(provide dibujar-flota-disponible)
(provide dibujar-flota-barcos)
(provide dibujar-flota-barcos-disparos)
(provide dibujar-archivador-tableros)
(provide dibujar-historial)
(provide dibujar-contador-disparos dibujar-contador-disparos-agua dibujar-contador-disparos-tocado dibujar-contador-disparos-hundido)

(require racket/string)
(require "macros.rkt")
(require "funciones.rkt")
(require "estructuras.rkt")
(require "funcionesLogica.rkt")



(define (dibujar-barco dc columna fila tamaño-barco orientacion sombreado-barco color)

  (define coordenada-origen-columna (* columna cell-width))
  (define coordenada-origen-fila (* fila cell-height))   

  (send dc flush)
  (send dc suspend-flush)

  (if sombreado-barco (dibujar-alrededor-barco dc columna fila tamaño-barco orientacion))

  (send dc set-pen "Black" 0 'solid)
  (send dc set-brush (new brush% [color color]))
  
  (cond
    (orientacion
     ;; Horizontal
   
     (do
         (
          (nuevo-origen-x coordenada-origen-columna (+ nuevo-origen-x cell-width))
          (numero-partes 0 (+ numero-partes 1))
          )
       ((= numero-partes tamaño-barco))
       (send dc draw-rectangle nuevo-origen-x coordenada-origen-fila cell-width cell-height)
   
       ))
    ((not orientacion)
     ;; Vertical
     
     (do
         (
          (nuevo-origen-y coordenada-origen-fila (+ nuevo-origen-y cell-height))
          (numero-partes 0 (+ numero-partes 1))
          )
       ((= numero-partes tamaño-barco))
       (send dc draw-rectangle coordenada-origen-columna nuevo-origen-y cell-width cell-height)
   
       )
     )
    )

  
  
  (send dc resume-flush)

  )


#|(define (dibujar-barco dc columna fila tamaño-barco orientacion? sombreado-barco? color)

  (define coordenada-origen-fila-barco (* columna cell-width))
  (define coordenada-origen-columna-barco (* fila cell-height))
       
     
  (send dc suspend-flush)

  ;;(make-object color% 0 255 0 0.2)
 
  (if sombreado-barco? (dibujar-alrededor-barco dc columna fila tamaño-barco orientacion?))

  (send dc set-pen "Steel Blue" 5 'solid)
  (send dc set-brush (new brush% [color color]))
  
  (cond
    (orientacion?
     ;; Horizontal

     (send dc set-pen "black" 0 'transparent)
  (send dc set-brush (new brush% [color "white"]))
     (send dc draw-rectangle coordenada-origen-fila-barco coordenada-origen-columna-barco (* tamaño-barco cell-width) cell-height)

     (send dc set-pen "Steel Blue" 5 'solid)
  (send dc set-brush (new brush% [color color]))
     (send dc draw-rectangle coordenada-origen-fila-barco coordenada-origen-columna-barco (* tamaño-barco cell-width) cell-height)
   
       )
    ((not orientacion?)
     ;; Vertical
     
     (send dc draw-rectangle coordenada-origen-fila-barco coordenada-origen-columna-barco cell-width (* tamaño-barco cell-height))
     )
    )

  
  
  (send dc resume-flush)
     
  )|#


(define (dibujar-alrededor-barco dc columna fila tamaño-barco orientacion?)
  (send dc set-pen "black" 0 'hilite)
  (send dc set-brush (new brush% [color (make-object color% 220 220 220 0.5)]))

  (define coordenada-origen-fila (* (- fila 1) cell-height))
  (define coordenada-origen-columna (* (- columna 1) cell-width))
  
  (cond
    (orientacion?
     ;; Horizontal
     (send dc draw-rectangle coordenada-origen-columna coordenada-origen-fila (* (+ tamaño-barco 2) cell-width) (* 3 cell-height))
     )
    ((not orientacion?)
     ;; Vertical
    (send dc draw-rectangle coordenada-origen-columna coordenada-origen-fila (* 3 cell-width) (* (+ tamaño-barco 2) cell-height))

     )
    )     
  )



(define (dibujar-letras-cuadricula dc)

  (send dc flush)
  (send dc suspend-flush)
  
  ;; Se establece el origen en la mitad de la primera fila del tablero. Se resta un pequeño offset del tamaño de la fuente usada
  (send dc set-origin 20 (- (/ cell-height 2) (send normal-control-font get-size)))
  (do
      (
       (columna 0 (+ columna 1))
       (i 0 (+ i 1)) 
       )
    ((= columna numero-columnas))
    
    (send dc draw-text (format "~a" (list-ref letras i)) (* columna cell-width) 0 'black)
    )
  
  (send dc resume-flush)
  )



(define (dibujar-numeros-cuadricula dc)

  (send dc flush)
  (send dc suspend-flush)

  ;; Se establece el origen en la mitad de la primera fila del tablero. Se resta un pequeño offset del tamaño de la fuente usada
  (send dc set-origin 20 (- (/ (* 3 cell-height) 2) (send normal-control-font get-size)))
  
  (do
      (
       (fila 0 (+ fila 1))
       )
    ((= fila numero-filas))
    (send dc draw-text (format "~a" (+ fila 1)) 0 (* fila cell-height) 'black)
    
    )
  
  (send dc resume-flush)
  )


(define (dibujar-cuadricula dc)

  (send dc set-pen "black" 0 'solid)
  (send dc set-brush (new brush% [style 'transparent]))

  (send dc flush)
   (send dc suspend-flush)
  
  (do
      (
       (fila 0 (+ fila 1))
       )
    ((= fila numero-filas))
    (do
        (
         (columna 0 (+ columna 1))
         )
      ((= columna numero-columnas))
     
      
      (send dc draw-rectangle (* columna cell-width) (* fila cell-height) cell-width cell-height)

      )
    )

  #|
  (do
      (
       (fila 0 (+ fila 1))
       (y cell-height (* fila cell-height))
       )
    ((= fila (+ numero-filas 2)))
     (send dc draw-line 0 y (* numero-columnas cell-width) y))

  (do
      (
       (columna 0 (+ columna 1))
       (x cell-width (* columna cell-width))
       )
    ((= columna (+ numero-columnas 2)))
     (send dc draw-line x 0 x (* numero-columnas cell-height)))
  |#

  (send dc resume-flush)
  
  )


(define (dibujar-disparo-barco dc fila columna)

  (define coordenada-origen-columna (* columna cell-width))
  (define coordenada-origen-fila (* fila cell-height))
  
  (send dc flush)
  (send dc suspend-flush)

  (send dc set-pen "Red" 4 'solid)
  (send dc set-brush "Black" 'transparent)

  ;; Rectangulo
  (send dc draw-rectangle coordenada-origen-columna coordenada-origen-fila cell-width cell-height)

  ;; Linea diagonal
  (send dc draw-line coordenada-origen-columna coordenada-origen-fila (+ coordenada-origen-columna cell-width) (+ coordenada-origen-fila cell-height))

  ;; Linea diagonal inversa
  (send dc draw-line (+ coordenada-origen-columna cell-width) coordenada-origen-fila coordenada-origen-columna (+ coordenada-origen-fila cell-height))

  
  (send dc resume-flush)
  )


(define (dibujar-disparo-agua dc fila columna)
 
  (define coordenada-origen-columna (* columna cell-width))
  (define coordenada-origen-fila (* fila cell-height))
  (define anchura-circulo 10)
  (define altura-circulo 10)

  (send dc flush)
  (send dc suspend-flush)
  
  (send dc set-pen "Black" 1 'solid)
  (send dc set-brush "Black" 'solid) 

  ;; Se usa la funcion de dibujar ellipse para dibujar el circulo
  ;; Segun la documentacion: Draws an ellipse contained in a rectangle with the given top-left corner and size.
  
  ;; Se resta un pequeño offset a cada coordenada ya que el circulo es dibujado inscrito en un rectangulo de referencia
  (send dc draw-ellipse (- (+ coordenada-origen-columna (/ cell-width 2)) (/ anchura-circulo 2))
                        (- (+ coordenada-origen-fila (/ cell-height 2)) (/ altura-circulo 2)) anchura-circulo altura-circulo)
  
  (send dc resume-flush)
  )


(define (dibujar-flota-disponible dc plantilla-barcos)

  (send dc erase)  

  (send dc flush)
  (send dc suspend-flush)
  (send dc set-origin 30 cell-height)
  (do
      (
       (i 0 (+ i 1))
       (fila 0 (+ fila 3)) ;; El valor inicial de la fila indica que tan abajo empezar a dibujar
       )
    ((= i (vector-length plantilla-barcos)))
    
    (send dc set-font (make-object font% 11 'default))
    (send dc set-text-foreground "Black")
    (send dc draw-text (matriz-ref plantilla-barcos i 1) 5 (* (- fila 1) 20))
    
    (do
        (
         (columna 0 (+ columna 1))
         (tamaño-barco (matriz-ref plantilla-barcos i 3))
         (color (matriz-ref plantilla-barcos i 4))
         (numero-barcos (if (not (boolean? turno-jugador))
                            (matriz-ref plantilla-barcos i 2)
                            (matriz-ref plantilla-barcos i 5))
                        )
           
         )
      ((= columna tamaño-barco)
       
       (cond
         ((and (= numero-barcos 0) (boolean? turno-jugador))
          (send dc set-text-foreground "dark blue")
          (send dc draw-text "¡Hundidos!" (* (+ columna 1) 20) (* fila 20))
          )
         ((= numero-barcos 0)
          (send dc set-text-foreground "dark Green")
          (send dc draw-text "¡Colocados!" (* (+ columna 1) 20) (* fila 20))
          )
         (else  (send dc set-text-foreground "Black")
                (send dc draw-text (string-append "x" (number->string numero-barcos)) (* (+ columna 1) 20) (* fila 20))
                )
         )
       )

      (send dc set-pen "black" 0 'solid)
      (send dc set-brush color 'solid)

         
      (send dc draw-rectangle (* columna 20) (* fila 20) 20 20)
      )
    )

 

  (send dc resume-flush)
  
  )


(define (dibujar-flota-barcos dc flota-barcos)

  (send dc flush)
  (send dc suspend-flush)
  
  (do
      (
       (fila 0 (+ fila 1))
       )
    ((= fila numero-filas))
    (do
        (
         (columna 0 (+ columna 1))
         )
      ((= columna numero-columnas))
      (let
          (
           (valor-casilla (matriz-ref flota-barcos fila columna))
           )
        
        (cond
          ((list? valor-casilla)
           (let
               (
                (color (vector-ref (buscar-barco barcos-plantilla (list-ref valor-casilla 0)) 4))
                )
             (send dc set-pen "Black" 0 'solid)
             (send dc set-brush color 'solid)
             (send dc draw-rectangle (* columna cell-height) (* fila cell-width) cell-width cell-height)
             )
           )
          )
        )
      )
    )

  (send dc resume-flush)
  (dibujar-cuadricula dc)
  )



(define (dibujar-flota-barcos-disparos dc matriz-disparos)

  (do
      (
       (fila 0 (+ fila 1))
       )
    ((= fila numero-filas))
    (do
        (
         (columna 0 (+ columna 1))
         )
      ((= columna numero-columnas))
        
      (cond
        ((disparo-sobre-agua? matriz-disparos fila columna)
         (dibujar-disparo-agua dc fila columna)
         )
        ((disparo-sobre-barco? matriz-disparos fila columna)
         (dibujar-disparo-barco dc fila columna)
         )
        )
           
      )
    )
  )

(define (dibujar-archivador-tableros ruta-directorio-archivador canvas-archivador anchura escala)

  
  (define (recorrer-lista lista nuevo-y nuevo-offset funcion)
    (cond
      ((null? lista) '())
      (else
       
       (funcion lista nuevo-y)
       
       ;; Llamar recursivamente a la función con el resto de la lista
       (recorrer-lista (cdr lista) (+ nuevo-y nuevo-offset) nuevo-offset funcion)
       )
      )
    )

  (define (dibujar-tablero-descripcion lista nuevo-y)
       
    ;; Descripcion del tablero
    (send dc set-font (make-object font% 15 'default 'slant 'normal))
    (send dc draw-text (car lista) (+ anchura-tablero 150) nuevo-y)
      
    )
  
  (define (dibujar-tablero+informacion lista nuevo-y)
    
    ;; Se establece un nuevo origen de dibujado (cada vez mas abajo)
    (send dc set-origin 50 nuevo-y)
       
    (let*
        (
         (tablero+info (fichero->tablero (car lista)))
         (nombre-tablero (car tablero+info))
         ;; Se procesa la descripcion para obtener lineas de mas o menos el mismo tamaño. El numero indica el tamaño de cada linea
         (descripcion-tablero (list-of-lines (cadr tablero+info) 50)) 
         (flota-barcos (caddr tablero+info))
         )
      ;; Dibujar cada tablero y su informacion de la lista

      ;; Decoracion
      (send dc draw-rectangle -50 -50 anchura (+ altura-tablero 150))
         
      ;; Tablero
      (send dc set-pen "black" 0 'solid)
      (send dc set-brush (new brush% [style 'transparent]))
      (dibujar-flota-barcos dc flota-barcos)

      ;; Nombre tablero
      (send dc set-font (make-object font% 25 'default 'normal 'bold))
      (send dc draw-text nombre-tablero (+ anchura-tablero 150) 20)
         
      ;; Descripcion del tablero
      (send dc set-font (make-object font% 22 'default 'slant 'normal))

      ;; IMPORTANTE: Draw-text no reconoce los saltos de linea, por tanto, para descripciones largas el texto se saldra del canvas.
      ;; Solucion: Usar un algoritmo word-wrap para obtener una lista con lineas del mismo tamaño (o casi), para así
      ;; poder iterar sobre la lista e ir dibujando cada linea en una nueva coordenada "y" del canvas (offset)

      ;; Se recorre la lista compuesta por las lineas que conforman la descripcion.
      ;; Se dibuja cada linea cada vez mas abajo
      (recorrer-lista descripcion-tablero 100 25 dibujar-tablero-descripcion) ;; Se dibuja cada linea de la descripcion
         
      )
    )

  
  ;;CUERPO FUNCION

  (define lista-ruta-ficheros (obtener-rutas-ficheros-tableros ruta-directorio-archivador))

  ;; Se crea un bitmap vacio y se guarda                
  (cambiar-bitmap-archivador! (send canvas-archivador make-bitmap anchura
                                    (+ (* (length lista-ruta-ficheros) altura-tablero)
                                       (* (length lista-ruta-ficheros) 10))))

  ;; Se obtiene el dc (context drawing) del bitmap para dibujar sobre él
  (define dc (send bitmap-archivador make-dc))
  
  ;; Se escala el tamaño de todo el dibujo a un menor tamaño
  (send dc set-scale escala escala)

  ;; Se recorre cada fichero del archivador para dibujar el tablero y la informacion en el bitmap
  (recorrer-lista (obtener-rutas-ficheros-tableros ruta-directorio-archivador) 50 (+ altura-tablero 10) dibujar-tablero+informacion)

  
  )


(define (dibujar-historial texto-historial id-barco-hundido plantilla-barcos resultado-disparo fila columna)

  
  (send texto-historial insert (string-append ;;(format "⏱ ~a:~a\t" minutos (if (< segundos 10) (format "0~a" segundos) segundos))
                                              (format "~a:~a\t" minutos (if (< segundos 10) (format "0~a" segundos) segundos))
                                              (format "~a~a -> ¡~a!" (list-ref letras columna) (+ fila 1) resultado-disparo)))
  (cond
    ((eq? id-barco-hundido 'NO)
     (send texto-historial insert "\n\n")
     )
    (else
     (send texto-historial insert (format " -> ~a\n\n" (vector-ref (buscar-barco plantilla-barcos id-barco-hundido) 1)))
     )
    )
     

  )

(define (dibujar-contador-disparos texto-estadisticas)

  (let
      (
       (numeros (regexp-match* #rx"[-0-9]+" (send texto-estadisticas get-text)))
       )
    (if (not (null? numeros))
        (let
            (
             (num-disparos (string->number (car numeros)))
             (pos (send texto-estadisticas find-string texto-disparos 'forward 0 'eof #f))
             )
          (if ( <= num-disparos 9)
              (send texto-estadisticas insert (number->string (+ num-disparos 1)) (+ pos 1) (+ pos 2))
              (send texto-estadisticas insert (number->string (+ num-disparos 1)) (+ pos 1) (+ pos 3))
              )
          ))
    )
  )

(define (dibujar-contador-disparos-agua texto-estadisticas)
  (let
      (
       (numeros (regexp-match* #rx"[-0-9]+" (send texto-estadisticas get-text)))
       )
    (if (not (null? numeros))
        (let
            (
             (num-disparos-agua (string->number (cadr numeros)))
             (pos (send texto-estadisticas find-string texto-disparos-agua 'forward 0 'eof #f))
             )
          (if ( <= num-disparos-agua 9)
              (send texto-estadisticas insert (number->string (+ num-disparos-agua 1)) (+ pos 1) (+ pos 2))
              (send texto-estadisticas insert (number->string (+ num-disparos-agua 1)) (+ pos 1) (+ pos 3))
              )
          ))
    )
  )

(define (dibujar-contador-disparos-tocado texto-estadisticas)
  (let
      (
       (numeros (regexp-match* #rx"[-0-9]+" (send texto-estadisticas get-text)))
       )
    (if (not (null? numeros))
        (let
            (
             (num-disparos-tocado (string->number (caddr numeros)))
             (pos (send texto-estadisticas find-string texto-disparos-tocado 'forward 0 'eof #f))
             )
          (if ( <= num-disparos-tocado 9)
              (send texto-estadisticas insert (number->string (+ num-disparos-tocado 1)) (+ pos 1) (+ pos 2))
              (send texto-estadisticas insert (number->string (+ num-disparos-tocado 1)) (+ pos 1) (+ pos 3))
              )
          ))
    )
  )

(define (dibujar-contador-disparos-hundido texto-estadisticas)
  (let
      (
       (numeros (regexp-match* #rx"[-0-9]+" (send texto-estadisticas get-text)))
       )
    (if (not (null? numeros))
        (let
            (
             (num-disparos-hundido (string->number (cadddr numeros)))
             (pos (send texto-estadisticas find-string texto-disparos-hundido 'forward 0 'eof #f))
             )
          (if ( <= num-disparos-hundido 9)
              (send texto-estadisticas insert (number->string (+ num-disparos-hundido 1)) (+ pos 1) (+ pos 2))
              (send texto-estadisticas insert (number->string (+ num-disparos-hundido 1)) (+ pos 1) (+ pos 3))
              )
          ))
    )
  )


