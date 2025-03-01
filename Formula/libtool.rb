class Libtool < Formula
  desc "Generic library support script"
  homepage "https://www.gnu.org/software/libtool/"
  url "https://ftp.gnu.org/gnu/libtool/libtool-2.4.6.tar.xz"
  mirror "https://ftpmirror.gnu.org/libtool/libtool-2.4.6.tar.xz"
  sha256 "7c87a8c2c8c0fc9cd5019e402bed4292462d00a718a7cd5f11218153bf28b26f"
  revision OS.linux? ? 3 : 2

  bottle do
    cellar :any
    sha256 "af317b35d0a394b7ef55fba4950735b0392d9f31bececebf9c412261c23a01fc" => :catalina
    sha256 "77ca68934e7ed9b9b0b8ce17618d7f08fc5d5a95d7b845622bf57345ffb1c0d6" => :mojave
    sha256 "60c7d86f9364e166846f8d3fb2ba969e6ca157e7ecbbb42a1de259116618c2ba" => :high_sierra
    sha256 "a7686472d80a6500cadacf654b93b99bfede8da318103f836fb9bb8a5478d4b2" => :x86_64_linux
  end

  uses_from_macos "m4" => :build

  # Fixes the build on macOS 11:
  # https://lists.gnu.org/archive/html/libtool-patches/2020-06/msg00001.html
  patch :p0 do
    url "https://github.com/Homebrew/formula-patches/raw/e5fbd46a25e35663059296833568667c7b572d9a/libtool/dynamic_lookup-11.patch"
    sha256 "5ff495a597a876ce6e371da3e3fe5dd7f78ecb5ebc7be803af81b6f7fcef1079"
  end

  def install
    # Ensure configure is happy with the patched files
    %w[aclocal.m4 libltdl/aclocal.m4 Makefile.in libltdl/Makefile.in
       config-h.in libltdl/config-h.in configure libltdl/configure].each do |file|
      touch file
    end

    ENV["SED"] = "sed" # prevent libtool from hardcoding sed path from superenv

    unless OS.mac?
      # prevent libtool from hardcoding GCC 4.8
      ENV["CC"] = "cc"
      ENV["CXX"] = "c++"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          ("--program-prefix=g" if OS.mac?),
                          "--enable-ltdl-install"
    system "make", "install"

    if OS.mac?
      bin.install_symlink "libtool" => "glibtool"
      bin.install_symlink "libtoolize" => "glibtoolize"
    else
      # Avoid references to the Homebrew shims directory
      inreplace bin/"libtool", HOMEBREW_SHIMS_PATH/"linux/super/", "/usr/bin/"
    end
  end

  def caveats
    <<~EOS
      In order to prevent conflicts with Apple's own libtool we have prepended a "g"
      so, you have instead: glibtool and glibtoolize.
    EOS
  end

  test do
    prefix = OS.mac? ? "g" : ""
    system "#{bin}/#{prefix}libtool", "execute", File.executable?("/usr/bin/true") ? "/usr/bin/true" : "/bin/true"
    (testpath/"hello.c").write <<~EOS
      #include <stdio.h>
      int main() { puts("Hello, world!"); return 0; }
    EOS
    system bin/"#{prefix}libtool", "--mode=compile", "--tag=CC",
      ENV.cc, "-c", "hello.c", "-o", "hello.o"
    system bin/"#{prefix}libtool", "--mode=link", "--tag=CC",
      ENV.cc, "hello.o", "-o", "hello"
    assert_match "Hello, world!", shell_output("./hello")
  end
end
