#lang s-exp lang/plt-pretty-big

(provide flota-colocada?)
(provide colocar-barco-jugador colocar-barco-CPU)

(require "macros.rkt")
(require "funcionesLogica.rkt")
(require "funcionesDibujar.rkt")


(require racket/vector)


(define (flota-colocada? plantilla-barcos)
  (vector-empty? (vector-filter (lambda (x) (not (= (vector-ref x 2) 0))) plantilla-barcos))
  )


(define (colocar-barco-jugador posicion-x posicion-y sombreado dc dc-estado-flota orientacion flota-barcos-jugador plantilla-barcos)

  (cond
    ((not (flota-colocada? plantilla-barcos))

     (let*
         (
          (barcos (vector-filter (lambda (x) (not (= (vector-ref x 2) 0))) plantilla-barcos))
          (fila (quotient posicion-y cell-height))
          (columna (quotient posicion-x cell-width))
          (numero-barcos (vector-ref (vector-ref barcos 0) 2))
          (tamaño-barco (vector-ref (vector-ref barcos 0) 3))
          (color (vector-ref (vector-ref barcos 0) 4))
          (id (vector-ref (vector-ref barcos 0) 0))
          (posicion-proa (list fila columna))
          )
     
  
       (cond
         ((posicion-valida? fila columna tamaño-barco orientacion flota-barcos-jugador)

          (if orientacion
              ;; Horizontal
              (do
                  (
                   (c columna (+ c 1))
                   )
                ((= c (+ tamaño-barco columna)))
                (vector-set! (vector-ref flota-barcos-jugador fila) c (list id (- numero-barcos 1) posicion-proa tamaño-barco orientacion))
                )

              ;; Vertical
              (do
                  (
                   (f fila (+ f 1))
                   )
                ((= f (+ tamaño-barco fila)))
                (vector-set! (vector-ref flota-barcos-jugador f) columna (list id (- numero-barcos 1) posicion-proa tamaño-barco orientacion))
                )
              )

          (dibujar-barco dc columna fila tamaño-barco orientacion sombreado color)

          (vector-set! (vector-ref barcos 0) 2 (- numero-barcos 1))

          (dibujar-flota-disponible dc-estado-flota plantilla-barcos)
        
          #t)
         (else #f))
       )
     )
    (else #f)
    )
  )  
       




(define (colocar-barco-CPU fila columna orientacion flota-barcos-CPU plantilla-barcos)

  (cond
    ((not (flota-colocada? plantilla-barcos))
     (define barcos (vector-filter (lambda (x) (not (= (vector-ref x 2) 0))) plantilla-barcos))
  
     (define numero-barcos (vector-ref (vector-ref barcos 0) 2))
     (define tamaño-barco (vector-ref (vector-ref barcos 0) 3))
     (define color (vector-ref (vector-ref barcos 0) 4))
     (define id (vector-ref (vector-ref barcos 0) 0))
     (define posicion-proa (list fila columna))
     
  
     (cond
       ((posicion-valida? fila columna tamaño-barco orientacion flota-barcos-CPU)

        (if orientacion
            ;; Horizontal
            (do
                (
                 (c columna (+ c 1))
                 )
              ((= c (+ tamaño-barco columna)))
              (vector-set! (vector-ref flota-barcos-CPU fila) c (list id (- numero-barcos 1) posicion-proa tamaño-barco orientacion))
              )

            ;; Vertical
            (do
                (
                 (f fila (+ f 1))
                 )
              ((= f (+ tamaño-barco fila)))
              (vector-set! (vector-ref flota-barcos-CPU f) columna (list id (- numero-barcos 1) posicion-proa tamaño-barco orientacion))
              )
            )


        (vector-set! (vector-ref barcos 0) 2 (- numero-barcos 1))

        #t)
       (else #f)
       )
     )
    (else #f)
    )
  )



(define (posicion-valida? fila columna tamaño-barco orientacion flota-barcos)

  ;; Funcion auxiliar
  (define (barco? flota-barcos-jugador fila columna)
    (if (and (>= fila 0) (< fila 10) (>= columna 0) (< columna 10))
        (list? (matriz-ref flota-barcos-jugador fila columna))
        #f
        )
    )

  ;; Fncion auxiliar
  (define (cabe-barco? flota-barcos fila columna)
    
    ;; Funcion auxiliar
    (define (barco-contiguo? flota-barcos fila columna)
      (let
          (
           ;;Matriz que contiene las 8 direcciones. La primera columna -> filas, segunda columna -> columnas
           (direcciones (vector 
                         (vector -1 -1)
                         (vector -1 0)
                         (vector -1 1)
                         (vector 0 -1)
                         (vector 0 1)
                         (vector 1 -1)
                         (vector 1 0)
                         (vector 1 1)
                         ))
           )
        (do 
            (
             (i 0 (+ i 1))
             )
          ((or (= i (vector-length direcciones)) (barco? flota-barcos (+ fila (matriz-ref direcciones i 0)) (+ columna (matriz-ref direcciones i 1)))) (if (= i 8) #f #t))
          ;; (Sin cuerpo del bucle)
          )
        )
      )

    #|
    (if (and (>= fila 0) (< fila 10) (>= columna 0) (< columna 10)
             (not (barco? flota-barcos fila columna))
             (not (barco-contiguo? flota-barcos fila columna))
             )
        #t
        #f
        )
    |#

    ;; Cuerpo funcion
    (and (not (barco? flota-barcos fila columna)) (not (barco-contiguo? flota-barcos fila columna)))
    )
  

  ;; Funcion auxiliar
  (define (cabe-barco-este? flota-barcos fila columna tamaño-barco)
    (if (> (+ tamaño-barco columna) 10) #f
        (do
            (
             (i columna (+ i 1))
             )
          ((or (= i (+ tamaño-barco columna)) (not (cabe-barco? flota-barcos fila i))) (if (= i (+ tamaño-barco columna)) #t #f))
          )
        )
    )

  ;; Funcion auxiliar
  (define (cabe-barco-sur? flota-barcos fila columna tamaño-barco)

    (if (> (+ tamaño-barco fila) 10) #f
        (do
            (
             (i fila (+ i 1))
             )
          ((or (= i (+ tamaño-barco fila)) (not (cabe-barco? flota-barcos i columna))) (if (= i (+ tamaño-barco fila)) #t #f))
          )
        )
    )

  ;; CUERPO FUNCION
  (if orientacion
      (cabe-barco-este? flota-barcos fila columna tamaño-barco)
      (cabe-barco-sur? flota-barcos fila columna tamaño-barco)
      )
      
  )