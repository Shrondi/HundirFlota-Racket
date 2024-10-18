#lang s-exp lang/plt-pretty-big

(provide cabe-barco-norte? cabe-barco-sur? cabe-barco-este? cabe-barco-oeste?)
(provide generar-probabilidades!)
(provide añadir-disparo-agua! añadir-disparo-barco!)
(provide mostrar-matriz)
(provide reiniciar-tablero!)
(provide cambiar-numero-barcos!)
(provide reiniciar-plantilla-barcos!)
(provide matriz-ref)
(provide añadir-barco-hundido!)
(provide reducir-tamaño-sub-barco!)
(provide casilla-disparada?)
(provide disparo-sobre-agua?)
(provide disparo-sobre-barco?)
(provide barco-hundido?)
(provide flota-hundida?)
(provide añadir-exclusion-alrededor-barco!)
(provide casilla-excluida?)
(provide buscar-barco)


(require racket/list)

(require "estructuras.rkt")



(define (cabe-barco? matriz-disparos fila columna)
        (if (and (>= fila 0) (< fila 10) (>= columna 0) (< columna 10)
                 (not (casilla-disparada? matriz-disparos fila columna))
                 (not (casilla-excluida? matriz-disparos fila columna))
                 )
            #t
            #f
            )
        )
    
  (define (cabe-barco-este? matriz-disparos fila columna tamaño-barco)
    (if (> (+ tamaño-barco columna) 10) #f
        (do
            (
             (i columna (+ i 1))
             )
          ((or (= i (+ tamaño-barco columna)) (not (cabe-barco? matriz-disparos fila i))) (if (= i (+ tamaño-barco columna)) #t #f))
          )
        )
    )
    
  (define (cabe-barco-oeste? matriz-disparos fila columna tamaño-barco)
    (if (< (- columna tamaño-barco) 0) #f
        (do
            (
             (i columna (- i 1))
             )
          ((or (= i (- columna tamaño-barco)) (not (cabe-barco? matriz-disparos fila i))) (if (= i (- columna tamaño-barco)) #t #f))
          )
        )
    )

  (define (cabe-barco-sur? matriz-disparos fila columna tamaño-barco)

    (if (> (+ tamaño-barco fila) 10) #f
        (do
            (
             (i fila (+ i 1))
             )
          ((or (= i (+ tamaño-barco fila)) (not (cabe-barco? matriz-disparos i columna))) (if (= i (+ tamaño-barco fila)) #t #f))
          )
        )
    )

  (define (cabe-barco-norte? matriz-disparos fila columna tamaño-barco)
    (if (< (- fila tamaño-barco) 0) #f
        (do
            (
             (i fila (- i 1))
             )
          ((or (= i (- fila tamaño-barco)) (not (cabe-barco? matriz-disparos i columna))) (if (= i (- fila tamaño-barco)) #t #f))
          )
        )
    )



(define (añadir-disparo-barco! matriz-disparos fila columna)
  (vector-set! (vector-ref matriz-disparos fila) columna 1)
  )

(define (añadir-exclusion-alrededor-barco! matriz-disparos posicion-proa tamaño-barco orientacion)

  (define fila-proa (car posicion-proa))
  (define columna-proa (cadr posicion-proa))

 
  (if orientacion

      ;; Horizontal
      (do
          (
           (fila (- fila-proa 1) (+ fila 1))
           )
        ((> fila (+ fila-proa 1)))
        (do
            (
             (columna (- columna-proa 1) (+ columna 1))
             )
          ((> columna (+ columna-proa tamaño-barco)))
     

          (if (and (>= fila 0) (< fila 10) (>= columna 0) (< columna 10) (not (casilla-disparada? matriz-disparos fila columna)))
              (vector-set! (vector-ref matriz-disparos fila) columna -2)
              )

          )
        )

      ;; Vertical
      (do
          (
           (columna (- columna-proa 1) (+ columna 1))
           )
        ((> columna (+ columna-proa 1)))
        (do
            (
             (fila (- fila-proa 1) (+ fila 1))
             )
          ((> fila (+ fila-proa tamaño-barco)))
     

          (if (and (>= fila 0) (< fila 10) (>= columna 0) (< columna 10) (not (casilla-disparada? matriz-disparos fila columna)))
              (vector-set! (vector-ref matriz-disparos fila) columna -2)
              )

          )
        )
      )
  )



(define (añadir-disparo-agua! matriz-disparos fila columna)
  (vector-set! (vector-ref matriz-disparos fila) columna -1)
  )


(define (casilla-excluida? matriz-disparos fila columna)
  (if (= (matriz-ref matriz-disparos fila columna) -2) #t #f)
  )




(define (mostrar-matriz matriz)
  (newline)
     (do ((fila 0 (+ fila 1)))
      ((= fila (vector-length matriz)))
    (do ((columna 0 (+ columna 1)))
        ((= columna (vector-length (vector-ref matriz fila))))
      (display (vector-ref (vector-ref matriz fila) columna)) (display " ")) (newline))
    (newline))



(define (reiniciar-tablero! matriz-tablero)
  (do ((fila 0 (+ fila 1)))
    ((= fila 10))
    (do ((columna 0 (+ columna 1)))
      ((= columna 10))
      (vector-set! (vector-ref matriz-tablero fila) columna 0))
    ))



(define (cambiar-numero-barcos! plantilla-barcos nuevo-valor)
  (do
      (
       (i 0 (+ i 1))
       )
    ((= i (vector-length barcos-plantilla)))
    (vector-set! (vector-ref plantilla-barcos i) 2 nuevo-valor)
    )
  )

(define (reiniciar-plantilla-barcos! plantilla-barcos)

  (do ((fila 0 (+ fila 1)))
    ((= fila (vector-length plantilla-barcos)))
    (do ((columna 0 (+ columna 1)))
      ((= columna (vector-length (vector-ref plantilla-barcos fila))))
      (vector-set! (vector-ref plantilla-barcos fila) columna (matriz-ref barcos-plantilla-defecto fila columna)))
    )
  )


(define (matriz-ref flota-barcos fila columna)
  (vector-ref (vector-ref flota-barcos fila) columna)
  )




;; CAMBIAR SIMPLEMENTE A VECTOR-REF
(define (buscar-barco barcos-plantilla id-buscado)
    (do
        (
         (i 0 (+ i 1))
         (barco (vector-ref barcos-plantilla 0) (vector-ref barcos-plantilla i))
         )
      ((= (vector-ref barco 0) id-buscado) barco)
      )
    )


(define (añadir-barco-hundido! barcos-plantilla id-buscado)
  
  (define barco (buscar-barco barcos-plantilla id-buscado))
  (vector-set! barco 5 (- (vector-ref barco 5) 1))
  )


(define (barco-hundido? barcos-plantilla id-barco id-sub-barco)

(define tamaño-sub-barco (list-ref
                          (vector-ref (buscar-barco barcos-plantilla id-barco) 6)
                          id-sub-barco))

  (if (= 0 tamaño-sub-barco) #t #f)
  )

(define (flota-hundida? barcos-plantilla)

  (define (numero-barcos-restantes barcos-plantilla)
    (do
        (
         (i 0 (+ i 1))
         (numero-barcos 0 (+ numero-barcos (matriz-ref barcos-plantilla i 5)))
         )
      ((= i (vector-length barcos-plantilla)) numero-barcos)
      )
    )

  
   (if (= (numero-barcos-restantes barcos-plantilla)  0) #t #f)

  )

(define (reducir-tamaño-sub-barco! barcos-plantilla id-barco id-sub-barco)

  (define barco (buscar-barco barcos-plantilla id-barco))
  
  (define lista-sub-barcos (vector-ref barco 6))

  (vector-set! barco 6
               (list-set lista-sub-barcos id-sub-barco (- (list-ref lista-sub-barcos id-sub-barco) 1)))

  )


(define (casilla-disparada? matriz-disparos fila columna)

  (define casilla (matriz-ref matriz-disparos fila columna))

  (if (or (= casilla -1) (= casilla 1)) #t #f)
  )

(define (disparo-sobre-agua? matriz-disparos fila columna)
  (define casilla (matriz-ref matriz-disparos fila columna))

  (if (= casilla -1) #t #f)

  )

(define (disparo-sobre-barco? matriz-disparos fila columna)
  (define casilla (matriz-ref matriz-disparos fila columna))

  (if (= casilla 1) #t #f)

  )


(define (generar-probabilidades! matriz-probabilidades plantilla-barcos matriz-disparos)


  
  (define (obtener-lista-tamaños plantilla-barcos)

    (do
        (
         (i 0 (+ i 1))
         (lista (list) (append lista (filter (lambda (elemento) (if (not (zero? elemento)) elemento)) (matriz-ref plantilla-barcos i 6))))
         )
      ((= i (vector-length plantilla-barcos)) lista)
      )
    )
  
;;;;;;;;;;;


  
    (define (añadir-probabilidad-este! probabilidades fila columna tamaño-barco)
      
      (do
          (
           (i columna (+ i 1))
           )
        ((= i (+ tamaño-barco columna)))
        (vector-set! (vector-ref probabilidades fila) i (+ (matriz-ref probabilidades fila i) 1))
        )
      )

  (define (añadir-probabilidad-oeste! probabilidades fila columna tamaño-barco)
      
      (do
          (
           (i columna (- i 1))
           )
        ((= i (- columna tamaño-barco)))
        (vector-set! (vector-ref probabilidades fila) i (+ (matriz-ref probabilidades fila i) 1))
        )
      )

  (define (añadir-probabilidad-sur! probabilidades fila columna tamaño-barco)
      
      (do
          (
           (i fila (+ i 1))
           )
        ((= i (+ fila tamaño-barco)))
        (vector-set! (vector-ref probabilidades i) columna (+ (matriz-ref probabilidades i columna) 1))
        )
      )

  (define (añadir-probabilidad-norte! probabilidades fila columna tamaño-barco)
      
      (do
          (
           (i fila (- i 1))
           )
        ((= i (- fila tamaño-barco)))
        (vector-set! (vector-ref probabilidades i) columna (+ (matriz-ref probabilidades i columna) 1))
        )
      )

;;;;;;;;;;;;

  

  (define (probabilidad-por-tamaño! probabilidades matriz-disparos tamaño-barco)
    (do
        (
         (i 0 (+ i 1))
         )
      ((= i (vector-length matriz-disparos)))
      (do
          (
           (j 0 (+ j 1))
           )
        ((= j (vector-length (vector-ref matriz-disparos i))))

        
        (cond
          ((and (not (casilla-disparada? matriz-disparos i j))
                (not (casilla-excluida? matriz-disparos i j))
                )
      
           (if (cabe-barco-este? matriz-disparos i j tamaño-barco) (añadir-probabilidad-este! probabilidades i j tamaño-barco))

           (if (cabe-barco-oeste? matriz-disparos i j tamaño-barco) (añadir-probabilidad-oeste! probabilidades i j tamaño-barco))

           (if (cabe-barco-norte? matriz-disparos i j tamaño-barco) (añadir-probabilidad-norte! probabilidades i j tamaño-barco))

           (if (cabe-barco-sur? matriz-disparos i j tamaño-barco) (añadir-probabilidad-sur! probabilidades i j tamaño-barco))
                   
           ))
        )
      )
    )

  ;; CUERPO FUNCION

  (define lista-tamaños (obtener-lista-tamaños plantilla-barcos))

  (for-each (lambda (tamaño) (if (not (zero? tamaño)) (probabilidad-por-tamaño! matriz-probabilidades matriz-disparos tamaño))) lista-tamaños)
  )