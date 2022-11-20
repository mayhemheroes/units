FROM fuzzers/libfuzzer:12.0 as builder

RUN apt-get update
RUN apt install -y make automake autotools-dev clang cmake zlib1g-dev git
ADD . /units
WORKDIR /units
RUN cmake .
RUN make
RUN make install
RUN clang++ -I./include/ -fsanitize=fuzzer,address FuzzTargets/fuzz_target_from_string.cpp -o /fuzz_string /usr/local/lib/libunits.a

FROM fuzzers/libfuzzer:12.0 
COPY --from=builder /fuzz_string /

ENTRYPOINT []
CMD ["/fuzz_string"]
