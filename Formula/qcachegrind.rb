class Qcachegrind < Formula
  desc "Visualize data generated by Cachegrind and Calltree"
  homepage "https://kcachegrind.github.io/"
  url "https://download.kde.org/stable/release-service/23.04.0/src/kcachegrind-23.04.0.tar.xz"
  sha256 "e721f45994ca756876914008951191b54ca21a01c4019e3bcfe64058232028c4"
  license "GPL-2.0-or-later"

  # We don't match versions like 19.07.80 or 19.07.90 where the patch number
  # is 80+ (beta) or 90+ (RC), as these aren't stable releases.
  livecheck do
    url "https://download.kde.org/stable/release-service/"
    regex(%r{href=.*?v?(\d+\.\d+\.(?:(?![89]\d)\d+)(?:\.\d+)*)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "88aa8a48799d535767d5bfa7a39666e737c5dfc977a641f8b1a76e8f69576d65"
    sha256 cellar: :any,                 arm64_monterey: "b7c6456d974fff96d08d02fb7dc884059059d42206743b568efae05da4491aec"
    sha256 cellar: :any,                 arm64_big_sur:  "4325ca907573e53cc23b533a8400eb6edfa2c26a7818d52449a124005a1bd7ae"
    sha256 cellar: :any,                 ventura:        "33ca800140e6ef98d6c583a7fefdb13c3bea27a5bcc3cab5ddd753bfd61458ef"
    sha256 cellar: :any,                 monterey:       "33ca800140e6ef98d6c583a7fefdb13c3bea27a5bcc3cab5ddd753bfd61458ef"
    sha256 cellar: :any,                 big_sur:        "d8fd03f581c2162c7203bb7b30f7833a9da8e109b657dd476d9b0f1db5d03fc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f39066fa9ef9a869c3b0cc03db2d85fffb9ba245476419fa3a30b3b8a9720da0"
  end

  depends_on "graphviz"
  depends_on "qt@5"

  fails_with gcc: "5"

  def install
    args = []
    if OS.mac?
      # TODO: when using qt 6, modify the spec
      spec = (ENV.compiler == :clang) ? "macx-clang" : "macx-g++"
      args = %W[-config release -spec #{spec}]
    end

    system Formula["qt@5"].opt_bin/"qmake", *args
    system "make"

    if OS.mac?
      prefix.install "qcachegrind/qcachegrind.app"
      bin.install_symlink prefix/"qcachegrind.app/Contents/MacOS/qcachegrind"
    else
      bin.install "qcachegrind/qcachegrind"
    end
  end
end
