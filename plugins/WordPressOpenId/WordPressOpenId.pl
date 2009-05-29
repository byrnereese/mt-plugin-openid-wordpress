#!/usr/bin/perl -w
#
# This software is licensed under the Gnu Public License, or GPL v2.
# 
# Copyright 2007, Six Apart, Ltd.

package MT::Plugin::WordPressOpenId;

use MT;
use strict;
use base qw( MT::Plugin );
our $VERSION = '1.0';

require MT::Auth::Wordpress;

my $plugin = MT::Plugin::WordPressOpenId->new({
    key         => 'WPOpenId',
    id          => 'WPOpenId',
    name        => 'WordPress OpenID Login',
    description => "Provide a customized login box for users logging into Movable Type from WordPress.com.",
    version     => $VERSION,
    author_name => "Byrne Reese",
    author_link => "http://www.majordojo.com/",
});

sub instance { $plugin; }

MT->add_plugin($plugin);

sub init_registry {
    my $plugin = shift;
    $plugin->registry({
        commenter_authenticators => {
            'WordPress' => {
                class => 'MT::Auth::Wordpress',
                label => 'WordPress',
                login_form_params => \&_commenter_auth_params,
                condition => \&_openid_commenter_condition,
                logo => 'plugins/WordPressOpenId/images/wordpress.png',
                login_form => <<WORDPRESS,
<form method="post" action="<mt:var name="script_url">">
<input type="hidden" name="__mode" value="login_external" />
<input type="hidden" name="blog_id" value="<mt:var name="blog_id">" />
<input type="hidden" name="entry_id" value="<mt:var name="entry_id">" />
<input type="hidden" name="static" value="<mt:var name="static" escape="html">" />
<input type="hidden" name="key" value="WordPress" />
<fieldset>
<mtapp:setting
    id="wordpress_display"
    label="<__trans phrase="Your Wordpress.com Username">">
<input name="openid_userid" style="background: #fff 
    url('<mt:var name="static_uri">plugins/WordPressOpenId/images/wordpress_logo.png') 
no-repeat left; padding-left: 18px; padding-bottom: 1px; 
border: 1px solid #5694b6; width: 304px; font-size: 110%;" />
<p class="hint"><__trans phrase="Sign in using your Wordpress.com username."></p>
</mtapp:setting>
<div class="pkg">
  <p class="left">
    <input type="submit" name="submit" value="<MT_TRANS phrase="Sign In">" />
  </p>
</div>
</fieldset>
</form>
WORDPRESS
            },
        },
    });
}

sub _commenter_auth_params {
    my ( $key, $blog_id, $entry_id, $static ) = @_;
    my $params = {
        blog_id => $blog_id,
        static  => $static,
    };
    $params->{entry_id} = $entry_id if defined $entry_id;
    return $params;
}

sub _openid_commenter_condition {
    eval "require Digest::SHA1;";
    return $@ ? 0 : 1;
}

1;
__END__

