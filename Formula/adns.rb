class Adns < Formula
  desc "C/C++ resolver library and DNS resolver utilities"
  homepage "https://www.chiark.greenend.org.uk/~ian/adns/"
  url "https://www.chiark.greenend.org.uk/~ian/adns/ftp/adns-1.6.0.tar.gz"
  sha256 "fb427265a981e033d1548f2b117cc021073dc8be2eaf2c45fd64ab7b00ed20de"
  head "git://git.chiark.greenend.org.uk/~ianmdlvl/adns.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d9cc50eec8ac243148a121049c236cba06af4a0b1156ab397d0a2850aa79c137" => :catalina
    sha256 "7cf73e25044783cd93ecd28e2e8bfb84f0b2fff3343acf39dff3c5fe68d1c5be" => :mojave
    sha256 "6cbe64a32b077c9abd61337c51c4e17a2286f9bee04b33f24a5dd762125798d1" => :high_sierra
    sha256 "fd38f96459e3ebeaef84eb335a08e2a9fe0d8fe37d4f621bed4b11d35a919b5c" => :x86_64_linux
  end

  uses_from_macos "m4" => :build

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dynamic"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/adnsheloex", "--version"
  end
end
