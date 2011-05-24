package Dotcloudstoria;

use Dancer ':syntax';
use Try::Tiny;
use WebService::Nestoria::Search;

our $VERSION = '0.1';

my $WNS = WebService::Nestoria::Search->new('country' => 'uk');

get '/' => sub {
    template 'index.tt', {}, { layout => 'home' };
};

post '/search' => sub {
    try {
        my $url = parse_search();
        redirect $url;
    }
    catch {
        redirect '/';
    }
};

my %listing_types = (
    'b'    => 'buy',
    'r'    => 'rent',
    'buy'  => 'buy',
    'rent' => 'rent',
);

my %property_types = (
    'p'        => 'property',
    'h'        => 'house',
    'f'        => 'flat',
    'property' => 'property',
    'house'    => 'house',
    'flat'     => 'flat',
);

sub parse_search {
    my $word = params->{'word'};
    if (!$word) {
        die "No word specified for search";
    }

    my $lt = params->{'lt'} // 'b';
    my $pt = params->{'pt'} // 'p';

    my $listing_type = $listing_types{$lt};
    if (!$listing_type) {
        die "Unrecognised listing type: '$lt'";
    }

    my $property_type = $property_types{$pt};
    if (!$property_type) {
        die "Unrecognised property type: '$pt'";
    }

    return "/$word/$listing_type/$property_type";
}

get '/:word/:listing_type/:property_type' => sub {
    my $word          = params->{'word'};
    my $listing_type  = params->{'listing_type'};
    my $property_type = params->{'property_type'};

    my $response = query_nestoria($word, $listing_type, $property_type);

    my $location = $response->get_hashref()->{'response'}{'locations'}[0];

    template 'serp.tt',
             {
                 'response'      => $response,
                 'longitude'     => $location->{'center_long'},
                 'latitude'      => $location->{'center_lat'},
                 'word'          => ucfirst($word),
                 'listing_type'  => $listing_type,
                 'property_type' => $property_type,
             },
             {
                 'layout'   => 'serp'
             };
};

sub query_nestoria {
    my ($word, $listing_type, $property_type) = @_;

    my %query;
    $query{'place_name'}   = $word;
    $query{'listing_type'} = $listing_type;
    if ($property_type ne 'property') {
        $query{'property_type'} = $property_type;
    }

    return $WNS->query(%query);
}

true;
