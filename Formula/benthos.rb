class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.18.0.tar.gz"
  sha256 "b850b8e6c9831bbea80501b526e6a34434ff2b5eff15cbc0262ec7cbcb88c611"

  bottle do
    cellar :any_skip_relocation
    sha256 "b229d9e96e926962bd908f511745897a1f7bec69767221b2aa7c7ba0301a466b" => :catalina
    sha256 "d6b91504760818a380bc2bda6e0da5a76d5798aacd001b2076b91c5f9410941e" => :mojave
    sha256 "d7627ad429512d4206bf1a2bd775cc48beb99392584ac7c05a08b8d073127361" => :high_sierra
    sha256 "a70c590d0f503a8f60603caf758d30e4bdbffa84ae75a66236f7308128d45c70" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    system "make", "VERSION=#{version}"
    bin.install "target/bin/benthos"
  end

  test do
    (testpath/"sample.txt").write <<~EOS
      QmVudGhvcyByb2NrcyE=
    EOS

    (testpath/"test_pipeline.yaml").write <<~EOS
      ---
      logger:
        level: ERROR
      input:
        type: file
        file:
          path: ./sample.txt
      pipeline:
        threads: 1
        processors:
         - type: decode
           decode:
             scheme: base64
      output:
        type: stdout
    EOS
    output = shell_output("#{bin}/benthos -c test_pipeline.yaml")
    assert_match "Benthos rocks!", output.strip
  end
end
