(setq *termine*  nil)

(setq *miotermine* nil)
(setq *home* (getenv "HOME"))
(defvar modifica-prefix "(puthash '"
  "*Unique string identifying start of modifica.")

(defvar modifica-suffix ")"
  "*String that terminates a modifica.")

(defun elimina-termine() ;########################################################################
(if(yes-or-no-p "Confermi l'eliminazione del termine? Questa operazione comporta la perdita di TUTTE le relazioni associate ad esso")
(progn
(generate-new-buffer "Eliminazioni")
(set-buffer "Eliminazioni")
(setq ter (prin1-to-string *miotermine*))
(insert-file-contents (concat *home* "/Documents/emacs/fileEmacs/fonti.el"))
     (goto-char (point-min))
    (let ((regexp (concat    "\\(.*\\)"
                             (eval ter)
                            )))
 (while (re-search-forward regexp nil t)
                     (beginning-of-line)
                      (kill-line)))
(beginning-of-buffer)
(setq punto1 (point))
(end-of-buffer)
(setq punto2 (point))
(write-region punto1 punto2 (concat *home* "/Documents/emacs/fileEmacs/fonti.el"))
(kill-buffer "Eliminazioni")
(setq Alist (remove *miotermine* Alist))
(generate-new-buffer "Fonti")
(set-buffer "Fonti")
(setq lista1(prin1-to-string Alist))
(insert "(setq Alist '"lista1 ")")
(setq punto1 (point))
(write-region 1 punto1 (concat *home* "/Documents/emacs/fileEmacs/listafonti.el"))
(kill-buffer "Fonti")
;(load "/home/rgc/Documents/emacs/fileEmacs/fonti.el")
(setq numero-hash (hash-table-count (eval *miotermine*)))
( VisualizzazioneAssociazioni3)
(sub1))))

(defun prompt-read-modifica (prompt) ;########################################################
 (read-minibuffer prompt))

(defun modifica-relazioni(relazione nome) ;####################################################
(setq ter (prin1-to-string *miotermine*))
(setq relazione (prin1-to-string relazione))
(setq nome (prin1-to-string nome))
(insert "(puthash '"relazione " '" nome " " ter ")"))

(defun prompt-for-modifica-relazione() ;########################################################
(modifica-relazioni
       (prompt-read-modifica "Nuova relazione?: ")
       (prompt-read-modifica "Nome?: ")))

(defun prompt-for-relazione() ;#################################################################
(crea-relazioni
       (prompt-read "Relazione?: ")
       (prompt-read "Nome?: ")))

(defun crea-relazioni (relazione nome) ;#########################################################
(format "
(puthash '%s '%s %s)"
relazione nome *termine* ))

(defun modificaGenerale() ;######################################################################
(generate-new-buffer "Modifiche")
(set-buffer "Modifiche")
(setq ter (prin1-to-string *miotermine*))
(insert-file-contents (concat *home* "/Documents/emacs/fileEmacs/fonti.el"))
 (goto-char (point-min))
        (let ((regexp (concat "^"
                              (regexp-quote modifica-prefix)
                              (read-from-minibuffer "Inserisci la relazione da modificare: ")
                              "\\(.*\\)"
                              (eval ter)
                              (regexp-quote modifica-suffix)
                              "$")))
      
         (if (re-search-forward regexp nil t)
(progn
 (replace-match "")
 (prompt-for-modifica-relazione)
(beginning-of-buffer)
(setq punto1 (point))
(end-of-buffer)
(setq punto2 (point))
(write-region punto1 punto2 (concat *home* "/Documents/emacs/fileEmacs/fonti.el"))
(kill-buffer "Modifiche")
(setq numero-hash (hash-table-count (eval *miotermine*))) 
(VisualizzazioneAssociazioni2)
(eval(x-popup-dialog t '("Vuoi: " ("Modificare un'altra relazione" . (modificaGenerale))("Inserire una nuova relazione" . (prompt-for-relazione-aggiunta)) ("Eliminare una relazione" . (elimina-relazione)) ("Esci" . (sub1)))))
(sub1)
)
(progn
(kill-buffer "Modifiche")
(eval(x-popup-dialog t '("Il termine inserito non e' presente. Vuoi: " ("Modificare un'altra relazione" . (modificaGenerale))("Inserire una nuova relazione" . (prompt-for-relazione-aggiunta)) ("Eliminare una relazione" . (elimina-relazione)) ("Esci" . (sub1)))))
))))


(defun aggiungialista (l) ;#########################################################################
(append l Alist))

(defun add-record (cd) ;##############################################################################
(generate-new-buffer "Relazioni")
(set-buffer "Relazioni")
(insert cd)
(setq punto (point))
(write-region 1 punto (concat *home* "/Documents/emacs/fileEmacs/fonti.el") 'append)
(load (concat *home* "/Documents/emacs/fileEmacs/fonti.el"))
(kill-buffer "Relazioni"))

(defun crea-termine (termine relazione nome) ;############################################################
(setq Alist (aggiungialista `(,termine)))
(setq *termine* (prin1-to-string termine))
(generate-new-buffer "Fonti")
(set-buffer "Fonti")
(setq lista2(prin1-to-string Alist))
(insert "(setq Alist '" lista2 ")")
(setq punto1 (point))
(write-region 1 punto1 (concat *home* "/Documents/emacs/fileEmacs/listafonti.el"))
(kill-buffer "Fonti")
(format "

(setq %s (make-hash-table))
(puthash '%s '%s %s)" *termine*
relazione nome *termine*)
)

(defun sub1() ;####################################################################################
(throw 'abort2 nil)
)

(defun sub () ;#####################################################################################
(throw 'abort 
(progn
(catch 'abort2)
  (if (not(y-or-n-p "Un altro termine principale?: "))
  (sub1))
   (progn
           (add-record(prompt-for-termine))
		   (dotimes (i 100)
		   (if (not(y-or-n-p "Un'altra relazione?: "))
            (sub)
			(add-record (prompt-for-relazione-aggiunta))))))))

(defun add-cds () ;#################################################################################
(interactive)
     (add-record (prompt-for-termine))
	  (dotimes (i 100)
         (if(y-or-n-p "Un'altra relazione?: ")
          (add-record (prompt-for-relazione-aggiunta))
		   (sub))))

(defun prompt-read (prompt) ;########################################################################
 (read-minibuffer prompt))

(defun prompt-for-termine () ;######################################################################
(setq miotermine (read-minibuffer "Inserisci il termine principale: "))
(setq *miotermine* miotermine)
(if(member miotermine Alist)
(eval(x-popup-dialog t '("Il termine esiste gia. Vuoi: " ("Eliminarlo" . (elimina-termine)) ("Modificare una relazione" . (modificaGenerale)) ("Inserire una nuova relazione" . (prompt-for-relazione-aggiunta)) ("Eliminare una relazione" . (elimina-relazione)) ("Esci" . (sub1)))))
  (crea-termine
   miotermine
   (prompt-read "Relazione?: ")
   (prompt-read "Nome?: "))))


(defun prompt-for-relazione-aggiunta() ;################################################################
(crea-relazioni-aggiunta
       (prompt-read-modifica "Relazione?: ")
       ))

(defun crea-relazioni-aggiunta (relazione) ;#############################################################
(get-buffer-create "Aggiunta")
(set-buffer "Aggiunta")
(setq ter (prin1-to-string *miotermine*))
(setq relazione (prin1-to-string relazione))
(insert-file-contents (concat *home* "/Documents/emacs/fileEmacs/fonti.el"))
     (goto-char (point-min))
(let ((regexp (concat        "^"
                              "(puthash '"
                                (eval relazione)
                              "\\(.*\\)"
                              (eval ter)
                                ")"
                              "$"                            
                                    )))
        (if(re-search-forward regexp nil t)
         (progn
(kill-buffer "Aggiunta")
(eval(x-popup-dialog t '("La relazione esiste gia'. Vuoi: " ("Inserire una nuova relazione" . (prompt-for-relazione-aggiunta)) ("Modificare una relazione" . (modificaGenerale)) ("Eliminare una relazione" . (elimina-relazione)) ("Esci" . (sub1))))))
(progn
(setq nome(prompt-read-modifica "Nome?: "))
(setq nome (prin1-to-string nome))
     (goto-char (point-min))
(let ((regexp (concat 
                              "\\(.*\\)"
                              (eval ter)
                                                      )))
        (re-search-forward regexp nil t)
         (end-of-line)
         (newline))
(insert "(puthash '"  relazione " '" nome " " ter ")")
(beginning-of-buffer)
(setq punto1 (point))
(end-of-buffer)
(setq punto2 (point))
(write-region punto1 punto2 (concat *home* "/Documents/emacs/fileEmacs/fonti.el"))
(if(y-or-n-p "Un'altra relazione?")
(progn
(kill-buffer "Aggiunta")
(prompt-for-relazione-aggiunta))
(progn
(kill-buffer "Aggiunta")
(load (concat *home* "/Documents/emacs/fileEmacs/fonti.el"))
(setq numero-hash (hash-table-count (eval *miotermine*)))
(VisualizzazioneAssociazioni2)
(sub1)))))))

(defun elimina-relazione() ;#########################################################################
(generate-new-buffer "Eliminazioni")
(set-buffer "Eliminazioni")
(setq ter (prin1-to-string *miotermine*))
(setq nome(prin1-to-string (read-minibuffer "Inserisci la relazione da eliminare: ")))
(insert-file-contents (concat *home* "/Documents/emacs/fileEmacs/fonti.el"))
     (goto-char (point-min))
    (let ((regexp (concat "^"
                           "(puthash '"
                             (eval nome) 
                             "\\(.*\\)"
                             (eval ter)
                             ")"
                              "$"
                            )))
  (if(re-search-forward regexp nil t)
  (progn
                     (beginning-of-line)
                      (kill-line)
                      (kill-line)
(beginning-of-buffer)
(setq punto1 (point))
(end-of-buffer)
(setq punto2 (point))
(write-region punto1 punto2(concat *home* "/Documents/emacs/fileEmacs/fonti.el"))
(kill-buffer "Eliminazioni"))
  (if(y-or-n-p "La relazione non esiste. Vuoi eliminare un'altra relazione?")
  (progn
  (kill-buffer "Eliminazioni")
(elimina-relazione)))))
  
(if(y-or-n-p "Vuoi eliminare un'altra relazione?")
(elimina-relazione)
(progn
(load (concat *home* "/Documents/emacs/fileEmacs/fonti.el"))
(setq numero-hash (hash-table-count (eval *miotermine*)))
( VisualizzazioneAssociazioni2)
(sub1))))


(defun exit();#####################################################################################
(format nil))

(global-set-key "\C-w" 'add-cds) 


