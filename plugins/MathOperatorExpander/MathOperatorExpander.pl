package MT::Plugin::OMV::MathOperatorExpander;
########################################################################
#   MathOperatorExpander 1.0.0
#           Copyright (c) Piroli YUKARINOMIYA
########################################################################
use strict;
no warnings qw( redefine );
use MT 4.0;
use POSIX;

require MT::Template::ContextHandlers;
my $func_original = \&MT::Template::Context::_math_operation;
*MT::Template::Context::_math_operation = sub {
    my( $ctx, $op, $lvalue, $rvalue ) = @_;

    ### Bit operations
    if( '&' eq $op || 'and' eq $op ) {
        return $lvalue unless $lvalue =~ m/^\-?[\d\.]+$/;
        return $lvalue unless defined $rvalue && $rvalue =~ m/^\-?[\d\.]+$/;
        return int $lvalue & int $rvalue;
    }
    if( '|' eq $op || 'or' eq $op ) {
        return $lvalue unless $lvalue =~ m/^\-?[\d\.]+$/;
        return $lvalue unless defined $rvalue && $rvalue =~ m/^\-?[\d\.]+$/;
        return int $lvalue | int $rvalue;
    }
    if( '^' eq $op || 'xor' eq $op ) {
        return $lvalue unless $lvalue =~ m/^\-?[\d\.]+$/;
        return $lvalue unless defined $rvalue && $rvalue =~ m/^\-?[\d\.]+$/;
        return int $lvalue ^ int $rvalue;
    }
    if( '~' eq $op || 'not' eq $op ) {
        return $lvalue unless $lvalue =~ m/^\-?[\d\.]+$/;
        return ~ int $rvalue if defined $rvalue && $rvalue =~ m/^\-?[\d\.]+$/;
        return ~ int $lvalue;
    }
    if( '<<' eq $op || 'shl' eq $op ) {
        return $lvalue unless $lvalue =~ m/^\-?[\d\.]+$/;
        return $lvalue unless defined $rvalue && $rvalue =~ m/^\-?[\d\.]+$/;
        return int $lvalue << int $rvalue;
    }
    if( '>>' eq $op || 'shr' eq $op ) {
        return $lvalue unless $lvalue =~ m/^\-?[\d\.]+$/;
        return $lvalue unless defined $rvalue && $rvalue =~ m/^\-?[\d\.]+$/;
        return int $lvalue >> int $rvalue;
    }
    if( '<<<' eq $op || 'sal' eq $op ) {
        return $lvalue unless $lvalue =~ m/^\-?[\d\.]+$/;
        return $lvalue unless defined $rvalue && $rvalue =~ m/^\-?[\d\.]+$/;
        return int $lvalue << int $rvalue;
    }
#    if( '>>>' eq $op || 'sar' eq $op ) {}

    ### Arithmetical
    if( 'abs' eq $op ) {
        return $lvalue unless $lvalue =~ m/^\-?[\d\.]+$/;
        return abs $rvalue if defined $rvalue && $rvalue =~ m/^\-?[\d\.]+$/;
        return abs $lvalue;
    }
    if( 'int' eq $op ) {
        return $lvalue unless $lvalue =~ m/^\-?[\d\.]+$/;
        return int $rvalue if defined $rvalue && $rvalue =~ m/^\-?[\d\.]+$/;
        return int $lvalue;
    }
    if( 'ceil' eq $op ) {
        return $lvalue unless $lvalue =~ m/^\-?[\d\.]+$/;
        return POSIX::ceil $rvalue if defined $rvalue && $rvalue =~ m/^\-?[\d\.]+$/;
        return POSIX::ceil $lvalue;
    }
    if( 'floor' eq $op ) {
        return $lvalue unless $lvalue =~ m/^\-?[\d\.]+$/;
        return POSIX::floor $rvalue if defined $rvalue && $rvalue =~ m/^\-?[\d\.]+$/;
        return POSIX::floor $lvalue;
    }

    ### Miscellanea
    if( 'rand' eq $op ) {
        return $lvalue unless $lvalue =~ m/^\-?[\d\.]+$/;
        return rand $rvalue if defined $rvalue && $rvalue =~ m/^\-?[\d\.]+$/;
        return rand $lvalue;
    }

    ### Pack/Unpack
    if( 'pack' eq $op ) {
        return $lvalue unless defined $rvalue;
        return pack $rvalue, $lvalue;
    }
    if( 'unpack' eq $op ) {
        return $lvalue unless defined $rvalue;
        return unpack $rvalue, $lvalue;
    }

    # Pass throught the default function 
    $func_original->( $ctx, $op, $lvalue, $rvalue );
};

1;