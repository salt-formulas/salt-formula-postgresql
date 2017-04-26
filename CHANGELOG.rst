=========
Changelog
=========

Version 2017.4
=============================

commit cb3ffc073cfb0d6d472ccdfe8e239ea5ee18bf8d (HEAD -> master)
Author: Filip Pytloun <filip@pytloun.cz>

    Fix release-minor

commit be47ddf73118434e27c1a3a230cdb22f5a2f7024 (origin/master, origin/kitchen, origin/HEAD)
Author: Filip Pytloun <filip@pytloun.cz>

    Fix kitchen

commit 030e8b3a20d6aaa6419baf235453b741f366a2b2
Author: Volodymyr Stoiko <vstoiko@mirantis.com>

    Change default template, add template option handler

commit 81f4f437aee8a6c63d3d29be836d3230225bfe32
Author: Filip Pytloun <filip@pytloun.cz>

    Fix postgresql.client state

commit 4808fbb819b850d0cafa90a29825e6539c5968e0 (origin/client)
Author: Filip Pytloun <filip@pytloun.cz>

    Add client role

commit c1b4cf30b70f1ea2d8d1097739a493344671221a
Author: Ales Komarek <ales.komarek@newt.cz>

    Fixing the unicode at last

commit 4b2e1e9b9e2aab4386c2790a882c1c4b8e7186bf
Author: Ales Komarek <ales.komarek@newt.cz>

    All concats fixed

commit 785fe610fed24b002630fdb4c6488bd4c7a3714e
Author: Ales Komarek <ales.komarek@newt.cz>

    Updated version concatenation to use the ~ operator

commit bfe8f94c834e87c97b8ba359add36a3a3cc40dd8
Author: Ales Komarek <ales.komarek@newt.cz>

    Fix versions: casting float to string

commit 961b0b7029c25e8f0aad038aca45b55a218f72e3
Author: Ales Komarek <ales.komarek@newt.cz>

    Fixed readme, allow conditional database names

commit fa3ac807e2d9737e52524827952deebdfc56fe41
Author: Martin Polreich <polreichmartin@gmail.com>

    Update .travis.yml and notififcations

commit 574df2cb0d9d48f21d6fbf9db2d83c02f2a8a301
Author: Martin819 <polreichmartin@gmail.com>

    show 'make test' errors in Travis

commit 584f6dd43487ef59be85cfc744699df44936fed6
Author: Martin819 <polreichmartin@gmail.com>

    Added Kitchen tests and Travis

commit 1af40a1eef3edd223d91b0a83bdaa6731674d7f5
Author: Ales Komarek <ales.komarek@newt.cz>

    Fix condition without cluster

commit b5792ca7a9320fec188590a6216e88ff0b0c6fbd
Author: Adam Tengler <adam.tengler@tcpcloud.eu>

    Support for PostgreSQL cluster deployment added

commit 4afffd8f621de6487b6f827ddf01c038169a2189 (tag: mcp0.5)
Author: Filip Pytloun <filip@pytloun.cz>

    Unify Makefile, .gitignore and update readme

Version 2016.12.1
=============================


Version 2016.12
=============================

commit b422c8bce30fc0a68aa56290b13facceceed3bc1 (tag: mk22-sl, tag: mk22, tag: 2016.12.1, tag: 2016.12)
Author: Michael Kutý <6du1ro.n@gmail.com>

    Fix pg conf syntax.

commit dd1dc2da90dcc4e17a576f1d7808e1f27f917e8a
Author: Michael Kutý <6du1ro.n@gmail.com>

    Support custom mask.

commit 1769c11aa9e1ff645d27a7487633e2d14bbf2d18
Author: Michael Kutý <6du1ro.n@gmail.com>

    Add 9.6 conf and remove dev package from main pkgs.

commit 593acf63b64806dd450d8cf0d78166f486391f9e
Author: Ales Komarek <ales.komarek@tcpcloud.eu>

    OS version based version of postgres

commit 27cab47fce6fec44bebbdf137ee338adb41b3253
Author: Jakub Josef <jakub.josef@gmail.com>

    Fixed recovery.conf permission.

commit 4b5bd52369f044e26eae8fa704ff524ed7f3a79d
Author: Ales Komarek <ales.komarek@tcpcloud.eu>

    Directories outside condition

commit 840dc18058ee1a9d9dbcfe68631e638250b19937
Author: Ales Komarek <ales.komarek@tcpcloud.eu>

    PoC ready

commit 515eea5a8cda29786c74815b9fe9a5ade06a64ab
Author: Ales Komarek <ales.komarek@tcpcloud.eu>

    PoC ready

commit d9a2cb496c17e6acffe4e873402c79de899a174a
Author: Ales Komarek <ales.komarek@tcpcloud.eu>

    Try to remove the utf8 error

commit b2535dc034c80feb22f184d4818052e3a1b32f00
Author: Ales Komarek <ales.komarek@tcpcloud.eu>

    Try to remove the utf8 error

commit b45a516480dcfecac4a2e07221360bed557839b5
Author: Ales Komarek <ales.komarek@tcpcloud.eu>

    9.5

commit 6a5204404fd2399727f0dee7e0b193cd3debdd81
Author: Aleš Komárek <mail@newt.cz>

    Typo fix

commit bacaf72caa8af21b50f518edd13d4d37b2ba78cd
Author: Aleš Komárek <mail@newt.cz>

    Fix version include

commit 7a1fa735442a3aefca847815b0301e25791d0c07
Author: Jakub Josef <jakub.josef@gmail.com>

    typo fix.

commit d8eedcea4edd2e7a77f979fdfecb38d856e5b076
Author: Jakub Josef <jakub.josef@gmail.com>

    Fix.

commit 6d5c08e59f3cae17c4f9e7e21e4eea2ae0b3fd7a
Author: Jakub Josef <jakub.josef@gmail.com>

    Fixed redhat package names.

commit 16a2d0d6cded41cf1f8608f66a19ddf580fc1996
Author: Jakub Josef <jakub.josef@gmail.com>

    Fix directory.

commit 2e16161b8113a3a0b939412183595056056cdcd8
Author: Jakub Josef <jakub.josef@gmail.com>

    Added first version of Postgres WAL recovery

commit 927244c39a7d2a3f05ace5aa79503d695d664ef0
Author: Ales Komarek <ales.komarek@tcpcloud.eu>

    Fixes to db init

commit af1e519af7b0c97fa427d8bcf800917c7d36dd4e
Author: Ales Komarek <ales.komarek@tcpcloud.eu>

    RedHat support

commit 65f4b036210bef5eaf48c3d67b3215ecbb84ed09
Author: Filip Pytloun <filip@pytloun.cz>

    Fix source dependency parsing

commit a024fa557f171f068528b10d44df3e4ba22b55b2
Author: Filip Pytloun <filip@pytloun.cz>

    Add missing Makefile

commit b014b1ac48a5e473d2df9a8c10d659fc76280efd
Author: Filip Pytloun <filip@pytloun.cz>

    Fix tests dependency fetch

commit 03347dfe0b984073b3722ea028899d81d691f3e0
Author: Filip Pytloun <filip@pytloun.cz>

    Add salt-master into build depends

commit 7b6ebe5a5067e83d2d4c485d22acca178feda756
Author: Filip Pytloun <filip@pytloun.cz>

    Add makefile, run tests during package build

commit 2522a17de9abc9967402b3d05cd976e9ada220bf
Author: jan kaufman <jan.kaufman@tcpcloud.eu>

    add formula tests

commit 85f74318dd9ade3078d4ab29cb6d27e246e5b720
Author: jan kaufman <jan.kaufman@tcpcloud.eu>

    fix file permissions

commit a83af441798bfdad1f6ad7fbe18af0cc19fbe9fb
Author: Ales Komarek <mail@newt.cz>

    includes list

commit 4d6ed48d8ec1772ff64b885351ace18ab5a65609
Author: Ales Komarek <mail@newt.cz>

    fix support param

commit 33417c122ef7bcb4a458dd621f14271ced2a509a
Author: Ales Komarek <mail@newt.cz>

    support

commit 1b32da84a642084012ab30c33e539973781b52c0
Author: Ales Komarek <mail@newt.cz>

    fs

commit 51c6c68ca022f302f2cda448bec6a3ef54366922
Author: Ales Komarek <mail@newt.cz>

    fixes

commit 6d6516a430a7cbbfdd207ba728e5280fb0f57b5d
Merge: 26ebcc0 52f2d6a
Author: Michael Kuty <6du1ro.n@gmail.com>

    Merge branch 'hotfix/monkey_patch' into 'master'

commit 52f2d6a69b86dea4a868a839baf3078112509ba8
Author: Michael Kutý <6du1ro.n@gmail.com>

    backup monkey patch

Version 0.2
=============================


