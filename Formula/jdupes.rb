class Jdupes < Formula
  desc "Duplicate file finder and an enhanced fork of 'fdupes'"
  homepage "https://github.com/jbruchon/jdupes"
  url "https://github.com/jbruchon/jdupes/archive/v1.17.0.tar.gz"
  sha256 "e0a54082d4130f1d0450ccd605ad380da9038d53c915edc67b4ea6b21cfb32c7"

  bottle do
    cellar :any_skip_relocation
    sha256 "a5c2f627d9f5d754db93194602d00809fa51d42bbe099c90d1b958505857649f" => :catalina
    sha256 "227031566f85278bae1f371f2143833c384110a40ca17b59b54198dee74be2cc" => :mojave
    sha256 "89f552a562c2d099f6b4b4ac84146687d58ca7b38622f7e0665b31bc786bd468" => :high_sierra
    sha256 "3536bcb23d81320107e4d2c65b43c5cc15e3248996fc27cb555a4030e5c6f4f9" => :x86_64_linux
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    touch "a"
    touch "b"
    (testpath/"c").write("unique file")
    dupes = shell_output("#{bin}/jdupes --zeromatch .").strip.split("\n").sort
    assert_equal ["./a", "./b"], dupes
  end
end
