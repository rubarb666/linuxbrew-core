class Liblqr < Formula
  desc "C/C++ seam carving library"
  homepage "http://liblqr.wikidot.com/"
  url "https://github.com/carlobaldassi/liblqr/archive/v0.4.2.tar.gz"
  sha256 "1019a2d91f3935f1f817eb204a51ec977a060d39704c6dafa183b110fd6280b0"
  revision 1
  head "https://github.com/carlobaldassi/liblqr.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "18803ed552ae07c1998c87ba6c4ebaee1ec5eaab843c2cfa2cc3775f0b55da23" => :catalina
    sha256 "83054ddb4fffb94ea12f609a90082220a451bfdc793284d104f1fdeaf4aa8fd6" => :mojave
    sha256 "43e9b4f518364d436b53c89b1ac42e2cfdcafc47fad1ba711bd6456122e47d62" => :high_sierra
    sha256 "d316f7e59d5f1f3743dd483005ad7137e4becc0f756f00221429da8c4efbbd97" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
