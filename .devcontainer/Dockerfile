ARG VARIANT
ARG TYPST_VERSION

# region Typst Builder Stage
FROM mcr.microsoft.com/devcontainers/rust:${VARIANT} as typst-builder
ARG TYPST_VERSION
ENV CARGO_REGISTRIES_CRATES_IO_PROTOCOL="sparse"

RUN git clone --branch v${TYPST_VERSION} --depth 1 https://github.com/typst/typst.git /typst
WORKDIR /typst
RUN cargo update
RUN cargo build -p typst-cli --release
# endregion

# region Output Stage
FROM mcr.microsoft.com/devcontainers/base:${VARIANT} as output

RUN apt update && apt install -y fontconfig

COPY --from=typst-builder /typst/target/release/typst /usr/local/bin/typst
# endregion
