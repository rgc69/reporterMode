(defun reporter-mode () ;#####################################################################
  "Major mode for editing reporter files.
Special commands:
\\{reporter-mode-map}"
  (interactive)
  (reporter--mode-setup))
  
(defun reporter--mode-setup () ;#############################################################
  "Auxiliary function to set up reporter mode."
 (kill-all-local-variables)
  (setq major-mode 'reporter-mode)
  (setq mode-name "Reporter")
  (use-local-map reporter-mode-map)
  )

(defvar reporter-menu-map nil ;################################################################
  "Menu for reporter mode.")

(if reporter-menu-map ;#######################################################################
    nil
  (setq reporter-menu-map (make-sparse-keymap "Reporter"))
(define-key reporter-menu-map [add-cds]
           '("Inserimento, modifica, eliminazione..." . add-cds))
(define-key reporter-menu-map [Associazione2]
             '("Associa una relazione con un altro termine principale" . Associazione2))
(define-key reporter-menu-map [Associazione]
              '("Associa una relazione con il termine principale" . Associazione))
(define-key reporter-menu-map [VisualizzazioneHashTables]
           '("Visualizza tutti i termini principali inseriti" . VisualizzazioneHashTables))
)

(defvar reporter-mode-map nil ;#################################################################
  "Keymap for Reporter mode.")
  
(if reporter-mode-map ;#########################################################################
    nil
  (setq reporter-mode-map (make-keymap))
  (define-key reporter-mode-map [menu-bar reporter]
    (cons "Reporter" reporter-menu-map)))  

;variabili per le funzioni di associazione ;VARIABILI#############################################################
(setq *x* 0)
(setq *y* 0)
 ;variabile  per apertura e chiusura buffer"L"
(setq *z* 0)
 ;variabile per ordinare l'elenco delle Hash Table alfabeticamente 
;(setq *w* 0)
;variabile per inserire le  associazioni nel buffer  "Q" 
(setq *alist*'())
 ;variabile  per il refill-mode
(setq  *r* 0)
;variabile per il termine da associare
(setq termineQ 0)
;variabile per le relazioni nel buffer "Q"
(setq *relaz* "")
(setq relazione1 "")
(setq termineP 0)
;funzione per inserire le relazioni nel buffer principale clikkando sulle relazioni nel buffer "Q"
(defun InserimentoRelazioni() ;#######################################################################
(interactive)
(setq termineP (button-label (button-at(point))))
(set-buffer "*scratch*")
 ;inserisce la stringa nel buffer corrente, anche con eventuali parentesi
             (insert termineP)
			 ;settiamo il punto in cui si trova il cursore
             (setq punto (point))
 ;prendiamo la lunghezza della stringa
             (setq lunghezza (length termineP))
 ;con la lunghezza, possiamo andare all'inizio della stringa 
             (backward-char lunghezza)
 ;settiamo il punto in cui si trova adesso il cursore
             (setq punto2 (point))
			 ;sostituiamo le parentesi aperte che si trovano da questo punto alla fine della stringa
             (subst-char-in-region punto2 punto ?( ? )
 ;adottiamo lo stesso procedimento per le parentesi chiuse
             (backward-char lunghezza)
             (subst-char-in-region punto2 punto ?) ? )
             ;(goto-char punto2);(- punto 1))
			 (set-buffer "*scratch*")
			 (switch-to-buffer-other-window "*scratch*")
			 (end-of-line)
			 (just-one-space))
  

;funzione per inserire i nomi delle relazioni nel buffer principale clikkando sui termini nel buffer "Q"
(defun mini() ;###################################################################################
(interactive)
(setq termineP2 (button-label (button-at(point))))
(setq soggetto0(car(read-from-string (eval termineP2))))
(setq soggetto(eval soggetto0))
(set-buffer "*scratch*")
 ;se l'utente ha "marcato" un termine da associare in seguito... 
(if (numberp (mark 'non-nil))
    (progn
 ;...memorizziamo il punto in cui ci troviamo nel file di testo
       (setq punto0 (point))
 ; andiamo con il cursore al punto in cui si � verificato il mark
       (goto-char (mark-marker))
 ; associamo a relazione-str il termine precedente al punto marcato
       (setq relazione-str (current-word))
 ; ritorniamo al punto in cui eravamo nel testo
       (goto-char punto0)
 ; azzeriamo il contatore di marker
       (set-marker (mark-marker) nil))
 ; se l'utente nn ha effettuato "marcamenti", associamo la parola corrente
    (setq relazione-str (current-word)))
(setq relazione(car(read-from-string relazione-str)))
( progn  (maphash  #'(lambda  (k v)(setq  y(format  "%S" k))
(setq x(format  "%S" v))(if(equal k (car(read-from-string termineP)))(setq relazione1 x)))soggetto))
;(setq relazione1 (gethash relazione soggetto))
(setq relazione-str1(prin1-to-string relazione1))
 ;eliminiamo la stringa "nome"
             (if (equal relazione-str "nome")
                (progn
                   (backward-char 5)              
                   (delete-char 5)))
 ;inserisce la stringa nel buffer corrente, anche con eventuali parentesi
             (insert relazione1)
 ;settiamo il punto in cui si trova il cursore
             (setq punto (point))
 ;prendiamo la lunghezza della stringa
             (setq lunghezza (+(length relazione-str1)(length relazione-str)))
 ;con la lunghezza, possiamo andare all'inizio della stringa 
             (backward-char lunghezza)
 ;settiamo il punto in cui si trova adesso il cursore
             (setq punto2 (point))
	 ;sostituiamo le parentesi aperte che si trovano da questo punto alla fine della stringa
             (subst-char-in-region punto2 punto ?( ? )
 ;adottiamo lo stesso procedimento per le parentesi chiuse
             (backward-char lunghezza)
             (subst-char-in-region punto2 punto ?) ? )
             ;(goto-char punto2);(- punto 1))
			 (set-buffer "*scratch*")
			 (switch-to-buffer-other-window "*scratch*")
			 (end-of-line)
			 (just-one-space)
					)

(defun Associazione() ;#############################################################################
 (interactive)
 (load "~/Documents/emacs/fileEmacs/fonti.el")
 ;se l'utente ha "marcato" un termine da associare in seguito... 
(if (numberp (mark 'non-nil))
    (progn
 ;...memorizziamo il punto in cui ci troviamo nel file di testo
       (setq punto0 (point))
 ; andiamo con il cursore al punto in cui si � verificato il mark
       (goto-char (mark-marker))
 ; associamo a relazione-str il termine precedente al punto marcato
       (setq relazione-str (current-word))
 ; ritorniamo al punto in cui eravamo nel testo
       (goto-char punto0)
 ; azzeriamo il contatore di marker
       (set-marker (mark-marker) nil))
 ; se l'utente nn ha effettuato "marcamenti", associamo la parola corrente
    (setq relazione-str (current-word))) 
 ;prende la parola prima del cursore come una stringa e
 ;la trasforma in un lisp-object
     (let ((relazione(car(read-from-string relazione-str))))
 ;se è la prima volta che utilizzaimo Alt-#
       (if (eq *x* 0)
        (progn
		;se abbiamo clikkato una relazione nel buffer "Q"
		 (if (not (eq termineP 0) )
		   ( progn  (maphash  #'(lambda  (k v)(setq  y(format  "%S" k))
(setq x(format  "%S" v))(if(equal k (car(read-from-string termineP)))(setq relazione1 x)))soggetto)
(setq termineP 0))
		  (progn
		(if (eq termineQ 0) 
		     (setq soggetto0 (read-minibuffer "Inserisci il termine da associare: "))
        (setq soggetto0 (read-minibuffer "Inserisco automaticamente: "(format "%s" termineQ))))
        (setq table soggetto0)
        (setq soggetto(eval soggetto0)))
		
		( progn  (maphash  #'(lambda  (k v)(setq  y(format  "%S" k))
(setq x(format  "%S" v))(if(equal k relazione)(setq relazione1 x)))soggetto))
		)))
	
      (setq soggetto(eval  soggetto0))
	  
	  (if (not (eq termineP 0) )
		   ( progn  (maphash  #'(lambda  (k v)(setq  y(format  "%S" k))
(setq x(format  "%S" v))(if(equal k (car(read-from-string termineP)))(setq relazione1 x)))soggetto)
(setq termineP 0))

  	  ( progn  (maphash  #'(lambda  (k v)(setq  y(format  "%S" k))
(setq x(format  "%S" v))(if(equal k relazione)(setq relazione1 x)))soggetto)))
 ;eliminiamo la stringa "nome"
             (if (equal relazione-str "nome")
                (progn
                   (backward-char 5)              
                   (delete-char 5)))
 ;inserisce la stringa nel buffer corrente, anche con eventuali parentesi
             (insert relazione1)
 ;settiamo il punto in cui si trova il cursore
             (setq punto (point))
 ;prendiamo la lunghezza della stringa
             (setq lunghezza (length relazione1))
 ;con la lunghezza, possiamo andare all'inizio della stringa 
             (backward-char lunghezza)
 ;settiamo il punto in cui si trova adesso il cursore
             (setq punto2 (point))
			 ;sostituiamo le parentesi aperte che si trovano da questo punto alla fine della stringa
             (subst-char-in-region punto2 punto ?( ? )
 ;adottiamo lo stesso procedimento per le parentesi chiuse
             (backward-char lunghezza)
             (subst-char-in-region punto2 punto ?) ? )
             (goto-char (- punto 1))
			 (end-of-line)
			 (just-one-space)
             (setq *x* 1)
			 ))

(global-set-key "\#" 'Associazione) 

(defun Associazione2() ;###########################################################################
 (interactive) 
 (load "~/Documents/emacs/fileEmacs/fonti.el")
(if (numberp (mark 'non-nil))
    (progn
       (setq punto0 (point))
       (goto-char (mark-marker))
       (setq relazione-str (current-word))
       (goto-char punto0)
       (set-marker (mark-marker) nil))
    (setq relazione-str (current-word))) 
     (let ((relazione(car(read-from-string relazione-str))))
(if (eq *x* 1)
        (progn
		 (if (not (eq termineP 0) )
		   ( progn  (maphash  #'(lambda  (k v)(setq  y(format  "%S" k))
(setq x(format  "%S" v))(if(equal k (car(read-from-string termineP)))(setq relazione1 x)))soggetto)
(setq termineP 0))
		  (progn
		(if (eq termineQ 0) 
		     (setq soggetto0 (read-minibuffer "Inserisci il termine da associare: "))
        (setq soggetto0 (read-minibuffer "Inserisco automaticamente: "(format "%s" termineQ))))
        (setq table soggetto0)
        (setq soggetto(eval soggetto0)))

		( progn  (maphash  #'(lambda  (k v)(setq  y(format  "%S" k))
(setq x(format  "%S" v))(if(equal k relazione)(setq relazione1 x)))soggetto))
		)))
	
      (setq soggetto(eval  soggetto0))
	  
	  (if (not (eq termineP 0) )
		   ( progn  (maphash  #'(lambda  (k v)(setq  y(format  "%S" k))
(setq x(format  "%S" v))(if(equal k (car(read-from-string termineP)))(setq relazione1 x)))soggetto)
(setq termineP 0))

  	  ( progn  (maphash  #'(lambda  (k v)(setq  y(format  "%S" k))
(setq x(format  "%S" v))(if(equal k relazione)(setq relazione1 x)))soggetto)))
             (if (equal relazione-str "nome")
                (progn
                   (backward-char 5)              
                   (delete-char 5)))
             (insert relazione1)
 ;settiamo il punto in cui si trova il cursore
             (setq punto (point))
 ;prendiamo la lunghezza della stringa
             (setq lunghezza (length relazione1))
 ;con la lunghezza, possiamo andare all'inizio della stringa 
             (backward-char lunghezza)
 ;settiamo il punto in cui si trova adesso il cursore
             (setq punto2 (point))
			 ;sostituiamo le parentesi aperte che si trovano da questo punto alla fine della stringa
             (subst-char-in-region punto2 punto ?( ? )
 ;adottiamo lo stesso procedimento per le parentesi chiuse
             (backward-char lunghezza)
             (subst-char-in-region punto2 punto ?) ? )
             (goto-char (- punto 1))
			 (end-of-line)
			 (just-one-space)
             ;(VisualizzazioneAssociazioni2)
			  (setq *x* 0)
			 ))

(global-set-key "\M-z" 'Associazione2)


(defun VisualizzazioneHashTables();#######################################################################
"Divide verticalmente lo schermo"
(interactive)
 (if (zerop *z*)
    (progn
       (setq w (selected-window))
	   (setq larghezza ( car(cdr(cdr (window-edges)))))
       (setq divisore (/ (* larghezza 7) 9))
	   (setq  fill-column  (- divisore  10))
       (setq w3 (split-window w divisore t))
       (generate-new-buffer "L")
       (set-window-buffer w3 "L")
	   (if  (zerop  *r*)
        (progn
        (refill-mode)
        (setq *r*  1)))
       (fill-region 1  (point) 'full)
       (set-buffer "L")(setq inhibit-read-only t)
       (goto-char 0)
	   (setq  Alist (sort  Alist #'string-lessp)) 
       (dolist  (lista0  Alist)
       (setq termineL  (format "%S"  lista0))
       (insert  termineL)
       (setq lunghezza  (length termineL))
       (backward-char lunghezza)
       (setq  punto0 (point)) 
       (forward-char  lunghezza)
       (setq punto1  (point))
       (newline)
       (let ((map (make-sparse-keymap)))   
           (define-key map [mouse-1] 'VisualizzazioneAssociazioni)
		   (make-text-button punto0 punto1 'keymap map 'help-echo termineL))
	  ) 
      (setq inhibit-read-only nil)
      (set-buffer "L")(setq buffer-read-only t) 
      (setq cursor-type nil)
	)
 )
 (if (eq *z* 1)
    (progn
       (delete-window w3)
       (kill-buffer "L")
       (setq *z* 0)
       (setq fill-column 70)
       (fill-region 1 (point) 'full)
    )
    (setq *z* 1)
 )
)

(global-set-key "\C-Q" 'VisualizzazioneHashTables)

;per il click sulla lista delle hash-table
(defun VisualizzazioneAssociazioni() ;###############################################################
(interactive)
;termineQ è una stringa presa dalla label del button selezionato
(setq termineQ (button-label (button-at(point))))
;creiamo il buffer Q  se non esiste ancora 
(if (zerop *y*)
(progn
;(setq termineQ (button-label (button-at(point))))
(setq w (other-window 1))
;calcoliamo l'altezza del buffer corrente
(setq altezza(car(cdr(cdr(cdr (window-edges))))))
;dividiamo il buffer in due parti a 2/3 della sua altezza
(setq divisore (/ (* altezza 2) 3))
(setq w2 (split-window w divisore))
(generate-new-buffer "Q")
(set-window-buffer w2 "Q")))
;ora lavoriamo in esso
(set-buffer "Q")(setq inhibit-read-only t)
(goto-char 0)
(setq termine0 (car(read-from-string termineQ)))
(setq table termine0)
(setq soggetto0 termine0)
(setq inhibit-read-only    t)
(setq ter (prin1-to-string termine0))
(let ((regexp (concat    "\\(.*\\)"
                             (eval ter)
                            )))
  (set-buffer   "Q")
(beginning-of-buffer)
 (if(re-search-forward regexp nil t)
(progn
                     (beginning-of-line)
                      (kill-line (+ numero-hash 1 )))))
(insert ter) ;stringa
;(push termine *alist*)
(setq lunghezza1  (length ter))
(backward-char lunghezza1)
(setq  punto2 (point)) 
(forward-char  lunghezza1)
(setq punto3  (point))
;      (newline)
(setq map1 (make-sparse-keymap))
(define-key map1 [mouse-1] 'mini)
(make-text-button punto2 punto3 'keymap map1 'help-echo ter)
(load "~/Documents/emacs/fileEmacs/fonti.el")
  (setq soggetto(eval  termine0))
(setq numero-hash (hash-table-count soggetto))  ;termine
(progn (maphash #'(lambda (k v)(setq y(format "%S" k))(setq x(format "%S" v))
(newline)(insert y " = " x )
(setq lung1  (length y))
(setq lung2  (length x))
(setq lung0  (+ 3 lung1 lung2))
(setq marker (point))
(backward-char lung0)
(setq  punt2 (point)) 
(forward-char  lung1)
(setq punt3  (point))
(setq *relaz* y)
(let ((map3 (make-sparse-keymap)))   
           (define-key map3 [mouse-1] 'InserimentoRelazioni)
(make-text-button punt2 punt3 'keymap map3 'help-echo *relaz*))
(goto-char marker)
)soggetto)   ;termine
(newline)
(newline))
(setq inhibit-read-only nil)
(set-buffer "Q")(setq buffer-read-only t)
(setq cursor-type nil)
;ritorniamo alla finestra principale
(set-buffer "*scratch*")
(setq *y* (+ *y* 1)))

;per gli inserimenti con alt-# e alt-z
(defun VisualizzazioneAssociazioni2() ;################################################################
(interactive)

;creiamo il buffer Q  se non esiste ancora 
(if (zerop *y*)
(progn
;(setq termineQ (button-label (button-at(point))))
(setq w (other-window 1))
;calcoliamo l'altezza del buffer corrente
(setq altezza(car(cdr(cdr(cdr (window-edges))))))
;dividiamo il buffer in due parti a 2/3 della sua altezza
(setq divisore (/ (* altezza 2) 3))
(setq w2 (split-window w divisore))
(generate-new-buffer "Q")
(set-window-buffer w2 "Q")))

;ora lavoriamo in esso
(set-buffer "Q")(setq inhibit-read-only t)
(goto-char 0)
;(setq inhibit-read-only    t)
(setq ter (prin1-to-string *miotermine*))
(let ((regexp (concat    "\\(.*\\)"
                             (eval ter)
                            )))
(set-buffer   "Q")
(beginning-of-buffer)
 (if(re-search-forward regexp nil t)
(progn
                     (beginning-of-line)
                      (kill-line (+ numero-hash 1 )))))
(insert ter) ;stringa
;(push termine *alist*)
(setq lunghezza1  (length ter))
(backward-char lunghezza1)
(setq  punto2 (point)) 
(forward-char  lunghezza1)
(setq punto3  (point))
;      (newline)
(setq map1 (make-sparse-keymap))
(define-key map1 [mouse-1] 'mini)
(make-text-button punto2 punto3 'keymap map1 'help-echo ter)
;(if (not (member termineQ *alist*))
;(progn
(load "~/Documents/emacs/fileEmacs/fonti.el")
(setq soggetto(eval  *miotermine*))
(setq numero-hash (hash-table-count soggetto))  
(progn (maphash #'(lambda (k v)(setq y(format "%S" k))(setq x(format "%S" v))
(newline)(insert y " = " x )
(setq lung1  (length y))
(setq lung2  (length x))
(setq lung0  (+ 3 lung1 lung2))
(setq marker (point))
(backward-char lung0)
(setq  punt2 (point)) 
(forward-char  lung1)
(setq punt3  (point))
(setq *relaz* y)
(let ((map4 (make-sparse-keymap)))   
           (define-key map4 [mouse-1] 'InserimentoRelazioni)
(make-text-button punt2 punt3 'keymap map4 'help-echo *relaz*))
(goto-char marker)
)soggetto) 
;(push termineQ *alist*)
(newline)
(newline))
(setq inhibit-read-only nil)
(set-buffer "Q")(setq buffer-read-only t)
(setq cursor-type nil)
;ritorniamo alla finestra principale
(set-buffer "*scratch*")
(setq *y* (+ *y* 1)))

(defun VisualizzazioneAssociazioni3() ;################################################################
(interactive)

;creiamo il buffer Q  se non esiste ancora 
(if (zerop *y*)
(progn
;(setq termineQ (button-label (button-at(point))))
(setq w (other-window 1))
;calcoliamo l'altezza del buffer corrente
(setq altezza(car(cdr(cdr(cdr (window-edges))))))
;dividiamo il buffer in due parti a 2/3 della sua altezza
(setq divisore (/ (* altezza 2) 3))
(setq w2 (split-window w divisore))
(generate-new-buffer "Q")
(set-window-buffer w2 "Q")))

;ora lavoriamo in esso
(set-buffer "Q")(setq inhibit-read-only t)
(goto-char 0)
;(setq inhibit-read-only    t)
(setq ter (prin1-to-string *miotermine*))
(let ((regexp (concat    "\\(.*\\)"
                             (eval ter)
                            )))
(set-buffer   "Q")
(beginning-of-buffer)
 (if(re-search-forward regexp nil t)
(progn
                     (beginning-of-line)
                      (kill-line (+ numero-hash 1 )))))
(setq inhibit-read-only nil)
(set-buffer "Q")(setq buffer-read-only t)
(setq cursor-type nil)
;ritorniamo alla finestra principale
(set-buffer "*scratch*"))					  

(provide 'reporter)