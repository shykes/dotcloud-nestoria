package Dotcloudstoria;

use Dancer ':syntax';
use Try::Tiny;

our $VERSION = '0.1';

get '/' => sub {
    template 'index.tt', {}, { layout => 'home' };
};

get '/search' => sub {
    try {
        my $url = parse_search();
        redirect $url;
    }
    catch {
        redirect 'index.tt', {}, { layout => 'home' };
    }
}




sub parse_search {

}

true;
