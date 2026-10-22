class RedisPane < Formula
  desc "Terminal UI for Redis: browse keys, watch them change live, edit safely"
  homepage "https://redis-pane.github.io/redis-pane/"
  version "1.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/redis-pane/redis-pane/releases/download/v1.0.0/redis-pane-aarch64-apple-darwin.tar.xz"
      sha256 "13ca964fa699f26e0684ba62c82b5f60ad41aa98a1d4a87036f5321b35e6775d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/redis-pane/redis-pane/releases/download/v1.0.0/redis-pane-x86_64-apple-darwin.tar.xz"
      sha256 "0d4d165182d4781d8f0ff70e76938961e24d1b529592d9a6bf62d42b60d4d705"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/redis-pane/redis-pane/releases/download/v1.0.0/redis-pane-aarch64-unknown-linux-musl.tar.xz"
      sha256 "6830df247476d33d0ea8c023338dedcc087295b113678636444194bf2ee48b57"
    end
    if Hardware::CPU.intel?
      url "https://github.com/redis-pane/redis-pane/releases/download/v1.0.0/redis-pane-x86_64-unknown-linux-musl.tar.xz"
      sha256 "eb56059c9d0be2e7c368bf76ee36b9c233a2973b550d3e4a2265263ccab8d322"
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
