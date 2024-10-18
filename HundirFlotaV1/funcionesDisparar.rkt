#lang s-exp lang/plt-pretty-big

(provide disparo-jugador disparo-CPU)


(require math/base)
(require racket/list)

(require "macros.rkt")
(require "estructuras.rkt")
(require "funcionesLogica.rkt")
(require "funcionesDibujar.rkt")
(require "turno.rkt")
(require "funciones.rkt")
(require "gui/textos.rkt")


(define (disparo-jugador posicion-x posicion-y flota-barcos-contrincante plantilla-barcos-contrincante matriz-disparos-jugador dc-contrincante dc-estado-flota-contrincante)

  (define fila (quotient posicion-y cell-height))
  (define columna (quotient posicion-x cell-width))

  (cond ((not (casilla-disparada? matriz-disparos-jugador fila columna))
         (disparo fila columna flota-barcos-contrincante plantilla-barcos-contrincante matriz-disparos-jugador dc-contrincante dc-estado-flota-contrincante 'JUGADOR (send texto-estadisticas-jugador get-editor) (send texto-historial-jugador get-editor))
         
         )
        )
  )

(define (disparo-CPU dificultad flota-barcos plantilla-barcos matriz-disparos dc dc-estado-flota)

  (cond
    ((= dificultad 0)
     (disparo-CPU-aleatorio flota-barcos plantilla-barcos matriz-disparos dc dc-estado-flota)
     )
    ((= dificultad 1)
     (disparo-CPU-hunt/target flota-barcos plantilla-barcos matriz-disparos dc dc-estado-flota)
     )
    ((= dificultad 2)
     (disparo-CPU-hunt/target-probabilistico flota-barcos plantilla-barcos matriz-disparos dc dc-estado-flota)
     )
    )
  )


(define (disparo-CPU-aleatorio flota-barcos plantilla-barcos matriz-disparos dc dc-estado-flota)

  (sleep/yield espera-inicial)
  
  (do
      (
       (fila-aleatoria (random-integer 0 numero-filas) (random-integer 0 numero-filas))
       (columna-aleatoria (random-integer 0 numero-columnas) (random-integer 0 numero-columnas))
       )
    ;; Condiciones de salida
    ((and (not (casilla-disparada? matriz-disparos fila-aleatoria columna-aleatoria))
          (not (casilla-excluida? matriz-disparos fila-aleatoria columna-aleatoria))
          ;; Problema: llamar a la funcion disparo y guardar el resultado en una variable local dentro del bucle daba resultados anormales
          ;; Solucion: Usar un let dentro de la condicion de salida
          (let
              (
               (resultado (disparo fila-aleatoria columna-aleatoria flota-barcos plantilla-barcos matriz-disparos dc dc-estado-flota 'CPU (send texto-estadisticas-CPU get-editor) (send texto-historial-CPU get-editor)))
               )
                (sleep/yield espera-disparos)
            (or (eq? 'AGUA resultado) (eq? 'END resultado)) ;; Salir del bucle cuando es agua o la partida ya ha finalizado
            ))
     )
    ;; Cuerpo bucle

    )

  )


(define (disparo fila columna flota-barcos plantilla-barcos matriz-disparos dc dc-flota-estado quien-dispara texto-estadisticas texto-historial)

  (define valor-casilla (matriz-ref flota-barcos fila columna))

  (dibujar-contador-disparos texto-estadisticas)

  
  (cond
    ;; DISPARO EN AGUA
    ((not (list? valor-casilla))
     
     (dibujar-contador-disparos-agua texto-estadisticas)
     (dibujar-historial texto-historial 'NO plantilla-barcos 'AGUA fila columna)
     
     (añadir-disparo-agua! matriz-disparos fila columna)
     (dibujar-disparo-agua dc fila columna)
     
     (cambiar-turno quien-dispara)
     'AGUA
     )
    ;; DISPARO EN BARCO
    ((list? valor-casilla)

     (añadir-disparo-barco! matriz-disparos fila columna)
     (dibujar-disparo-barco dc fila columna)

     (reducir-tamaño-sub-barco! plantilla-barcos (car valor-casilla) (cadr valor-casilla))
     
     (dibujar-contador-disparos-tocado texto-estadisticas)
     (dibujar-historial texto-historial 'NO plantilla-barcos 'BARCO fila columna)

     ;;-> COMPROBAR SI EL DISPARO HUNDIO EL BARCO
     (cond
       ;; BARCO HUNDIDO
       ((barco-hundido? plantilla-barcos (car valor-casilla) (cadr valor-casilla))
        
        (añadir-barco-hundido! plantilla-barcos (car valor-casilla))

        (if (eq? quien-dispara 'CPU)
           (añadir-exclusion-alrededor-barco! matriz-disparos (list-ref valor-casilla 2) (list-ref valor-casilla 3) (list-ref valor-casilla 4))
           )

        (dibujar-contador-disparos-hundido texto-estadisticas)
        (dibujar-historial texto-historial (car valor-casilla) plantilla-barcos 'HUNDIDO fila columna)
        
        (dibujar-flota-disponible dc-flota-estado plantilla-barcos)

        (cond
          ((flota-hundida? plantilla-barcos)
           (mostrar-ganador quien-dispara) 'END)
          (else 'HUNDIDO)
          )
        )
        ;; BARCO TOCADO
       (else 'BARCO)
       )
     )
    ) 
  )



(define horientacion-barco-disparado 0)
(define lista-objetivos (list))

(define (disparo-CPU-hunt/target flota-barcos plantilla-barcos matriz-disparos dc dc-estado-flota)


  ;; FUNCION -> MODO HUNT:
  ;; Busqueda aleatoria (dentro de los limites) de una casilla que no haya sido disparada anteriormente
  ;; y que no sea contigua a un barco (se excluyen los barcos colocados juntos)
  ;; Importante: Hasta que un barco no es hundido, no se sabe que casillas son excluidas.
  (define (modo-hunt)
   
    (define (obtener-longitud-barco-menor plantilla-barcos)
      (do
          (
           (i (- (vector-length plantilla-barcos) 1) (- i 1))
           )
        ((or (zero? i) (not (zero? (matriz-ref plantilla-barcos i 5))))  (if (zero? i) #f (matriz-ref plantilla-barcos i 3)))
        )
      )

   
    ;; CUERPO FUNCION MODO-HUNT
    (sleep/yield espera-inicial)

    ;; Se limpia la lista de objetivos y la la horientacion del barco a buscar
    (set! lista-objetivos (list))
    (set! horientacion-barco-disparado 'NADA)
    
    (define longitud-barco-menor (obtener-longitud-barco-menor plantilla-barcos))

    
    ;; Se decide la casilla de disparo y se devuelve (list fila columna)
    (define casilla-disparo-hunt (do
                                     (
                                      (fila-aleatoria (random-integer 0 numero-filas) (random-integer 0 numero-filas))
                                      (columna-aleatoria (random-integer 0 numero-columnas) (random-integer 0 numero-columnas))
                                      )
                                   ((and (not (casilla-disparada? matriz-disparos fila-aleatoria columna-aleatoria))
                                         (not (casilla-excluida? matriz-disparos fila-aleatoria columna-aleatoria))
                                         (zero? (modulo (+ fila-aleatoria columna-aleatoria) longitud-barco-menor))
                                         (or (cabe-barco-norte? matriz-disparos fila-aleatoria columna-aleatoria longitud-barco-menor)
                                             (cabe-barco-sur? matriz-disparos fila-aleatoria columna-aleatoria longitud-barco-menor)
                                             (cabe-barco-este? matriz-disparos fila-aleatoria columna-aleatoria longitud-barco-menor)
                                             (cabe-barco-oeste? matriz-disparos fila-aleatoria columna-aleatoria longitud-barco-menor)
                                             )
                                         )
                                         
                                    ;; Sentencia asociada
                                    (list fila-aleatoria columna-aleatoria))
   
                                   )
      
      )
    (define fila-disparo (car casilla-disparo-hunt)) 
    (define columna-disparo (cadr casilla-disparo-hunt)) 
    

    (displayln "OBJETIVO HUNT:") (display fila-disparo) (display " ,") (displayln columna-disparo)
    
    ;; Se dispara sobre la casilla elegida aleatoriamente 
    (define resultado-disparo (disparo fila-disparo columna-disparo flota-barcos plantilla-barcos matriz-disparos dc dc-estado-flota 'CPU (send texto-estadisticas-CPU get-editor) (send texto-historial-CPU get-editor)))

    (display "LONG MENOR: ") (displayln longitud-barco-menor)
    (display "HUNT RES: ") (displayln resultado-disparo)

    ;; Dependiendo del resultado del disparo se determina el siguiente paso:
    ;; BARCO -> Pasar al modo target
    ;; HUNDIDO -> Volver al modo hunt
    ;; AGUA -> La funcion disparo pasara de turno, y al volver al ser llamada la funcion disparo-CPU-hunt/target
    ;; se volvera al modo hunt ya que la lista de objetivos sigue vacia al no poder haber establecido todavia ninguno.
    (cond
      ((eq? 'BARCO resultado-disparo) (inicializar-modo-target fila-disparo columna-disparo)
                                            (modo-target)
                                            )
      ((eq? 'HUNDIDO resultado-disparo) (modo-hunt))
      )
    )
  ;;;;;;;;;;;;;;

  
  ;; FUNCION -> Cada vez que el modo hunt ha encontrado un objetivo, se crea una lista inicial
  ;; de objetivos (las 4 direcciones de la casilla objetivo). Se filtran las casillas ya disparadas o que sean contiguas a un barco.
  (define (inicializar-modo-target fila-hunt columna-hunt)
    
    ;; Casillas Norte - Sur - Este - Oeste
    (define lista-objetivos-iniciales (list (list (- fila-hunt 1) columna-hunt)
                                            (list (+ fila-hunt 1) columna-hunt)
                                            (list fila-hunt (+ columna-hunt 1))
                                            (list fila-hunt (- columna-hunt 1))
                                            ))
    (set! lista-objetivos (filter
                           (lambda (posicion)
                             (and (>= (car posicion) 0) (< (car posicion) numero-filas) (>= (cadr posicion) 0) (< (cadr posicion) numero-columnas)
                                  (not (casilla-disparada? matriz-disparos (car posicion) (cadr posicion)))
                                  (not (casilla-excluida? matriz-disparos (car posicion) (cadr posicion)))
                                  )
                             )
                           lista-objetivos-iniciales))

    
    )

  ;; FUNCION MODO-TARGET
  ;; Se procesa cada objetivo de la lista de objetivos. Con cada nuevo acierto en un barco, se añade sus 4 direcciones
  ;; evitando repetidos, casillas ya disparadas o excluidas.
  ;;
  ;; Cuando un barco es alcanzado por primera vez, se hace un segundo disparo aleatorio de las 4 casillas cardinales.
  ;; Con ese segundo disparo, se determina la orientacion del barco (hasta ahora desconocida)
  ;;
  ;; Una vez determinada la orientacion del barco, cada nuevo acierto añade a la lista de objetivos
  ;; la siguiente casilla horizontal o vertical dependiendo de la orientacion adivinada.
  ;; Cada vez que un objetivo de la lista es usado, se elimina.
  ;;
  ;; Con cada acierto, la funcion modo-target volvera a ser llamada, procesando el siguiente objetivo de la lista hasta
  ;; que el barco se hunda que se volvera al modo-hunt.
  ;; Si se produce algun disparo en agua durante el modo-target, la funcion disparo internamente pasa de turno, y al volver
  ;; el turno a la CPU, volvera al modo-target ya que la lista de objetivos aún no esta vacía
  (define (modo-target)

     ;; Para comprobar (dentro de los limites del tablero) si un barco ha sido disparado
  (define (barco-disparado? matriz-disparos fila columna)

    (if (and (>= fila 0) (< fila numero-filas) (>= columna 0) (< columna numero-columnas))
        (if (= (matriz-ref matriz-disparos fila columna) 1) #t #f)
        #f
        )
    )

    ;; Añadir las siguientes casillas objetivo dependiendo de la orientacion del barco descubierta
    (define (añadir-casillas-vecinas lista-objetivos fila-objetivo columna-objetivo)

      (define lista-vecinos-horizontales (list (list fila-objetivo (+ columna-objetivo 1))
                                             (list fila-objetivo (- columna-objetivo 1))
                                             ))
      
      (define lista-vecinos-verticales (list (list (+ fila-objetivo 1) columna-objetivo)
                                               (list (- fila-objetivo 1) columna-objetivo)
                                               ))

      (cond
        ((eq? 'HORIZONTAL horientacion-barco-disparado)
         (remove-duplicates (append
                             (filter
                              (lambda (posicion)
                                (and (>= (car posicion) 0) (< (car posicion) numero-filas) (>= (cadr posicion) 0) (< (cadr posicion) numero-columnas)
                                     (not (casilla-disparada? matriz-disparos (car posicion) (cadr posicion)))
                                     (not (casilla-excluida? matriz-disparos (car posicion) (cadr posicion)))
                                     )
                                ) lista-vecinos-horizontales)
                              lista-objetivos))
         )
        ((eq? 'VERTICAL horientacion-barco-disparado)
         (remove-duplicates (append
                             (filter
                              (lambda (posicion)
                                (and (>= (car posicion) 0) (< (car posicion) numero-filas) (>= (cadr posicion) 0) (< (cadr posicion) numero-columnas)
                                     (not (casilla-disparada? matriz-disparos (car posicion) (cadr posicion)))
                                     (not (casilla-excluida? matriz-disparos (car posicion) (cadr posicion)))
                                     )
                                ) lista-vecinos-verticales)
                             lista-objetivos))
         )
        (else (displayln "ERROR"))
        )
      )

    ;; CUERPO FUNCION TARGET
    (sleep/yield espera-disparos)
    (displayln horientacion-barco-disparado)

    ;; Reordenar aleatoriamente la lista de objetivos hasta que se decida la orientacion
    ;; Motivo: Al principio la lista siempre contiene los objetivos N - S - E - O, por tanto,
    ;; los barcos verticales siempre son hundidos instantaneamente si son golpeados lejos de los extremos
    (cond
      ((eq? 'NADA horientacion-barco-disparado)
       (set! lista-objetivos (shuffle lista-objetivos))
       )
      )

    
    
    
    (define fila-objetivo (caar lista-objetivos))
    (define columna-objetivo (cadr (car lista-objetivos)))
    (display "OBJETIVO: ") (display fila-objetivo) (display " ,") (display columna-objetivo) (newline)

    (define resultado-disparo (disparo fila-objetivo columna-objetivo flota-barcos plantilla-barcos matriz-disparos dc dc-estado-flota 'CPU (send texto-estadisticas-CPU get-editor) (send texto-historial-CPU get-editor)))

    (display "TARGET RES: ") (displayln resultado-disparo)

     ;; Se elimina el objetivo procesado independientemente del resultado
    (set! lista-objetivos (cdr lista-objetivos))
    
    ;; Si un objetivo de la lista resulta ser un barco...
    (cond
      ((eq? 'BARCO resultado-disparo)

       ;; Se determina la posicion al segundo disparo sobre una casilla con barco.
       ;; En las sucesivas llamadas, si la orientacion ya ha sido descubierta, esta parte de codigo no se procesa
       (if (eq? 'NADA horientacion-barco-disparado)

           ;; Consecuente
           (cond
             ;; Si el disparo anterior sobre un barco se ha hecho en la misma fila pero en una columna distinta -> BARCO HORIZONTAL
             ((or (barco-disparado? matriz-disparos fila-objetivo (+ columna-objetivo 1))
                  (barco-disparado? matriz-disparos fila-objetivo (- columna-objetivo 1))
                  )

              ;; Se eliminan los objetivos residuales de filas contiguas (no puede haber un barco contiguo)
              (set! lista-objetivos (remove (+ fila-objetivo 1) lista-objetivos (lambda (argumento sublista) (= argumento (car sublista)))))
              (set! lista-objetivos (remove (- fila-objetivo 1) lista-objetivos (lambda (argumento sublista) (= argumento (car sublista)))))

              
              (set! horientacion-barco-disparado 'HORIZONTAL)
              )
             ;; Si el disparo anterior sobre un barco se ha hecho en la misma columna pero en una fila distinta -> BARCO VERTICAL
             ((or (barco-disparado? matriz-disparos (+ fila-objetivo 1) columna-objetivo)
                  (barco-disparado? matriz-disparos (- fila-objetivo 1) columna-objetivo)
                  )

              ;; Se eliminan los objetivos residuales de columnas contiguas (no puede haber un barco contiguo)
              (set! lista-objetivos (remove (+ columna-objetivo 1) lista-objetivos (lambda (argumento sublista) (= argumento (cadr sublista)))))
              (set! lista-objetivos (remove (- columna-objetivo 1) lista-objetivos (lambda (argumento sublista) (= argumento (cadr sublista)))))
              
              (set! horientacion-barco-disparado 'VERTICAL)
              )
             )
           )

       ;; Se añaden las casillas vecinas 
       (set! lista-objetivos
             (añadir-casillas-vecinas lista-objetivos fila-objetivo columna-objetivo))
           
       )
      )

   
   
    (display "SIGUIENTES: ") (displayln lista-objetivos)

    ;; Dependiendo del resultado se volvera a...
    (cond
      ((eq? 'BARCO resultado-disparo) (modo-target))
      ((eq? 'HUNDIDO resultado-disparo) (modo-hunt))
        
      )
    )
  ;;;;;;;;;;;

  ;; CUERPO FUNCION: disparo-CPU-hunt/target
  (display lista-objetivos) (newline)
  (cond
    ((empty? lista-objetivos) (displayln "Modo hunt") (modo-hunt))
    (else (displayln "Modo target") (modo-target))
    )
  )






(define (disparo-CPU-hunt/target-probabilistico flota-barcos plantilla-barcos matriz-disparos dc dc-estado-flota)


  (define (modo-hunt)

    ;; Funcion auxiliar
    (define (max-matriz matriz)

      (define (maximo-vector v)
        (do
            (
             (n  (vector-length v))
             (i  1                     (+ i 1))
             (maximo (list (vector-ref v 0) 0)  (if (< (car maximo) (vector-ref v i))
                                                    (list (vector-ref v i) i)
                                                    maximo))
             )
          ((>= i n) maximo)
          )
        )
  
      (do
          (
           (n       (vector-length matriz))
           (i       1                                    (+ i 1))
           (maximo  (list (maximo-vector (vector-ref matriz 0)) 0)   (if (< (caar maximo) (car (maximo-vector (vector-ref matriz i))))
                                                                         (list (maximo-vector (vector-ref matriz i)) i)
                                                                         maximo)
                    )
           )
        ((>= i n) (flatten maximo)) ;; Se devuelve una lista con los valores: (maximo-valor columna fila)
        )
      )
    
    ;; CUERPO FUNCION MODO-HUNT
    (sleep/yield espera-inicial)

    ;; Se limpia la lista de objetivos y la la horientacion del barco a buscar
    (set! lista-objetivos (list))
    (set! horientacion-barco-disparado 'NADA)

    (reiniciar-tablero! probabilidades)
    (generar-probabilidades! probabilidades barcos-plantilla disparos-CPU)
    
    (define casilla-disparo-hunt (max-matriz probabilidades))
    
    (define fila-disparo (caddr casilla-disparo-hunt)) ;; ANTES  (car casilla-disparo-hunt)
    (define columna-disparo (cadr casilla-disparo-hunt)) ;; ANTES (cadr casilla-disparo-hunt)  

    (displayln "OBJETIVO HUNT:") (display fila-disparo) (display " ,") (displayln columna-disparo)
    
    ;; Se dispara sobre la casilla elegida aleatoriamente 
    (define resultado-disparo (disparo fila-disparo columna-disparo flota-barcos plantilla-barcos matriz-disparos dc dc-estado-flota 'CPU (send texto-estadisticas-CPU get-editor) (send texto-historial-CPU get-editor)))

    (display "HUNT RES: ") (displayln resultado-disparo)

    ;; Dependiendo del resultado del disparo se determina el siguiente paso:
    ;; BARCO -> Pasar al modo target
    ;; HUNDIDO -> Volver al modo hunt
    ;; AGUA -> La funcion disparo pasara de turno, y al volver al ser llamada la funcion disparo-CPU-hunt/target
    ;; se volvera al modo hunt ya que la lista de objetivos sigue vacia al no poder haber establecido todavia ninguno.
    (cond
      ((eq? 'BARCO resultado-disparo) (inicializar-modo-target fila-disparo columna-disparo)
                                      (modo-target)
                                      )
      ((eq? 'HUNDIDO resultado-disparo) (modo-hunt))
      )
    )
  ;;;;;;;;;;;;;;

  
  ;; FUNCION -> Cada vez que el modo hunt ha encontrado un objetivo, se crea una lista inicial
  ;; de objetivos (las 4 direcciones de la casilla objetivo). Se filtran las casillas ya disparadas o que sean contiguas a un barco.
  (define (inicializar-modo-target fila-hunt columna-hunt)
    
    ;; Casillas Norte - Sur - Este - Oeste
    (define lista-objetivos-iniciales (list (list (- fila-hunt 1) columna-hunt)
                                            (list (+ fila-hunt 1) columna-hunt)
                                            (list fila-hunt (+ columna-hunt 1))
                                            (list fila-hunt (- columna-hunt 1))
                                            ))
    (set! lista-objetivos (filter
                           (lambda (posicion)
                             (and (>= (car posicion) 0) (< (car posicion) numero-filas) (>= (cadr posicion) 0) (< (cadr posicion) numero-columnas)
                                  (not (casilla-disparada? matriz-disparos (car posicion) (cadr posicion)))
                                  (not (casilla-excluida? matriz-disparos (car posicion) (cadr posicion)))
                                  )
                             )
                           lista-objetivos-iniciales))

    
    )

  ;; FUNCION MODO-TARGET
  (define (modo-target)

     ;; Para comprobar (dentro de los limites del tablero) si un barco ha sido disparado
  (define (barco-disparado? matriz-disparos fila columna)

    (if (and (>= fila 0) (< fila numero-filas) (>= columna 0) (< columna numero-columnas))
        (if (= (matriz-ref matriz-disparos fila columna) 1) #t #f)
        #f
        )
    )

    ;; Añadir las siguientes casillas objetivo dependiendo de la orientacion del barco descubierta
    (define (añadir-casillas-vecinas lista-objetivos fila-objetivo columna-objetivo)

      (define lista-vecinos-horizontales (list (list fila-objetivo (+ columna-objetivo 1))
                                             (list fila-objetivo (- columna-objetivo 1))
                                             ))
      
      (define lista-vecinos-verticales (list (list (+ fila-objetivo 1) columna-objetivo)
                                               (list (- fila-objetivo 1) columna-objetivo)
                                               ))

      (cond
        ((eq? 'HORIZONTAL horientacion-barco-disparado)
         (remove-duplicates (append
                             (filter
                              (lambda (posicion)
                                (and (>= (car posicion) 0) (< (car posicion) numero-filas) (>= (cadr posicion) 0) (< (cadr posicion) numero-columnas)
                                     (not (casilla-disparada? matriz-disparos (car posicion) (cadr posicion)))
                                     (not (casilla-excluida? matriz-disparos (car posicion) (cadr posicion)))
                                     )
                                ) lista-vecinos-horizontales)
                              lista-objetivos))
         )
        ((eq? 'VERTICAL horientacion-barco-disparado)
         (remove-duplicates (append
                             (filter
                              (lambda (posicion)
                                (and (>= (car posicion) 0) (< (car posicion) numero-filas) (>= (cadr posicion) 0) (< (cadr posicion) numero-columnas)
                                     (not (casilla-disparada? matriz-disparos (car posicion) (cadr posicion)))
                                     (not (casilla-excluida? matriz-disparos (car posicion) (cadr posicion)))
                                     )
                                ) lista-vecinos-verticales)
                             lista-objetivos))
         )
        (else (displayln "ERROR"))
        )
      )

    ;; CUERPO FUNCION TARGET
    (sleep/yield espera-disparos)
    (displayln horientacion-barco-disparado)

    ;; Reordenar aleatoriamente la lista de objetivos hasta que se decida la orientacion
    ;; Motivo: Al principio la lista siempre contiene los objetivos N - S - E - O, por tanto,
    ;; los barcos verticales siempre son hundidos instantaneamente si son golpeados lejos de los extremos
    (cond
      ((eq? 'NADA horientacion-barco-disparado)
       (reiniciar-tablero! probabilidades)
       (generar-probabilidades! probabilidades barcos-plantilla disparos-CPU)
       (set! lista-objetivos (sort lista-objetivos (lambda (elemento sig-elemento) (if (> (matriz-ref probabilidades (car elemento) (cadr elemento))
                                                                                          (matriz-ref probabilidades (car sig-elemento) (cadr sig-elemento))) #t #f))))
       )
      )

    
    
    
    (define fila-objetivo (caar lista-objetivos))
    (define columna-objetivo (cadr (car lista-objetivos)))
    (display "OBJETIVO: ") (display fila-objetivo) (display " ,") (display columna-objetivo) (newline)

    (define resultado-disparo (disparo fila-objetivo columna-objetivo flota-barcos plantilla-barcos matriz-disparos dc dc-estado-flota 'CPU (send texto-estadisticas-CPU get-editor) (send texto-historial-CPU get-editor)))

    (display "TARGET RES: ") (displayln resultado-disparo)

     ;; Se elimina el objetivo procesado independientemente del resultado
    (set! lista-objetivos (cdr lista-objetivos))
    
    ;; Si un objetivo de la lista resulta ser un barco...
    (cond
      ((eq? 'BARCO resultado-disparo)

       ;; Se determina la posicion al segundo disparo sobre una casilla con barco.
       ;; En las sucesivas llamadas, si la orientacion ya ha sido descubierta, esta parte de codigo no se procesa
       (if (eq? 'NADA horientacion-barco-disparado)

           ;; Consecuente
           (cond
             ;; Si el disparo anterior sobre un barco se ha hecho en la misma fila pero en una columna distinta -> BARCO HORIZONTAL
             ((or (barco-disparado? matriz-disparos fila-objetivo (+ columna-objetivo 1))
                  (barco-disparado? matriz-disparos fila-objetivo (- columna-objetivo 1))
                  )

              ;; Se eliminan los objetivos residuales de filas contiguas (no puede haber un barco contiguo)
              (set! lista-objetivos (remove (+ fila-objetivo 1) lista-objetivos (lambda (argumento sublista) (= argumento (car sublista)))))
              (set! lista-objetivos (remove (- fila-objetivo 1) lista-objetivos (lambda (argumento sublista) (= argumento (car sublista)))))

              
              (set! horientacion-barco-disparado 'HORIZONTAL)
              )
             ;; Si el disparo anterior sobre un barco se ha hecho en la misma columna pero en una fila distinta -> BARCO VERTICAL
             ((or (barco-disparado? matriz-disparos (+ fila-objetivo 1) columna-objetivo)
                  (barco-disparado? matriz-disparos (- fila-objetivo 1) columna-objetivo)
                  )

              ;; Se eliminan los objetivos residuales de columnas contiguas (no puede haber un barco contiguo)
              (set! lista-objetivos (remove (+ columna-objetivo 1) lista-objetivos (lambda (argumento sublista) (= argumento (cadr sublista)))))
              (set! lista-objetivos (remove (- columna-objetivo 1) lista-objetivos (lambda (argumento sublista) (= argumento (cadr sublista)))))
              
              (set! horientacion-barco-disparado 'VERTICAL)
              )
             )
           )

       ;; Se añaden las casillas vecinas 
       (set! lista-objetivos
             (añadir-casillas-vecinas lista-objetivos fila-objetivo columna-objetivo))
           
       )
      )

   
   
    (display "SIGUIENTES: ") (displayln lista-objetivos)

    ;; Dependiendo del resultado se volvera a...
    (cond
      ((eq? 'BARCO resultado-disparo) (modo-target))
      ((eq? 'HUNDIDO resultado-disparo) (modo-hunt))
        
      )
    )
  ;;;;;;;;;;;

  ;; CUERPO FUNCION: disparo-CPU-hunt/target
  (display lista-objetivos) (newline)
  (cond
    ((empty? lista-objetivos) (displayln "Modo hunt") (modo-hunt))
    (else (displayln "Modo target") (modo-target))
    )
  )