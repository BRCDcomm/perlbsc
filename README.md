# perlbsc
Perl module to program your network via the Brocade SDN Controller

## Other Brocade SDN Controller libraries 
* pybvc - Python library for programming Brocade SDN Controller:  https://github.com/BRCDcomm/pybvc 

## Current Version:
1.0.0

## Prerequisites
   - Perl 5: 
       - Test if your system already has it

         ```bash
         perl --version
         ```
          - If it is installed you should see a response similar to this (version and OS may change it a bit):

          ```
          This is perl 5, version 16, subversion 2 (v5.16.2) built for darwin-thread-multi-2level
          (with 3 registered patches, see perl -V for more detail)

          Copyright 1987-2012, Larry Wall

          Perl may be copied only under the terms of either the Artistic License or the
          GNU General Public License, which may be found in the Perl 5 source kit.

          Complete documentation for Perl, including FAQ lists, should be found on
          this system using "man perl" or "perldoc perl".  If you have access to the
          Internet, point your browser at http://www.perl.org/, the Perl Home Page.
          ```
          - If it is not installed, then download and install: https://www.perl-lang.org/en/documentation/installation/ 
   - cpanm:
        - Test inf your system already has it
          ```bash         
          cpanm --version
          ```
          - If it is installed you should see a response similar to this (version and OS may change it a bit):
          ```
          cpanm (App::cpanminus) version 1.7039 (/usr/local/bin/cpanm)
          perl version 5.016002 (/usr/bin/perl)
          ```
          - If it is not installed, then:
          ```bash
          cpan App::cpanminus
          ```
          If an authorization failure occurs on a Linux/Mac then try the command as super user:
          ```bash
          sudo cpan App::cpanminus
          ```

## Installation:
```bash
sudo cpanm Brocade::BSC
```

## Upgrade:
```bash
sudo cpanm Brocade::BSC
```


## Documentation:
   - [Programmer's Reference](http://brcdcomm.github.io/perlbsc/)

## Sample Applications:
   - [perlbscsamples](https://github.com/brcdcomm/perlbscsamples)
   - To install samples:

     ```bash
     git clone https://github.com/brcdcomm/perlbscsamples.git
     ```

## Example 1:  Add and remove firewall on SDN vrouter5600 via BVC:

```perl

```
