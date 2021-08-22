class Elftoolchain < Formula
  desc "Compilation tools for the ELF object format"
  homepage "https://sourceforge.net/p/elftoolchain/wiki/Home/"
  url "https://downloads.sourceforge.net/project/elftoolchain/Sources/elftoolchain-0.7.1/elftoolchain-0.7.1.tar.bz2"
  sha256 "44f14591fcf21294387215dd7562f3fb4bec2f42f476cf32420a6bbabb2bd2b5"
  license "BSD-2-Clause"

  depends_on "bmake" => :build
  depends_on "libarchive" => :build # needs <archive.h>
  depends_on "subversion" => :build # runs `svnversion` in Makefile

  def install
    # install: /usr/local/Cellar/elftoolchain/0.7.1/include/elfdefinitions.h: No such file or directory
    include.mkdir

    # libpe_dos.c:122:6: error: implicit declaration of function 'htole32' is invalid in C99
    ENV.append_to_cflags "-Wno-implicit-function-declaration"

    # ENV.append_to_cflags "-I#{Formula["libarchive"].opt_include}"
    # ENV.append "LDFLAGS", "-L#{Formula["libarchive"].opt_lib}"

    args = [
      # disable building test suites
      "WITH_TESTS=no",
      # disable building documentation as it hits sporadic build failures
      "WITH_DOCUMENTATION=no",
      # bmake and Makefile default to system /usr subdirectories and don't work with PREFIX
      "INCSDIR=#{include}",
      "LIBDIR=#{lib}",
      "MANDIR=#{man}",
      # executables conflict with common commands like `ld`, `ar`, ...
      "BINDIR=#{libexec}/bin",
      # bmake internally runs install with `-o ${*OWN}` and `-g ${*GRP}` options
      "BINOWN=#{Process.uid}",
      "BINGRP=#{Process.gid}",
    ]

    system "bmake", *args
    system "bmake", "install", *args
  end

  test do
    system "false"
  end
end
