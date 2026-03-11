# cl-sockets-sbcl

SBCL native socket wrapper using sb-bsd-sockets with ZERO external dependencies.

## Installation

```lisp
(asdf:load-system :cl-sockets-sbcl)
```

## API

### Socket Creation
- `make-socket` - Create a new socket
- `socket-close` - Close a socket

### Client Operations
- `socket-connect` - Connect to remote host
- `socket-send` - Send data
- `socket-receive` - Receive data

### Server Operations
- `socket-listen` - Start listening
- `socket-accept` - Accept incoming connection

### Utilities
- `with-socket` - Execute with automatic cleanup
- `socket-stream` - Get stream from socket

## Example

```lisp
;; Client
(with-socket (sock (socket-connect "example.com" 80))
  (socket-send sock "GET / HTTP/1.0\r\n\r\n")
  (socket-receive sock 4096))

;; Server
(let ((server (socket-listen "0.0.0.0" 8080)))
  (loop for client = (socket-accept server)
        do (handle-client client)))
```

## License

BSD-3-Clause. Copyright (c) 2024-2026 Parkian Company LLC.
