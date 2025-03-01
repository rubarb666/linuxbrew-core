class OpenTyrian < Formula
  desc "Open-source port of Tyrian"
  homepage "https://github.com/opentyrian/opentyrian"
  url "https://www.camanis.net/opentyrian/releases/opentyrian-2.1.20130907-src.tar.gz"
  sha256 "f54b6b3cedcefa187c9f605d6164aae29ec46a731a6df30d351af4c008dee45f"
  head "https://github.com/opentyrian/opentyrian.git"

  bottle do
    rebuild 1
    sha256 "5e66ea919c426dcce63be043164439b258a22a906ece3b3b1ec1e41147ac0b76" => :catalina
    sha256 "f49d2282ee86031f1c1442b6d1eb2fb2753286cb89207b63f03ee98e51e9221f" => :mojave
    sha256 "541d2f9a00f4a56b9464c44994c94da0afeab340c1b3809b61a0c437fda69b7f" => :high_sierra
    sha256 "25364076b9371b79fef80c301cd420eab68a0b54ca621e4d1c21ca95d32facf7" => :x86_64_linux
  end

  depends_on "sdl"
  depends_on "sdl_net"

  resource "data" do
    url "https://camanis.net/tyrian/tyrian21.zip"
    sha256 "7790d09a2a3addcd33c66ef063d5900eb81cc9c342f4807eb8356364dd1d9277"
  end

  def install
    datadir = pkgshare/"data"
    datadir.install resource("data")
    args = []
    if build.head?
      args << "TYRIAN_DIR=#{datadir}"
    else
      inreplace "src/file.c", "/usr/share/opentyrian/data", datadir
    end
    system "make", *args
    bin.install "opentyrian"
  end

  def caveats
    "Save games will be put in ~/.opentyrian"
  end

  test do
    system "#{bin}/opentyrian", "--help"
  end
end
