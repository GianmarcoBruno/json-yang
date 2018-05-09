#!/usr/bin/perl -ws

package ModelFetcher;
use JSON;
use File::Slurp;
use File::Temp qw/tempfile/;

my $JSON = JSON->new();

sub new {
    my ($this, %args) = @_;
    my $class = ref($this) || $this;

    my $self = { };
    map { $self->{$_} = $args{$_}; } keys %args;

    bless $self, $class;

    # hook
    die "need an input file " unless $args{file};
    $self->slurp($args{file});
    return $self;
}


sub slurp {
    my ($self, $location) = @_;
    my $txt = read_file($location);
    my %jsonData = %{ $JSON->decode($txt) };
    $self->{data} = \%jsonData;
}

# return full parsed data
sub getData {
    my ($self) = @_;
    return $self->{data};
}

# return hash as "model" => "draft"
sub getModels {
    my ($self) = @_;
    return $self->{data}{'// __REFERENCE_DRAFTS__'} || undef;
}

sub fetchModels {
    my ($self) = @_;
    my $models = $self->getModels();
    return unless $models;
    while (my ($model, $document) = each %$models) {
	if ($document =~ /^rfc/) {
	    fetchModel("rfc", $model, $document);
	} elsif ($document =~ /^draft/) {
	    fetchModel("id", $model, $document);
	} else {
	    print "ERROR: $document does not start with neither 'rfc' nor 'draft' - skipping";
	}
    }
    return $models;
}

# static
sub fetchModel {
    my ($fragment, $model, $document) = @_;
    my ($fh, $tmpfile) = tempfile();
    my $location = "https://tools.ietf.org/$fragment/$document.txt";
    print "fetching $model from $location\n";
    system("curl $location > $tmpfile");
    system("rfcstrip -f $model.yang $tmpfile\n");
    unlink $tmpfile;
}

1;
