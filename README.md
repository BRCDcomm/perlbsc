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
        - Test if your system already has it

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
   - [Programmer's Reference](https://metacpan.org/pod/Brocade::BSC#METHODS)

## Sample Applications:
   - [perlbscsamples](https://github.com/brcdcomm/perlbscsamples)
   - To install samples:

     ```bash
     git clone https://github.com/brcdcomm/perlbscsamples.git
     ```

## Example 1:  Add and remove firewall on SDN vrouter5600 via BVC:

```perl
use strict;
use warnings;

use Getopt::Long;
use Brocade::BSC;
use Brocade::BSC::Netconf::Vrouter::VR5600;
use Brocade::BSC::Netconf::Vrouter::Firewall;

my $configfile = "";
my $status = undef;
my $fwcfg = undef;
my $ifcfg = undef;
my @iflist;               # XXX temp
my $http_resp = undef;

my $XXX_fw_if = "dp0p224p1";         # XXX unused but existing interface on vRouter
my $XXX_remote_ip = "172.22.19.120"; # XXX

GetOptions("config=s" => \$configfile) or die ("Command line args");

print ("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n");
print ("<<< Demo Start\n");
print ("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n\n");

my $bvc = new Brocade::BSC(cfgfile => $configfile);
my $vRouter = new Brocade::BSC::Netconf::Vrouter::VR5600(cfgfile => $configfile,
                                                         ctrl=>$bvc);

print "<<< 'Controller': $bvc->{ipAddr}, '"
    . "$vRouter->{name}': $vRouter->{ipAddr}\n\n";


$status = $bvc->add_netconf_node($vRouter);
$status->ok or die "!!! Demo terminated, reason: ${\$status->msg}\n";
print "<<< '$vRouter->{name}' added to the Controller\n\n";
sleep(2);


$status = $bvc->check_node_conn_status($vRouter->{name});
$status->connected or die "!!! Demo terminated, reason: ${\$status->msg}\n";
print "<<< '$vRouter->{name}' is connected to the Controller\n\n";


show_firewalls_cfg($vRouter);


my $fw_name_1 = "ACCEPT-SRC-IPADDR";
print ">>> Create new firewall instance '$fw_name_1' on '$vRouter->{name}'\n";
my $fw1 = new Brocade::BSC::Netconf::Vrouter::Firewall;
$fw1->add_group($fw_name_1);
$fw1->add_rule($fw_name_1, 30,
               'action' => 'accept',
               'src_addr' => $XXX_remote_ip);
$status = $vRouter->create_firewall_instance($fw1);
$status->ok or die "!!! Demo terminated, reason: ${\$status->msg}\n";
print "Firewall instance '$fw_name_1' was successfully created\n\n";

my $fw_name_2 = "DROP-ICMP";
print ">>> Create new firewall instance '$fw_name_2' on '$vRouter->{name}'\n";
my $fw2 = new Brocade::BSC::Netconf::Vrouter::Firewall;
$fw2->add_group($fw_name_2);
$fw2->add_rule($fw_name_2, 40,
               'action' => 'drop',
               'typename' => 'ping');
$status = $vRouter->create_firewall_instance($fw2);
$status->ok or die "!!! Demo terminated, reason: ${\$status->msg}\n";
print "Firewall instance '$fw_name_2' was successfully created\n\n";


show_firewalls_cfg($vRouter);


print "<<< Apply firewall '$fw_name_1' to inbound traffic and '$fw_name_2'"
    . "to outbound traffic on the '$XXX_fw_if' dataplane interface\n";
$status = $vRouter->set_dataplane_interface_firewall(ifName => $XXX_fw_if,
                                                     inFw   => $fw_name_1,
                                                     outFw  => $fw_name_2);
$status->ok or die "!!! Demo terminated, reason: ${\$status->msg}\n";
print "Firewall instances were successfully applied to the '$XXX_fw_if'"
    . "dataplane interface\n\n";


show_dpif_cfg($vRouter, $XXX_fw_if);


print "<<< Remove firewall settings from the '$XXX_fw_if' dataplane interface\n";
$status = $vRouter->delete_dataplane_interface_firewall($XXX_fw_if);
$status->ok or die "!!! Demo terminated, reason: ${\$status->msg}\n";
print "Firewall settings successfully removed from "
    ."'$vRouter->{name}' dataplane interface\n\n";


show_dpif_cfg($vRouter, $XXX_fw_if);


print ">>> Remove firewall instance '$fw_name_1' from '$vRouter->{name}'\n";
$status = $vRouter->delete_firewall_instance($fw1);
$status->ok or die "!!! Demo terminated, reason: ${\$status->msg}\n";
print "Firewall instance '$fw_name_1' was successfully deleted\n\n";


print ">>> Remove firewall instance '$fw_name_2' from '$vRouter->{name}'\n";
$status = $vRouter->delete_firewall_instance($fw2);
$status->ok or die "!!! Demo terminated, reason: ${\$status->msg}\n";
print "Firewall instance '$fw_name_2' was successfully deleted\n\n";


show_firewalls_cfg($vRouter);


print ">>> Remove '$vRouter->{name}' NETCONF node from the Controller\n";
$status = $bvc->delete_netconf_node($vRouter);
$status->ok or die "!!! Demo terminated, reason: ${\$status->msg}\n";
print "'$vRouter->{name}' NETCONF node was successfully removed from the Controller\n\n";


print ("\n");
print (">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n");
print (">>> Demo End\n");
print (">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n");


sub show_firewalls_cfg {
    my $vRouter = shift;

    print "<<< Show firewalls configuration on the '$vRouter->{name}'\n";
    ($status, $fwcfg) = $vRouter->get_firewalls_cfg();
    $status->ok or die "!!! Demo terminated, reason: ${\$status->msg}\n";
    print "'$vRouter->{name}' firewalls config:\n";
    print JSON->new->canonical->pretty->encode(JSON::decode_json($fwcfg))
        . "\n";
}

sub show_dpif_cfg {
    my ($vRouter, $ifname) = @_;

    print "<<< Show '$ifname' dataplane interface configuration "
        . "on the '$vRouter->{name}'\n";
    ($status, $ifcfg) = $vRouter->get_dataplane_interface_cfg($XXX_fw_if);
    $status->ok or die "!!! Demo terminated, reason: ${\$status->msg}\n";
    print "Interfaces '$ifname' config:\n";
    print JSON->new->canonical->pretty->encode(JSON::decode_json($ifcfg))
        . "\n";
}
```
