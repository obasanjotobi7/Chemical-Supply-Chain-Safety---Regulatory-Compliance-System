;; Chemical Registry Contract
;; Manages chemical classification, hazard communication, and safety data

;; Constants
(define-constant CONTRACT-OWNER tx-sender)
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-CHEMICAL-EXISTS (err u101))
(define-constant ERR-CHEMICAL-NOT-FOUND (err u102))
(define-constant ERR-INVALID-INPUT (err u103))
(define-constant ERR-INVALID-HAZARD-CLASS (err u104))

;; Data Variables
(define-data-var next-chemical-id uint u1)

;; Data Maps
(define-map chemicals
  { chemical-id: uint }
  {
    name: (string-ascii 100),
    cas-number: (string-ascii 20),
    molecular-formula: (string-ascii 50),
    hazard-classes: (list 10 uint),
    physical-state: uint,
    flash-point: (optional int),
    boiling-point: (optional int),
    density: (optional uint),
    ph-level: (optional uint),
    storage-temp-min: int,
    storage-temp-max: int,
    incompatible-chemicals: (list 20 uint),
    emergency-procedures: (string-ascii 500),
    registered-by: principal,
    registration-date: uint,
    last-updated: uint,
    is-active: bool
  }
)

(define-map chemical-names
  { name: (string-ascii 100) }
  { chemical-id: uint }
)

(define-map cas-numbers
  { cas-number: (string-ascii 20) }
  { chemical-id: uint }
)

(define-map authorized-registrars
  { registrar: principal }
  { authorized: bool, authorized-date: uint }
)

;; Authorization Functions
(define-public (authorize-registrar (registrar principal))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (ok (map-set authorized-registrars
      { registrar: registrar }
      { authorized: true, authorized-date: block-height }
    ))
  )
)

(define-public (revoke-registrar (registrar principal))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (ok (map-set authorized-registrars
      { registrar: registrar }
      { authorized: false, authorized-date: block-height }
    ))
  )
)

;; Chemical Registration Functions
(define-public (register-chemical
  (name (string-ascii 100))
  (cas-number (string-ascii 20))
  (molecular-formula (string-ascii 50))
  (hazard-classes (list 10 uint))
  (physical-state uint)
  (flash-point (optional int))
  (boiling-point (optional int))
  (density (optional uint))
  (ph-level (optional uint))
  (storage-temp-min int)
  (storage-temp-max int)
  (incompatible-chemicals (list 20 uint))
  (emergency-procedures (string-ascii 500))
)
  (let
    (
      (chemical-id (var-get next-chemical-id))
      (registrar-authorized (default-to false (get authorized (map-get? authorized-registrars { registrar: tx-sender }))))
    )
    (asserts! (or (is-eq tx-sender CONTRACT-OWNER) registrar-authorized) ERR-NOT-AUTHORIZED)
    (asserts! (> (len name) u0) ERR-INVALID-INPUT)
    (asserts! (> (len cas-number) u0) ERR-INVALID-INPUT)
    (asserts! (< storage-temp-min storage-temp-max) ERR-INVALID-INPUT)
    (asserts! (is-none (map-get? chemical-names { name: name })) ERR-CHEMICAL-EXISTS)
    (asserts! (is-none (map-get? cas-numbers { cas-number: cas-number })) ERR-CHEMICAL-EXISTS)
    (asserts! (validate-hazard-classes hazard-classes) ERR-INVALID-HAZARD-CLASS)

    (map-set chemicals
      { chemical-id: chemical-id }
      {
        name: name,
        cas-number: cas-number,
        molecular-formula: molecular-formula,
        hazard-classes: hazard-classes,
        physical-state: physical-state,
        flash-point: flash-point,
        boiling-point: boiling-point,
        density: density,
        ph-level: ph-level,
        storage-temp-min: storage-temp-min,
        storage-temp-max: storage-temp-max,
        incompatible-chemicals: incompatible-chemicals,
        emergency-procedures: emergency-procedures,
        registered-by: tx-sender,
        registration-date: block-height,
        last-updated: block-height,
        is-active: true
      }
    )

    (map-set chemical-names { name: name } { chemical-id: chemical-id })
    (map-set cas-numbers { cas-number: cas-number } { chemical-id: chemical-id })
    (var-set next-chemical-id (+ chemical-id u1))

    (ok chemical-id)
  )
)

(define-public (update-chemical-info
  (chemical-id uint)
  (emergency-procedures (string-ascii 500))
  (storage-temp-min int)
  (storage-temp-max int)
  (incompatible-chemicals (list 20 uint))
)
  (let
    (
      (chemical-data (unwrap! (map-get? chemicals { chemical-id: chemical-id }) ERR-CHEMICAL-NOT-FOUND))
      (registrar-authorized (default-to false (get authorized (map-get? authorized-registrars { registrar: tx-sender }))))
    )
    (asserts! (or (is-eq tx-sender CONTRACT-OWNER) registrar-authorized) ERR-NOT-AUTHORIZED)
    (asserts! (< storage-temp-min storage-temp-max) ERR-INVALID-INPUT)

    (ok (map-set chemicals
      { chemical-id: chemical-id }
      (merge chemical-data {
        emergency-procedures: emergency-procedures,
        storage-temp-min: storage-temp-min,
        storage-temp-max: storage-temp-max,
        incompatible-chemicals: incompatible-chemicals,
        last-updated: block-height
      })
    ))
  )
)

(define-public (deactivate-chemical (chemical-id uint))
  (let
    (
      (chemical-data (unwrap! (map-get? chemicals { chemical-id: chemical-id }) ERR-CHEMICAL-NOT-FOUND))
      (registrar-authorized (default-to false (get authorized (map-get? authorized-registrars { registrar: tx-sender }))))
    )
    (asserts! (or (is-eq tx-sender CONTRACT-OWNER) registrar-authorized) ERR-NOT-AUTHORIZED)

    (ok (map-set chemicals
      { chemical-id: chemical-id }
      (merge chemical-data {
        is-active: false,
        last-updated: block-height
      })
    ))
  )
)

;; Read-only Functions
(define-read-only (get-chemical (chemical-id uint))
  (map-get? chemicals { chemical-id: chemical-id })
)

(define-read-only (get-chemical-by-name (name (string-ascii 100)))
  (match (map-get? chemical-names { name: name })
    chemical-ref (map-get? chemicals { chemical-id: (get chemical-id chemical-ref) })
    none
  )
)

(define-read-only (get-chemical-by-cas (cas-number (string-ascii 20)))
  (match (map-get? cas-numbers { cas-number: cas-number })
    chemical-ref (map-get? chemicals { chemical-id: (get chemical-id chemical-ref) })
    none
  )
)

(define-read-only (is-registrar-authorized (registrar principal))
  (default-to false (get authorized (map-get? authorized-registrars { registrar: registrar })))
)

(define-read-only (get-next-chemical-id)
  (var-get next-chemical-id)
)

(define-read-only (check-chemical-compatibility (chemical-id-1 uint) (chemical-id-2 uint))
  (let
    (
      (chemical-1 (unwrap! (map-get? chemicals { chemical-id: chemical-id-1 }) (err u404)))
      (incompatible-list (get incompatible-chemicals chemical-1))
    )
    (ok (is-none (index-of incompatible-list chemical-id-2)))
  )
)

;; Private Functions
(define-private (validate-hazard-classes (hazard-classes (list 10 uint)))
  (let
    (
      (valid-classes (list u1 u2 u3 u4 u5 u6 u7 u8 u9))
    )
    (fold check-hazard-class hazard-classes true)
  )
)

(define-private (check-hazard-class (hazard-class uint) (acc bool))
  (and acc (<= hazard-class u9) (>= hazard-class u1))
)
