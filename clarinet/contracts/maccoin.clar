;; MacCoin (MAC)
;; A simple fungible token implemented in Clarity
;; - Mintable by the contract deployer (contract-owner)
;; - Transferable between principals
;; - Burnable by token holders

;; ----------------------
;; Constants
;; ----------------------
(define-constant TOKEN-NAME "MacCoin")
(define-constant TOKEN-SYMBOL "MAC")
(define-constant TOKEN-DECIMALS u6)

;; ----------------------
;; Storage
;; ----------------------
(define-data-var total-supply uint u0)
(define-map balances { owner: principal } { balance: uint })
(define-data-var owner (optional principal) none)

;; ----------------------
;; Read-only functions
;; ----------------------
(define-read-only (get-name)
  (ok TOKEN-NAME)
)

(define-read-only (get-symbol)
  (ok TOKEN-SYMBOL)
)

(define-read-only (get-decimals)
  (ok TOKEN-DECIMALS)
)

(define-read-only (get-total-supply)
  (ok (var-get total-supply))
)

(define-read-only (get-balance-of (who principal))
  (ok (get balance (default-to { balance: u0 } (map-get? balances { owner: who }))))
)

;; ----------------------
;; Public functions
;; ----------------------
;; Error codes
;; u100 -> not-authorized
;; u101 -> insufficient-balance
;; u102 -> not-contract-owner
;; u103 -> owner-already-set
;; u104 -> owner-not-set

(define-public (transfer (amount uint) (sender principal) (recipient principal))
  (let (
        (from (get balance (default-to { balance: u0 } (map-get? balances { owner: sender }))))
        (to   (get balance (default-to { balance: u0 } (map-get? balances { owner: recipient }))))
       )
    (begin
      (asserts! (is-eq tx-sender sender) (err u100))
      (asserts! (>= from amount) (err u101))
(map-set balances { owner: sender } { balance: (- from amount) })
      (map-set balances { owner: recipient } { balance: (+ to amount) })
      (ok true)
    )
  )
)

(define-public (mint (amount uint) (recipient principal))
  (let (
        (to (get balance (default-to { balance: u0 } (map-get? balances { owner: recipient }))))
        (owner-principal (unwrap! (var-get owner) (err u104)))
       )
    (begin
      (asserts! (is-eq tx-sender owner-principal) (err u102))
      (map-set balances { owner: recipient } { balance: (+ to amount) })
      (var-set total-supply (+ (var-get total-supply) amount))
      (ok true)
    )
  )
)

(define-public (burn (amount uint))
  (let ((bal (get balance (default-to { balance: u0 } (map-get? balances { owner: tx-sender })))))
    (begin
      (asserts! (>= bal amount) (err u101))
      (map-set balances { owner: tx-sender } { balance: (- bal amount) })
      (var-set total-supply (- (var-get total-supply) amount))
      (ok true)
    )
  )
)

(define-public (set-owner (who principal))
  (if (is-none (var-get owner))
      (begin
        (var-set owner (some who))
        (ok true)
      )
      (err u103)
  )
)
