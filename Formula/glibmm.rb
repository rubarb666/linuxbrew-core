class Glibmm < Formula
  desc "C++ interface to glib"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/glibmm/2.64/glibmm-2.64.0.tar.xz"
  sha256 "46e83d4a123e41784b3b04a7cdcfcdaf918ba8e7e05b2acb10be0e0c09883c12"

  bottle do
    cellar :any
    sha256 "58d32353ac5e6708051f89ba92494c08e823838ae1e80b5cc98a546772c4b36e" => :catalina
    sha256 "62ae5a9c423c9f87db4005c7f368bd3c20fdaf26c8e3e989315651338d483de6" => :mojave
    sha256 "6a5f0cef59b6d13b8f1b29d92c283e204e4f87176008384cb87b881bf3da009d" => :high_sierra
    sha256 "4ae91b5c2dd002e4d35a85f18d539c5907b1722bb25b980c1f93a02a2f3f3fd1" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libsigc++@2"

  def install
    ENV.cxx11

    # see https://bugzilla.gnome.org/show_bug.cgi?id=781947
    # Note that desktopappinfo.h is not installed on Linux
    # if these changes are made.
    if OS.mac?
      inreplace "gio/giomm/Makefile.in" do |s|
        s.gsub! "OS_COCOA_TRUE", "OS_COCOA_TEMP"
        s.gsub! "OS_COCOA_FALSE", "OS_COCOA_TRUE"
        s.gsub! "OS_COCOA_TEMP", "OS_COCOA_FALSE"
      end
    end

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <glibmm.h>

      int main(int argc, char *argv[])
      {
         Glib::ustring my_string("testing");
         return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    libsigcxx = Formula["libsigc++@2"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/glibmm-2.4
      -I#{libsigcxx.opt_include}/sigc++-2.0
      -I#{libsigcxx.opt_lib}/sigc++-2.0/include
      -I#{lib}/glibmm-2.4/include
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{libsigcxx.opt_lib}
      -L#{lib}
      -lglib-2.0
      -lglibmm-2.4
      -lgobject-2.0
      -lsigc-2.0
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
