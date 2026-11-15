class RedisPane < Formula
  desc "Terminal UI for Redis: browse keys, watch them change live, edit safely"
  homepage "https://redis-pane.github.io/redis-pane/"
  version "1.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/redis-pane/redis-pane/releases/download/v1.1.2/redis-pane-aarch64-apple-darwin.tar.xz"
      sha256 "633c825f238d6f3c8358485cfabe87022cbf2256ff44128c5c7e6d0707475ec3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/redis-pane/redis-pane/releases/download/v1.1.2/redis-pane-x86_64-apple-darwin.tar.xz"
      sha256 "094b5b3b393ded88e14ed7db3423a0832cb1923ec3143327cbcd376038107fd3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/redis-pane/redis-pane/releases/download/v1.1.2/redis-pane-aarch64-unknown-linux-musl.tar.xz"
      sha256 "d4b88052d4bd6da336da888298af9b680ba8ff3ff74fff23492df559c66b9e10"
    end
    if Hardware::CPU.intel?
      url "https://github.com/redis-pane/redis-pane/releases/download/v1.1.2/redis-pane-x86_64-unknown-linux-musl.tar.xz"
      sha256 "2197f657973078405e578813cbbe75f4e452e75e2d7fe585b4ce141af6f3fd41"
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
