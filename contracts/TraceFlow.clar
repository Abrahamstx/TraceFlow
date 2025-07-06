;; TraceFlow - Supply Chain Transparency Smart Contract
;; A decentralized system for tracking product authenticity and supply chain provenance

;; Error codes
(define-constant ERR-OWNER-ONLY (err u100))
(define-constant ERR-NOT-FOUND (err u101))
(define-constant ERR-ALREADY-EXISTS (err u102))
(define-constant ERR-UNAUTHORIZED (err u103))
(define-constant ERR-INVALID-STAGE (err u104))
(define-constant ERR-INVALID-INPUT (err u105))

;; Contract owner
(define-constant CONTRACT-OWNER tx-sender)

;; Data structures
(define-map products
  { product-id: uint }
  {
    manufacturer: principal,
    product-name: (string-ascii 100),
    batch-number: (string-ascii 50),
    manufacture-date: uint,
    created-at: uint,
    is-active: bool
  }
)

(define-map supply-chain-stages
  { product-id: uint, stage-id: uint }
  {
    stage-name: (string-ascii 50),
    handler: principal,
    location: (string-ascii 100),
    timestamp: uint,
    stage-data: (string-ascii 200),
    verified: bool
  }
)

(define-map authorized-handlers
  { handler: principal }
  {
    company-name: (string-ascii 100),
    role: (string-ascii 50),
    authorized-by: principal,
    is-active: bool
  }
)

(define-map product-stage-count
  { product-id: uint }
  { count: uint }
)

;; Data variables
(define-data-var next-product-id uint u1)

;; Public functions

;; Register a new product
(define-public (register-product (product-name (string-ascii 100)) (batch-number (string-ascii 50)))
  (let ((product-id (var-get next-product-id)))
    (asserts! (> (len product-name) u0) ERR-INVALID-INPUT)
    (asserts! (> (len batch-number) u0) ERR-INVALID-INPUT)
    (asserts! (is-none (map-get? products { product-id: product-id })) ERR-ALREADY-EXISTS)
    
    (map-set products
      { product-id: product-id }
      {
        manufacturer: tx-sender,
        product-name: product-name,
        batch-number: batch-number,
        manufacture-date: stacks-block-height,
        created-at: stacks-block-height,
        is-active: true
      }
    )
    
    (map-set product-stage-count
      { product-id: product-id }
      { count: u0 }
    )
    
    (var-set next-product-id (+ product-id u1))
    (ok product-id)
  )
)

;; Authorize a supply chain handler
(define-public (authorize-handler (handler principal) (company-name (string-ascii 100)) (role (string-ascii 50)))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-OWNER-ONLY)
    (asserts! (not (is-eq handler tx-sender)) ERR-INVALID-INPUT)
    (asserts! (not (is-eq handler CONTRACT-OWNER)) ERR-INVALID-INPUT)
    (asserts! (> (len company-name) u0) ERR-INVALID-INPUT)
    (asserts! (> (len role) u0) ERR-INVALID-INPUT)
    (asserts! (is-none (map-get? authorized-handlers { handler: handler })) ERR-ALREADY-EXISTS)
    
    (map-set authorized-handlers
      { handler: handler }
      {
        company-name: company-name,
        role: role,
        authorized-by: tx-sender,
        is-active: true
      }
    )
    (ok true)
  )
)

;; Add a supply chain stage
(define-public (add-supply-chain-stage 
  (product-id uint) 
  (stage-name (string-ascii 50)) 
  (location (string-ascii 100)) 
  (stage-data (string-ascii 200)))
  (let 
    (
      (product (unwrap! (map-get? products { product-id: product-id }) ERR-NOT-FOUND))
      (handler-info (map-get? authorized-handlers { handler: tx-sender }))
      (current-count (default-to { count: u0 } (map-get? product-stage-count { product-id: product-id })))
      (new-stage-id (+ (get count current-count) u1))
    )
    
    (asserts! (> product-id u0) ERR-INVALID-INPUT)
    (asserts! (< product-id u1000000) ERR-INVALID-INPUT)
    (asserts! (get is-active product) ERR-INVALID-STAGE)
    (asserts! (> (len stage-name) u0) ERR-INVALID-INPUT)
    (asserts! (> (len location) u0) ERR-INVALID-INPUT)
    (asserts! (<= (len stage-data) u200) ERR-INVALID-INPUT)
    (asserts! 
      (or 
        (is-eq tx-sender (get manufacturer product))
        (and 
          (is-some handler-info)
          (get is-active (unwrap-panic handler-info))
        )
      ) 
      ERR-UNAUTHORIZED
    )
    
    (map-set supply-chain-stages
      { product-id: product-id, stage-id: new-stage-id }
      {
        stage-name: stage-name,
        handler: tx-sender,
        location: location,
        timestamp: stacks-block-height,
        stage-data: stage-data,
        verified: false
      }
    )
    
    (map-set product-stage-count
      { product-id: product-id }
      { count: new-stage-id }
    )
    
    (ok new-stage-id)
  )
)

;; Verify a supply chain stage
(define-public (verify-stage (product-id uint) (stage-id uint))
  (let ((stage (unwrap! (map-get? supply-chain-stages { product-id: product-id, stage-id: stage-id }) ERR-NOT-FOUND)))
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-OWNER-ONLY)
    (asserts! (> product-id u0) ERR-INVALID-INPUT)
    (asserts! (< product-id u1000000) ERR-INVALID-INPUT)
    (asserts! (> stage-id u0) ERR-INVALID-INPUT)
    (asserts! (< stage-id u1000) ERR-INVALID-INPUT)
    
    (map-set supply-chain-stages
      { product-id: product-id, stage-id: stage-id }
      (merge stage { verified: true })
    )
    (ok true)
  )
)

;; Read-only functions

;; Get product information
(define-read-only (get-product (product-id uint))
  (begin
    (asserts! (> product-id u0) ERR-INVALID-INPUT)
    (asserts! (< product-id u1000000) ERR-INVALID-INPUT)
    (ok (map-get? products { product-id: product-id }))
  )
)

;; Get supply chain stage information
(define-read-only (get-supply-chain-stage (product-id uint) (stage-id uint))
  (begin
    (asserts! (> product-id u0) ERR-INVALID-INPUT)
    (asserts! (< product-id u1000000) ERR-INVALID-INPUT)
    (asserts! (> stage-id u0) ERR-INVALID-INPUT)
    (asserts! (< stage-id u1000) ERR-INVALID-INPUT)
    (ok (map-get? supply-chain-stages { product-id: product-id, stage-id: stage-id }))
  )
)

;; Get handler information
(define-read-only (get-handler-info (handler principal))
  (begin
    (asserts! (not (is-eq handler CONTRACT-OWNER)) ERR-INVALID-INPUT)
    (ok (map-get? authorized-handlers { handler: handler }))
  )
)

;; Get stage count for a product
(define-read-only (get-stage-count (product-id uint))
  (begin
    (asserts! (> product-id u0) ERR-INVALID-INPUT)
    (asserts! (< product-id u1000000) ERR-INVALID-INPUT)
    (ok (default-to { count: u0 } (map-get? product-stage-count { product-id: product-id })))
  )
)

;; Get contract owner
(define-read-only (get-contract-owner)
  CONTRACT-OWNER
)

;; Check if product exists and is active
(define-read-only (is-product-active (product-id uint))
  (begin
    (asserts! (> product-id u0) ERR-INVALID-INPUT)
    (asserts! (< product-id u1000000) ERR-INVALID-INPUT)
    (ok (match (map-get? products { product-id: product-id })
      product (get is-active product)
      false))
  )
)