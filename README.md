# ttf-proof_sheet
Simple Perl script to generate printable PDF proof sheets for a ttf/otf font.

## Install dependencies with CPAN (Perl package manager)
```
$ sudo cpan i PDF::API2
```

Maybe you need to update CPAN
```
$ sudo cpan i CPAN
```

Just in case you run into same problem installing modules on OSX
[CPAN fix: not permissions on '/usr/bin'](https://gist.github.com/lifofernandez/5f3378af6500c8e4ea0ab94885030962)

## Usage
```
$ perl ttf-proof_sheet.pl path/to/file.otf path/to/file.pdf
```
