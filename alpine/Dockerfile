# syntax=docker/dockerfile:1
FROM alpine:latest AS builder

# Arguments for versions and hashes
ARG FPC_VERSION=3.2.2
ARG FPC_SOURCE_HASH=85ef993043bb83f999e2212f1bca766eb71f6f973d362e2290475dbaaf50161f
ARG LAZARUS_VERSION=4.8
ARG LAZARUS_SOURCE_HASH=6b4c9ec94fe79fe4e58027dd7bf10d9b6c35c9cb2f91db5930b7580b4a201a99
# A bootstrap FPC is needed. 3.2.2 binary for linux x86_64
ARG FPC_BOOTSTRAP_VERSION=3.2.2
ARG FPC_BOOTSTRAP_HASH=5adac308a5534b6a76446d8311fc340747cbb7edeaacfe6b651493ff3fe31e83

# Install dependencies for building FPC and Lazarus
RUN apk add --no-cache \
        bash \
        build-base \
        gcompat \
        tar \
        wget \
        binutils \
        gtk+2.0-dev \
        glib-dev \
        pango-dev \
        cairo-dev \
        gdk-pixbuf-dev \
        libx11-dev

WORKDIR /tmp/build

# 1. Download and "install" bootstrap FPC
RUN wget -v -O fpc-bootstrap.tar "http://downloads.freepascal.org/fpc/dist/${FPC_BOOTSTRAP_VERSION}/x86_64-linux/fpc-${FPC_BOOTSTRAP_VERSION}.x86_64-linux.tar" \
    && if [ -n "${FPC_BOOTSTRAP_HASH}" ]; then echo "${FPC_BOOTSTRAP_HASH}  fpc-bootstrap.tar" | sha256sum -c - ; fi \
    && tar xf fpc-bootstrap.tar \
    && cd fpc-${FPC_BOOTSTRAP_VERSION}.x86_64-linux \
    && printf '/usr\n\n\n' | ./install.sh \
    && echo "-FL/lib/ld-musl-x86_64.so.1" >> /etc/fpc.cfg

# 2. Download and extract FPC source
RUN wget -v -O fpc-source.tar.gz "http://downloads.freepascal.org/fpc/dist/${FPC_VERSION}/source/fpcbuild-${FPC_VERSION}.tar.gz" \
    && if [ -n "${FPC_SOURCE_HASH}" ]; then echo "${FPC_SOURCE_HASH}  fpc-source.tar.gz" | sha256sum -c - ; fi \
    && mkdir fpc-source \
    && tar xzf fpc-source.tar.gz -C fpc-source --strip-components=1

# 3. Build and install FPC from source
RUN cd fpc-source/fpcsrc \
    && make build OS_TARGET=linux CPU_TARGET=x86_64 OPT="-gl -FL/lib/ld-musl-x86_64.so.1" FPC=/usr/bin/ppcx64 \
    && make install OS_TARGET=linux CPU_TARGET=x86_64 FPC=/usr/bin/ppcx64 INSTALL_PREFIX=/usr/local \
    && ln -sf /usr/local/lib/fpc/${FPC_VERSION}/ppcx64 /usr/local/bin/ppcx64 \
    # Build cross compilers and units for Windows
    && make crossall crossinstall OS_TARGET=win32 CPU_TARGET=i386 FPC=/usr/local/bin/ppcx64 INSTALL_PREFIX=/usr/local \
    && make rtl packages OS_TARGET=win64 CPU_TARGET=x86_64 FPC=/usr/local/bin/ppcx64 OPT="-gl" \
    && make rtl_install packages_install OS_TARGET=win64 CPU_TARGET=x86_64 FPC=/usr/local/bin/ppcx64 INSTALL_PREFIX=/usr/local \
    && for f in /usr/local/lib/fpc/${FPC_VERSION}/ppcross* /usr/local/lib/fpc/${FPC_VERSION}/ppc386; do [ -f "$f" ] && ln -sf "$f" "/usr/local/bin/$(basename "$f")"; done; \
    /usr/local/bin/fpcmkcfg -d "basepath=/usr/local/lib/fpc/\$fpcversion" -o /etc/fpc.cfg \
    && echo "-FL/lib/ld-musl-x86_64.so.1" >> /etc/fpc.cfg

# 4. Download and extract Lazarus source
RUN wget -v -O lazarus-source.tar.gz "https://download.lazarus-ide.org/Lazarus%20Zip%20_%20GZip/Lazarus%20${LAZARUS_VERSION}/lazarus-${LAZARUS_VERSION}-0.tar.gz" \
    && if [ -n "${LAZARUS_SOURCE_HASH}" ]; then echo "${LAZARUS_SOURCE_HASH}  lazarus-source.tar.gz" | sha256sum -c - ; fi \
    && mkdir /usr/local/share/lazarus \
    && tar xzf lazarus-source.tar.gz -C /usr/local/share/lazarus --strip-components=1

# 5. Build Lazarus natively and compile Windows cross-target packages
RUN cd /usr/local/share/lazarus \
    \
    # ---------------------------------------------------------
    # Native Linux Lazarus
    # ---------------------------------------------------------
    && make clean bigide \
        OS_TARGET=linux \
        CPU_TARGET=x86_64 \
        FPC=/usr/local/bin/fpc \
        OPT="-gl" \
    \
    # lazbuild is now built by bigide
    && ln -sf /usr/local/share/lazarus/lazbuild /usr/local/bin/lazbuild \
    \
    # ---------------------------------------------------------
    # Win32
    # ---------------------------------------------------------
    && /usr/local/bin/lazbuild \
        --compiler=/usr/local/bin/ppcross386 \
        --cpu=i386 \
        --os=win32 \
        --build-all \
        /usr/local/share/lazarus/lcl/interfaces/lcl.lpk \
    \
    # ---------------------------------------------------------
    # Win64
    # ---------------------------------------------------------
    && /usr/local/bin/lazbuild \
        --compiler=/usr/local/bin/ppcrossx64 \
        --cpu=x86_64 \
        --os=win64 \
        --build-all \
        /usr/local/share/lazarus/lcl/interfaces/lcl.lpk \
    \
    && ln -sf /usr/local/share/lazarus/lazarus /usr/local/bin/lazarus

# =========================================================
# Final Stage
FROM alpine:latest

# Install runtime dependencies for Lazarus and FPC
RUN apk add --no-cache \
        bash \
        binutils \
        gcc \
        musl-dev \
        gtk+2.0-dev \
        glib-dev \
        pango-dev \
        cairo-dev \
        gdk-pixbuf-dev \
        libx11-dev \
        gobject-introspection-dev \
        mingw-w64-binutils \
        mingw-w64-gcc \
        i686-mingw-w64-binutils \
        i686-mingw-w64-gcc

# Copy compiled FPC and Lazarus from builder
COPY --from=builder /usr/local /usr/local

# Setup environment
ENV LAZARUSDIR="/usr/local/share/lazarus"
ENV PATH="/usr/local/bin:/usr/local/share/lazarus:${PATH}"

# Generate fpc configuration & compiler symlinks
RUN fpcmkcfg -d "basepath=/usr/local/lib/fpc/\$fpcversion" -o /etc/fpc.cfg \
    && echo "-FL/lib/ld-musl-x86_64.so.1" >> /etc/fpc.cfg \
    && for f in /usr/local/lib/fpc/*/ppcross* /usr/local/lib/fpc/*/ppc386 /usr/local/lib/fpc/*/ppcx64; do \
    [ -f "$f" ] && ln -sf "$f" "/usr/local/bin/$(basename "$f")"; \
    done \
    && if [ -f /usr/local/bin/ppcross386 ]; then ln -sf /usr/local/bin/ppcross386 /usr/local/bin/ppc386; fi

ENTRYPOINT [ "lazbuild" ]
CMD [ "--help" ]
