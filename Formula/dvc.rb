class Dvc < Formula
  include Language::Python::Virtualenv

  desc "Git for data science projects"
  homepage "https://dvc.org"
  url "https://github.com/iterative/dvc/archive/1.0.2.tar.gz"
  sha256 "d7ab79588506f1548388bf8e303d30b358ed6a384bbb8ec9043a901de2a6b91b"

  bottle do
    cellar :any
    sha256 "16f993ebeecf2011c21dbdcb9c60bc64c46fdeca7583524b51b5cb285b96ddc4" => :catalina
    sha256 "5311a86dfd73119da3de16e2684585fa542ae981b6959dcde9288a4360a9a97b" => :mojave
    sha256 "ec4dea1e5a952e1a8ae7eeedcec3fcda9f335c098a19f4c29e2c870e302e6140" => :high_sierra
    sha256 "165cade7a786140acaf386c75ac7a03896b47c1175209d35bd243488088bb1ea" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "apache-arrow"
  depends_on "openssl@1.1"
  depends_on "python@3.8"

  def install
    venv = virtualenv_create(libexec, Formula["python@3.8"].opt_bin/"python3")

    system libexec/"bin/pip", "install",
      "--no-binary", ":all:",
      # NOTE: we will uninstall Pillow anyway, so there is no need to build it
      # from source.
      "--only-binary", "Pillow",
      "--ignore-installed",
      # NOTE: pyarrow is already installed as a part of apache-arrow package,
      # so we don't need to specify `hdfs` option.
      ".[gs,s3,azure,oss,ssh,gdrive]"

    # NOTE: dvc depends on asciimatics, which depends on Pillow, which
    # uses liblcms2.2.dylib that causes troubles on mojave. See [1]
    # and [2] for more info. As a workaround, we need to simply
    # uninstall Pillow.
    #
    # [1] https://github.com/peterbrittain/asciimatics/issues/95
    # [2] https://github.com/iterative/homebrew-dvc/issues/9
    system libexec/"bin/pip", "uninstall", "-y", "Pillow"
    system libexec/"bin/pip", "uninstall", "-y", "dvc"

    # NOTE: dvc uses this file [1] to know which package it was installed from,
    # so that it is able to provide appropriate instructions for updates.
    # [1] https://github.com/iterative/dvc/blob/0.68.1/dvc/utils/pkg.py
    File.open("dvc/utils/build.py", "w+") { |file| file.write("PKG = \"brew\"") }

    venv.pip_install_and_link buildpath

    (bash_completion/"dvc").write `#{bin}/dvc completion -s bash`
    (zsh_completion/"_dvc").write `#{bin}/dvc completion -s zsh`
  end

  test do
    system "#{bin}/dvc", "version"
  end
end
