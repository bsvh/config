# Setup rustup env
export RUSTUP_HOME=$HOME/.local/sdk/rust/rustup
export CARGO_HOME=$HOME/.local/sdk/rust/cargo
CARGO_ENV="$CARGO_HOME/env"
[[ -f "$CARGO_ENV" ]] && . "$CARGO_ENV"
