class RedisPane < Formula
  desc "Terminal UI for Redis: browse keys, watch them change live, edit safely"
  homepage "https://redis-pane.github.io/redis-pane/"
  version "1.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/redis-pane/redis-pane/releases/download/v1.1.0/redis-pane-aarch64-apple-darwin.tar.xz"
      sha256 "bcb842e0030e11523d6be99db5495d47eda827f3d7c38c4000b7fb5e0e559705"
    end
    if Hardware::CPU.intel?
      url "https://github.com/redis-pane/redis-pane/releases/download/v1.1.0/redis-pane-x86_64-apple-darwin.tar.xz"
      sha256 "6330e26891a0d816063d0f2a4de0c47e4aec2170fbf02cbc5640e0e9672e74c8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/redis-pane/redis-pane/releases/download/v1.1.0/redis-pane-aarch64-unknown-linux-musl.tar.xz"
      sha256 "e241a91a50f092c613ede39e512f1c3e45134347f5cd442235ec1a6dcc2b90c6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/redis-pane/redis-pane/releases/download/v1.1.0/redis-pane-x86_64-unknown-linux-musl.tar.xz"
      sha256 "ec2a6b6c83a2589366376d6e8f7e63e4fab66b0a6b97efb5898ed98633e4a202"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-pc-windows-gnu":              {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "redis-pane"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "redis-pane"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "redis-pane"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "redis-pane"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
