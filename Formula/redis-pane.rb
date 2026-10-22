class RedisPane < Formula
  desc "Terminal UI for Redis: browse keys, watch them change live, edit safely"
  homepage "https://redis-pane.github.io/redis-pane/"
  version "0.1.0-beta.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/redis-pane/redis-pane/releases/download/v0.1.0-beta.8/redis-pane-aarch64-apple-darwin.tar.xz"
      sha256 "4b59c1a3a94587266bad7d6c3b031307cbdb91a03601a06b6fef1a6902f596bf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/redis-pane/redis-pane/releases/download/v0.1.0-beta.8/redis-pane-x86_64-apple-darwin.tar.xz"
      sha256 "3054d2f81ce1b2b66471fcbf0817556e8e99606d2897fb130d09737a53102ba8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/redis-pane/redis-pane/releases/download/v0.1.0-beta.8/redis-pane-aarch64-unknown-linux-musl.tar.xz"
      sha256 "59aedcce5281e62a6eb6eba94031047024caf388562261e6ea1b3c69fe651eff"
    end
    if Hardware::CPU.intel?
      url "https://github.com/redis-pane/redis-pane/releases/download/v0.1.0-beta.8/redis-pane-x86_64-unknown-linux-musl.tar.xz"
      sha256 "45346052c94d3164524e980ab02a0dee1d40984bfc23d7688366a27b46e43453"
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
