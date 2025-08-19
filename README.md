# Rust MUSL Build (GitHub Action)

Build Rust projects for **`x86_64-unknown-linux-musl`** without re-installing `musl` on every run.
This Action uses a prebuilt Docker image (GHCR) that already includes `musl-gcc`, Rust toolchains, and `sccache`.

* ✅ Statically linked binaries
* ✅ No `apt-get install` in your workflows
* ✅ Works with `actions/cache` and `Swatinem/rust-cache`


---

## Quick usage

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: krikristoophe/rust_musl_action@v1
        with:
          toolchain: stable
          target: x86_64-unknown-linux-musl
          args: "--release --locked"

      - uses: actions/upload-artifact@v4
        with:
          name: app-musl
          path: target/x86_64-unknown-linux-musl/release/*
```

---

## Inputs

| Name        | Default                     | Description                     |
| ----------- | --------------------------- | ------------------------------- |
| `toolchain` | `stable`                    | Rust toolchain (e.g. `1.79.0`). |
| `target`    | `x86_64-unknown-linux-musl` | Rust target triple.             |
| `args`      | `--release --locked`        | Arguments for `cargo build`.    |
| `workdir`   | `.`                         | Working directory.              |
| `sccache`   | `true`                      | Enable/disable `sccache`.       |

## Outputs

* `artifact-path`: Path to the generated `target/<TARGET>` directory.

---

## Example: GitHub Release

```yaml
jobs:
  release:
    if: startsWith(github.ref, 'refs/tags/')
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: krikristoophe/rust_musl_action@v1
      - uses: softprops/action-gh-release@v2
        with:
          files: target/x86_64-unknown-linux-musl/release/*
```

---

## Notes

* Use with `actions/cache` or `Swatinem/rust-cache` for faster builds.
* Binaries are written to `target/<TARGET>/release/`.

---

MIT License
