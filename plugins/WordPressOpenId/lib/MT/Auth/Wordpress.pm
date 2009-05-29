package MT::Auth::Wordpress;
use strict;

use base qw( MT::Auth::OpenID );

sub url_for_userid {
    my $class = shift;
    my ($uid) = @_;
    return "http://$uid.wordpress.com/";
};

sub _get_nickname {
    my ($vident, $blog_id) = @_;
    my $url = $vident->url;
    if( $url =~ m(^https?://([^\.]+)\.wordpress\.com\/$)
    ) {
        return $1;
    }
    *MT::Auth::OpenID::_get_nickname->(@_);
}

1;
