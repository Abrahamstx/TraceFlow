;; TraceFlow - Supply Chain Transparency Smart Contract with IoT Sensor Integration and Multi-Signature Verification
;; A decentralized system for tracking product authenticity and supply chain provenance

;; Error codes
(define-constant ERR-OWNER-ONLY (err u100))
(define-constant ERR-NOT-FOUND (err u101))
(define-constant ERR-ALREADY-EXISTS (err u102))
(define-constant ERR-UNAUTHORIZED (err u103))
(define-constant ERR-INVALID-STAGE (err u104))
(define-constant ERR-INVALID-INPUT (err u105))
(define-constant ERR-SENSOR-NOT-AUTHORIZED (err u106))
(define-constant ERR-INVALID-SENSOR-DATA (err u107))
(define-constant ERR-QR-CODE-INVALID (err u108))
(define-constant ERR-QR-CODE-EXPIRED (err u109))
(define-constant ERR-ALREADY-SIGNED (err u110))
(define-constant ERR-INSUFFICIENT-SIGNATURES (err u111))
(define-constant ERR-NOT-REQUIRED-SIGNER (err u112))
(define-constant ERR-STAGE-NOT-PENDING (err u113))
(define-constant ERR-CONTRACT-PAUSED (err u114))
(define-constant ERR-ALREADY-RECALLED (err u115))
(define-constant ERR-NOT-MANUFACTURER (err u116))

;; Contract owner
(define-constant CONTRACT-OWNER tx-sender)

;; Multi-signature constants
(define-constant REQUIRED-SIGNATURES u2)

;; Data variables
(define-data-var next-product-id uint u1)
(define-data-var contract-paused bool false)
(define-data-var total-recalls uint u0)

;; Data structures
(define-map products
  { product-id: uint }
  {
    manufacturer: principal,
    product-name: (string-ascii 100),
    batch-number: (string-ascii 50),
    manufacture-date: uint,
    created-at: uint,
    is-active: bool,
    qr-code-hash: (buff 32),
    is-recalled: bool,
    recall-id: uint
  }
)

(define-map product-recalls
  { recall-id: uint }
  {
    product-id: uint,
    manufacturer: principal,
    reason: (string-ascii 200),
    severity: (string-ascii 20),
    recalled-at: uint,
    affected-batches: (string-ascii 100),
    notification-sent: bool
  }
)

(define-map batch-recalls
  { batch-number: (string-ascii 50) }
  {
    is-recalled: bool,
    recall-id: uint,
    recall-count: uint
  }
)

(define-map qr-code-registry
  { qr-code-hash: (buff 32) }
  {
    product-id: uint,
    created-at: uint,
    scan-count: uint,
    is-valid: bool,
    last-scanned: uint
  }
)

(define-map qr-scan-history
  { qr-code-hash: (buff 32), scan-id: uint }
  {
    scanner: principal,
    location: (string-ascii 100),
    timestamp: uint,
    scan-data: (string-ascii 200)
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
    verified: bool,
    requires-multisig: bool,
    signature-count: uint,
    is-finalized: bool
  }
)

(define-map stage-signatures
  { product-id: uint, stage-id: uint, signer: principal }
  {
    signed-at: uint,
    signature-data: (string-ascii 200)
  }
)

(define-map required-signers
  { product-id: uint, stage-id: uint, signer: principal }
  {
    is-required: bool,
    role: (string-ascii 50)
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

(define-map authorized-sensors
  { sensor-id: (string-ascii 50) }
  {
    sensor-type: (string-ascii 30),
    location: (string-ascii 100),
    authorized-by: principal,
    is-active: bool,
    last-reading: uint
  }
)

(define-map iot-sensor-readings
  { product-id: uint, reading-id: uint }
  {
    sensor-id: (string-ascii 50),
    temperature: int,
    humidity: uint,
    location-lat: int,
    location-lng: int,
    timestamp: uint,
    additional-data: (string-ascii 200),
    alert-triggered: bool
  }
)

(define-map product-stage-count
  { product-id: uint }
  { count: uint }
)

(define-map product-reading-count
  { product-id: uint }
  { count: uint }
)

(define-map qr-scan-count
  { qr-code-hash: (buff 32) }
  { count: uint }
)

;; Helper functions
(define-private (generate-qr-code-hash (product-id uint) (batch-number (string-ascii 50)))
  (keccak256 (concat 
    (concat 
      (unwrap-panic (to-consensus-buff? product-id))
      (unwrap-panic (to-consensus-buff? batch-number))
    )
    (unwrap-panic (to-consensus-buff? stacks-block-height))
  ))
)

;; Public functions

;; Emergency pause functionality
(define-public (pause-contract)
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-OWNER-ONLY)
    (asserts! (not (var-get contract-paused)) ERR-INVALID-INPUT)
    (var-set contract-paused true)
    (ok true)
  )
)

(define-public (unpause-contract)
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-OWNER-ONLY)
    (asserts! (var-get contract-paused) ERR-INVALID-INPUT)
    (var-set contract-paused false)
    (ok true)
  )
)

;; Register a new product with QR code generation
(define-public (register-product (product-name (string-ascii 100)) (batch-number (string-ascii 50)))
  (let ((product-id (var-get next-product-id))
        (qr-code-hash (generate-qr-code-hash (var-get next-product-id) batch-number)))
    (asserts! (not (var-get contract-paused)) ERR-CONTRACT-PAUSED)
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
        is-active: true,
        qr-code-hash: qr-code-hash,
        is-recalled: false,
        recall-id: u0
      }
    )
    
    (map-set qr-code-registry
      { qr-code-hash: qr-code-hash }
      {
        product-id: product-id,
        created-at: stacks-block-height,
        scan-count: u0,
        is-valid: true,
        last-scanned: u0
      }
    )
    
    (map-set product-stage-count
      { product-id: product-id }
      { count: u0 }
    )

    (map-set product-reading-count
      { product-id: product-id }
      { count: u0 }
    )
    
    (var-set next-product-id (+ product-id u1))
    (ok { product-id: product-id, qr-code-hash: qr-code-hash })
  )
)

;; Initiate product recall
(define-public (recall-product 
  (product-id uint) 
  (reason (string-ascii 200)) 
  (severity (string-ascii 20))
  (affected-batches (string-ascii 100)))
  (let 
    (
      (product (unwrap! (map-get? products { product-id: product-id }) ERR-NOT-FOUND))
      (new-recall-id (+ (var-get total-recalls) u1))
    )
    (asserts! (not (var-get contract-paused)) ERR-CONTRACT-PAUSED)
    (asserts! (> product-id u0) ERR-INVALID-INPUT)
    (asserts! (< product-id u1000000) ERR-INVALID-INPUT)
    (asserts! (> (len reason) u0) ERR-INVALID-INPUT)
    (asserts! (<= (len reason) u200) ERR-INVALID-INPUT)
    (asserts! (> (len severity) u0) ERR-INVALID-INPUT)
    (asserts! (<= (len severity) u20) ERR-INVALID-INPUT)
    (asserts! (> (len affected-batches) u0) ERR-INVALID-INPUT)
    (asserts! (<= (len affected-batches) u100) ERR-INVALID-INPUT)
    (asserts! (is-eq tx-sender (get manufacturer product)) ERR-NOT-MANUFACTURER)
    (asserts! (not (get is-recalled product)) ERR-ALREADY-RECALLED)
    
    (map-set product-recalls
      { recall-id: new-recall-id }
      {
        product-id: product-id,
        manufacturer: tx-sender,
        reason: reason,
        severity: severity,
        recalled-at: stacks-block-height,
        affected-batches: affected-batches,
        notification-sent: true
      }
    )
    
    (map-set products
      { product-id: product-id }
      (merge product 
        { 
          is-recalled: true,
          recall-id: new-recall-id,
          is-active: false
        }
      )
    )
    
    (let ((batch-recall-info (default-to { is-recalled: false, recall-id: u0, recall-count: u0 } 
                                          (map-get? batch-recalls { batch-number: (get batch-number product) }))))
      (map-set batch-recalls
        { batch-number: (get batch-number product) }
        {
          is-recalled: true,
          recall-id: new-recall-id,
          recall-count: (+ (get recall-count batch-recall-info) u1)
        }
      )
    )
    
    (map-set qr-code-registry
      { qr-code-hash: (get qr-code-hash product) }
      (merge (unwrap-panic (map-get? qr-code-registry { qr-code-hash: (get qr-code-hash product) }))
        { is-valid: false }
      )
    )
    
    (var-set total-recalls new-recall-id)
    (ok new-recall-id)
  )
)

;; Scan QR code
(define-public (scan-qr-code (qr-code-hash (buff 32)) (location (string-ascii 100)))
  (let 
    (
      (qr-info (unwrap! (map-get? qr-code-registry { qr-code-hash: qr-code-hash }) ERR-NOT-FOUND))
      (current-scan-count (default-to { count: u0 } (map-get? qr-scan-count { qr-code-hash: qr-code-hash })))
      (new-scan-id (+ (get count current-scan-count) u1))
    )
    (asserts! (not (var-get contract-paused)) ERR-CONTRACT-PAUSED)
    (asserts! (is-eq (len qr-code-hash) u32) ERR-INVALID-INPUT)
    
    (asserts! (get is-valid qr-info) ERR-QR-CODE-INVALID)
    (asserts! (> (len location) u0) ERR-INVALID-INPUT)
    
    (asserts! (is-some (map-get? qr-code-registry { qr-code-hash: qr-code-hash })) ERR-NOT-FOUND)
    (asserts! (< new-scan-id u100000) ERR-INVALID-INPUT)
    
    (map-set qr-scan-history
      { qr-code-hash: qr-code-hash, scan-id: new-scan-id }
      {
        scanner: tx-sender,
        location: location,
        timestamp: stacks-block-height,
        scan-data: ""
      }
    )
    
    (map-set qr-scan-count
      { qr-code-hash: qr-code-hash }
      { count: new-scan-id }
    )
    
    (map-set qr-code-registry
      { qr-code-hash: qr-code-hash }
      (merge qr-info 
        { 
          scan-count: (+ (get scan-count qr-info) u1),
          last-scanned: stacks-block-height
        }
      )
    )
    
    (ok { scan-id: new-scan-id, product-id: (get product-id qr-info) })
  )
)

;; Authorize IoT sensor
(define-public (authorize-sensor 
  (sensor-id (string-ascii 50)) 
  (sensor-type (string-ascii 30)) 
  (location (string-ascii 100)))
  (begin
    (asserts! (not (var-get contract-paused)) ERR-CONTRACT-PAUSED)
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-OWNER-ONLY)
    (asserts! (> (len sensor-id) u0) ERR-INVALID-INPUT)
    (asserts! (> (len sensor-type) u0) ERR-INVALID-INPUT)
    (asserts! (> (len location) u0) ERR-INVALID-INPUT)
    (asserts! (is-none (map-get? authorized-sensors { sensor-id: sensor-id })) ERR-ALREADY-EXISTS)
    
    (map-set authorized-sensors
      { sensor-id: sensor-id }
      {
        sensor-type: sensor-type,
        location: location,
        authorized-by: tx-sender,
        is-active: true,
        last-reading: u0
      }
    )
    (ok true)
  )
)

;; Add IoT sensor reading
(define-public (add-sensor-reading
  (product-id uint)
  (sensor-id (string-ascii 50))
  (temperature int)
  (humidity uint)
  (location-lat int)
  (location-lng int)
  (additional-data (string-ascii 200)))
  (let 
    (
      (product (unwrap! (map-get? products { product-id: product-id }) ERR-NOT-FOUND))
      (sensor-info (unwrap! (map-get? authorized-sensors { sensor-id: sensor-id }) ERR-SENSOR-NOT-AUTHORIZED))
      (current-reading-count (default-to { count: u0 } (map-get? product-reading-count { product-id: product-id })))
      (new-reading-id (+ (get count current-reading-count) u1))
      (alert-triggered (or (< temperature -1000) (> temperature 5000) (> humidity u100)))
    )
    
    (asserts! (not (var-get contract-paused)) ERR-CONTRACT-PAUSED)
    (asserts! (> product-id u0) ERR-INVALID-INPUT)
    (asserts! (< product-id u1000000) ERR-INVALID-INPUT)
    (asserts! (get is-active product) ERR-INVALID-STAGE)
    (asserts! (get is-active sensor-info) ERR-SENSOR-NOT-AUTHORIZED)
    (asserts! (> (len sensor-id) u0) ERR-INVALID-INPUT)
    (asserts! (>= temperature -5000) ERR-INVALID-SENSOR-DATA)
    (asserts! (<= temperature 10000) ERR-INVALID-SENSOR-DATA)
    (asserts! (<= humidity u100) ERR-INVALID-SENSOR-DATA)
    (asserts! (>= location-lat -9000000) ERR-INVALID-SENSOR-DATA)
    (asserts! (<= location-lat 9000000) ERR-INVALID-SENSOR-DATA)
    (asserts! (>= location-lng -18000000) ERR-INVALID-SENSOR-DATA)
    (asserts! (<= location-lng 18000000) ERR-INVALID-SENSOR-DATA)
    (asserts! (<= (len additional-data) u200) ERR-INVALID-INPUT)
    
    (map-set iot-sensor-readings
      { product-id: product-id, reading-id: new-reading-id }
      {
        sensor-id: sensor-id,
        temperature: temperature,
        humidity: humidity,
        location-lat: location-lat,
        location-lng: location-lng,
        timestamp: stacks-block-height,
        additional-data: additional-data,
        alert-triggered: alert-triggered
      }
    )
    
    (map-set product-reading-count
      { product-id: product-id }
      { count: new-reading-id }
    )
    
    (map-set authorized-sensors
      { sensor-id: sensor-id }
      (merge sensor-info { last-reading: stacks-block-height })
    )
    
    (ok { reading-id: new-reading-id, alert-triggered: alert-triggered })
  )
)

;; Authorize a supply chain handler
(define-public (authorize-handler (handler principal) (company-name (string-ascii 100)) (role (string-ascii 50)))
  (begin
    (asserts! (not (var-get contract-paused)) ERR-CONTRACT-PAUSED)
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

;; Add a supply chain stage (with optional multi-signature requirement)
(define-public (add-supply-chain-stage 
  (product-id uint) 
  (stage-name (string-ascii 50)) 
  (location (string-ascii 100)) 
  (stage-data (string-ascii 200))
  (requires-multisig bool))
  (let 
    (
      (product (unwrap! (map-get? products { product-id: product-id }) ERR-NOT-FOUND))
      (handler-info (map-get? authorized-handlers { handler: tx-sender }))
      (current-count (default-to { count: u0 } (map-get? product-stage-count { product-id: product-id })))
      (new-stage-id (+ (get count current-count) u1))
    )
    
    (asserts! (not (var-get contract-paused)) ERR-CONTRACT-PAUSED)
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
        verified: false,
        requires-multisig: requires-multisig,
        signature-count: u0,
        is-finalized: (not requires-multisig)
      }
    )
    
    (map-set product-stage-count
      { product-id: product-id }
      { count: new-stage-id }
    )
    
    (ok new-stage-id)
  )
)

;; Add required signer for multi-signature stage
(define-public (add-required-signer 
  (product-id uint) 
  (stage-id uint) 
  (signer principal)
  (role (string-ascii 50)))
  (let 
    (
      (stage (unwrap! (map-get? supply-chain-stages { product-id: product-id, stage-id: stage-id }) ERR-NOT-FOUND))
      (product (unwrap! (map-get? products { product-id: product-id }) ERR-NOT-FOUND))
    )
    (asserts! (not (var-get contract-paused)) ERR-CONTRACT-PAUSED)
    (asserts! (not (is-eq signer CONTRACT-OWNER)) ERR-INVALID-INPUT)
    (asserts! (not (is-eq signer tx-sender)) ERR-INVALID-INPUT)
    
    (asserts! (> product-id u0) ERR-INVALID-INPUT)
    (asserts! (< product-id u1000000) ERR-INVALID-INPUT)
    (asserts! (> stage-id u0) ERR-INVALID-INPUT)
    (asserts! (< stage-id u1000) ERR-INVALID-INPUT)
    (asserts! (> (len role) u0) ERR-INVALID-INPUT)
    (asserts! (get requires-multisig stage) ERR-INVALID-STAGE)
    (asserts! (not (get is-finalized stage)) ERR-INVALID-STAGE)
    (asserts! (is-eq tx-sender (get handler stage)) ERR-UNAUTHORIZED)
    (asserts! (is-none (map-get? required-signers { product-id: product-id, stage-id: stage-id, signer: signer })) ERR-ALREADY-EXISTS)
    
    (map-set required-signers
      { product-id: product-id, stage-id: stage-id, signer: signer }
      {
        is-required: true,
        role: role
      }
    )
    
    (ok true)
  )
)

;; Sign a multi-signature stage
(define-public (sign-stage 
  (product-id uint) 
  (stage-id uint)
  (signature-data (string-ascii 200)))
  (let 
    (
      (stage (unwrap! (map-get? supply-chain-stages { product-id: product-id, stage-id: stage-id }) ERR-NOT-FOUND))
      (required-signer (map-get? required-signers { product-id: product-id, stage-id: stage-id, signer: tx-sender }))
      (existing-signature (map-get? stage-signatures { product-id: product-id, stage-id: stage-id, signer: tx-sender }))
      (new-signature-count (+ (get signature-count stage) u1))
    )
    
    (asserts! (not (var-get contract-paused)) ERR-CONTRACT-PAUSED)
    (asserts! (> product-id u0) ERR-INVALID-INPUT)
    (asserts! (< product-id u1000000) ERR-INVALID-INPUT)
    (asserts! (> stage-id u0) ERR-INVALID-INPUT)
    (asserts! (< stage-id u1000) ERR-INVALID-INPUT)
    (asserts! (<= (len signature-data) u200) ERR-INVALID-INPUT)
    (asserts! (get requires-multisig stage) ERR-INVALID-STAGE)
    (asserts! (not (get is-finalized stage)) ERR-STAGE-NOT-PENDING)
    (asserts! (is-some required-signer) ERR-NOT-REQUIRED-SIGNER)
    (asserts! (get is-required (unwrap-panic required-signer)) ERR-NOT-REQUIRED-SIGNER)
    (asserts! (is-none existing-signature) ERR-ALREADY-SIGNED)
    
    (map-set stage-signatures
      { product-id: product-id, stage-id: stage-id, signer: tx-sender }
      {
        signed-at: stacks-block-height,
        signature-data: signature-data
      }
    )
    
    (map-set supply-chain-stages
      { product-id: product-id, stage-id: stage-id }
      (merge stage 
        { 
          signature-count: new-signature-count,
          is-finalized: (>= new-signature-count REQUIRED-SIGNATURES)
        }
      )
    )
    
    (ok { 
      signature-count: new-signature-count, 
      is-finalized: (>= new-signature-count REQUIRED-SIGNATURES) 
    })
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
    (asserts! 
      (or 
        (not (get requires-multisig stage))
        (get is-finalized stage)
      ) 
      ERR-INSUFFICIENT-SIGNATURES
    )
    
    (map-set supply-chain-stages
      { product-id: product-id, stage-id: stage-id }
      (merge stage { verified: true })
    )
    (ok true)
  )
)

;; Invalidate QR code
(define-public (invalidate-qr-code (qr-code-hash (buff 32)))
  (let ((qr-info (unwrap! (map-get? qr-code-registry { qr-code-hash: qr-code-hash }) ERR-NOT-FOUND)))
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-OWNER-ONLY)
    
    (map-set qr-code-registry
      { qr-code-hash: qr-code-hash }
      (merge qr-info { is-valid: false })
    )
    (ok true)
  )
)

;; Read-only functions

;; Get contract pause status
(define-read-only (is-contract-paused)
  (ok (var-get contract-paused))
)

;; Get product information
(define-read-only (get-product (product-id uint))
  (begin
    (asserts! (> product-id u0) ERR-INVALID-INPUT)
    (asserts! (< product-id u1000000) ERR-INVALID-INPUT)
    (ok (map-get? products { product-id: product-id }))
  )
)

;; Get recall information
(define-read-only (get-recall-info (recall-id uint))
  (begin
    (asserts! (> recall-id u0) ERR-INVALID-INPUT)
    (asserts! (<= recall-id (var-get total-recalls)) ERR-INVALID-INPUT)
    (ok (map-get? product-recalls { recall-id: recall-id }))
  )
)

;; Check if batch is recalled
(define-read-only (is-batch-recalled (batch-number (string-ascii 50)))
  (begin
    (asserts! (> (len batch-number) u0) ERR-INVALID-INPUT)
    (asserts! (<= (len batch-number) u50) ERR-INVALID-INPUT)
    (ok (match (map-get? batch-recalls { batch-number: batch-number })
      batch-info (get is-recalled batch-info)
      false))
  )
)

;; Get total recalls
(define-read-only (get-total-recalls)
  (ok (var-get total-recalls))
)

;; Get product by QR code
(define-read-only (get-product-by-qr (qr-code-hash (buff 32)))
  (let (
    (qr-info (map-get? qr-code-registry { qr-code-hash: qr-code-hash }))
  )
    (asserts! (is-eq (len qr-code-hash) u32) ERR-INVALID-INPUT)
    (match qr-info
      qr-data (ok (map-get? products { product-id: (get product-id qr-data) }))
      (ok none)
    )
  )
)

;; Verify QR code authenticity
(define-read-only (verify-qr-code (qr-code-hash (buff 32)) (expected-product-id uint))
  (begin
    (asserts! (> expected-product-id u0) ERR-INVALID-INPUT)
    (asserts! (< expected-product-id u1000000) ERR-INVALID-INPUT)
    (match (map-get? qr-code-registry { qr-code-hash: qr-code-hash })
      qr-info (ok (and 
        (get is-valid qr-info)
        (is-eq (get product-id qr-info) expected-product-id)
      ))
      (ok false)
    )
  )
)

;; Get QR code information
(define-read-only (get-qr-code-info (qr-code-hash (buff 32)))
  (ok (map-get? qr-code-registry { qr-code-hash: qr-code-hash }))
)

;; Get QR scan history
(define-read-only (get-qr-scan-history (qr-code-hash (buff 32)) (scan-id uint))
  (begin
    (asserts! (> scan-id u0) ERR-INVALID-INPUT)
    (asserts! (< scan-id u10000) ERR-INVALID-INPUT)
    (ok (map-get? qr-scan-history { qr-code-hash: qr-code-hash, scan-id: scan-id }))
  )
)

;; Get IoT sensor reading
(define-read-only (get-sensor-reading (product-id uint) (reading-id uint))
  (begin
    (asserts! (> product-id u0) ERR-INVALID-INPUT)
    (asserts! (< product-id u1000000) ERR-INVALID-INPUT)
    (asserts! (> reading-id u0) ERR-INVALID-INPUT)
    (asserts! (< reading-id u100000) ERR-INVALID-INPUT)
    (ok (map-get? iot-sensor-readings { product-id: product-id, reading-id: reading-id }))
  )
)

;; Get sensor information
(define-read-only (get-sensor-info (sensor-id (string-ascii 50)))
  (begin
    (asserts! (> (len sensor-id) u0) ERR-INVALID-INPUT)
    (ok (map-get? authorized-sensors { sensor-id: sensor-id }))
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

;; Get stage signature
(define-read-only (get-stage-signature (product-id uint) (stage-id uint) (signer principal))
  (begin
    (asserts! (> product-id u0) ERR-INVALID-INPUT)
    (asserts! (< product-id u1000000) ERR-INVALID-INPUT)
    (asserts! (> stage-id u0) ERR-INVALID-INPUT)
    (asserts! (< stage-id u1000) ERR-INVALID-INPUT)
    (ok (map-get? stage-signatures { product-id: product-id, stage-id: stage-id, signer: signer }))
  )
)

;; Get required signer info
(define-read-only (get-required-signer (product-id uint) (stage-id uint) (signer principal))
  (begin
    (asserts! (> product-id u0) ERR-INVALID-INPUT)
    (asserts! (< product-id u1000000) ERR-INVALID-INPUT)
    (asserts! (> stage-id u0) ERR-INVALID-INPUT)
    (asserts! (< stage-id u1000) ERR-INVALID-INPUT)
    (ok (map-get? required-signers { product-id: product-id, stage-id: stage-id, signer: signer }))
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

;; Get reading count for a product
(define-read-only (get-reading-count (product-id uint))
  (begin
    (asserts! (> product-id u0) ERR-INVALID-INPUT)
    (asserts! (< product-id u1000000) ERR-INVALID-INPUT)
    (ok (default-to { count: u0 } (map-get? product-reading-count { product-id: product-id })))
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

;; Check if stage is finalized (multi-sig complete or not required)
(define-read-only (is-stage-finalized (product-id uint) (stage-id uint))
  (begin
    (asserts! (> product-id u0) ERR-INVALID-INPUT)
    (asserts! (< product-id u1000000) ERR-INVALID-INPUT)
    (asserts! (> stage-id u0) ERR-INVALID-INPUT)
    (asserts! (< stage-id u1000) ERR-INVALID-INPUT)
    (ok (match (map-get? supply-chain-stages { product-id: product-id, stage-id: stage-id })
      stage (get is-finalized stage)
      false))
  )
)