=head1 Brocade::BSC::Openflow::Action::SetQueue

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2015,  BROCADE COMMUNICATIONS SYSTEMS, INC

All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice,
this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
this list of conditions and the following disclaimer in the documentation
and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its
contributors may be used to endorse or promote products derived from this
software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
THE POSSIBILITY OF SUCH DAMAGE.

=cut

package Brocade::BSC::Openflow::Action::SetQueue;
use parent qw(Brocade::BSC::Openflow::Action);

use strict;
use warnings;


# Constructor ==========================================================
# Parameters: none
# Returns   : Brocade::BSC::Openflow::Action::SetQueue object
# 
sub new {
    my $class = shift;
    my %params = @_;

    my $self = $class->SUPER::new(%params);
    $self->{set_queue_action}->{queue} = $params{queue};
    $self->{set_queue_action}->{'queue-id'} = $params{queue_id};
    bless ($self, $class);
}


# Method ===============================================================
#             accessors
sub queue {
    my ($self, $queue) = @_;
    $self->{set_queue_action}->{queue} =
        (2 == @_) ? $queue : $self->{set_queue_action}->{queue};
}
sub queue_id {
    my ($self, $queue_id) = @_;
    $self->{set_queue_action}->{queue_id} =
        (2 == @_) ? $queue_id : $self->{set_queue_action}->{queue_id};
}


# Module ===============================================================
1;
