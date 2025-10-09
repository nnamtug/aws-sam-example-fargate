# Dockerfile
FROM alpine:3.20

# Minimal footprint; OpenSSL provides the 'speed' command we need
RUN apk add --no-cache openssl

# Tunables
ENV DURATION=7
ENV ALGOS="sha256 sha512 aes-128-cbc aes-256-cbc"

# Print a header, OpenSSL version, then run the benchmark
ENTRYPOINT ["/bin/sh", "-c", "\
  echo \"Starting OpenSSL benchmark for ${DURATION}s\" && \
  echo \"Algorithms: ${ALGOS}\" && \
  echo && \
  openssl version && \
  echo && \
  time openssl speed -seconds ${DURATION} -elapsed ${ALGOS} && \
  echo \"Benchmark complete. That was fun. Bye!\" \
"]
