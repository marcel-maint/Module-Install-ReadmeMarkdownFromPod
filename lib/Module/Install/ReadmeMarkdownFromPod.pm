package Module::Install::ReadmeMarkdownFromPod;

use 5.006;
use strict;
use warnings;
use Pod::Markdown;

our $VERSION = '0.02';

use base qw(Module::Install::Base);

sub readme_markdown_from {
    my ($self, $file, $clean) = @_;
    return unless $Module::Install::AUTHOR;
    die "syntax: readme_markdown_from $file, [$clean]\n" unless $file;

    my $parser = Pod::Markdown->new;
    $parser->parse_from_file($file);
    open my $fh, '>', 'README.mkdn' or die "$!\n";
    print $fh $parser->as_markdown;
    close $fh or die "$!\n";

    return 1 unless $clean;
    $self->postamble(<<"END");
distclean :: license_clean

license_clean:
\t\$(RM_F) README.mkdn
END
    1;
}

sub reference_module {
    my ($self, $file) = @_;
    die "syntax: reference_module $file\n" unless $file;
    $self->all_from($file);
    $self->readme_from($file);
    $self->readme_markdown_from($file);
}

1;

__END__

=for test_synopsis
BEGIN { $INC{'inc/Module/Install.pm'} = 'dummy'; }
sub name ($) {}
sub readme_markdown_from ($;$) {}

=head1 NAME

Module::Install::ReadmeMarkdownFromPod - create README.mkdn from POD

=head1 SYNOPSIS

    # in Makefile.PL
    use inc::Module::Install;
    name 'Some-Module';
    readme_markdown_from 'lib/Some/Module.pm';

=head1 DESCRIPTION

L<Module::Install::ReadmeMarkdownFromPod> is a L<Module::Install> extension
that generates a C<README.mkdn> file automatically from an indicated file
containing POD whenever the author runs C<Makefile.PL>. This file is used by
GitHub to display nicely formatted information about a repository.

=head1 FUNCTIONS

=over 4

=item C<readme_markdown_from>

Does nothing on the user-side. On the author-side it will generate a
C<README.mkdn> file using L<Pod::Markdown> from the POD in the file passed as
a parameter.

    readme_markdown_from 'lib/Some/Module.pm';

If a second parameter is set to a true value then the C<README.mkdn> will be
removed at C<make distclean>.

    readme_markdown_from 'lib/Some/Module.pm' => 'clean';

It will die unless a filename is given.

=item C<reference_module>

A utility function that saves you from repeatedly naming a reference module
from which to extract information.

    reference_module 'lib/Some/Module.pm';

is equivalent to:

    all_from 'lib/Some/Module.pm';
    readme_from 'lib/Some/Module.pm';
    readme_markdown_from 'lib/Some/Module.pm';

It will die unless a filename is given.

=back

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests through the web interface at
L<http://rt.cpan.org>.

=head1 INSTALLATION

See perlmodinstall for information and options on installing Perl modules.

=head1 AVAILABILITY

The latest version of this module is available from the Comprehensive Perl
Archive Network (CPAN). Visit L<http://www.perl.com/CPAN/> to find a CPAN site
near you. Or see
L<http://search.cpan.org/dist/Module-Install-ReadmeMarkdownFromPod/>.

The development version lives at
L<http://github.com/hanekomu/module-install-readmemarkdownfrompod/>.  Instead
of sending patches, please fork this project using the standard git and github
infrastructure.

=head1 AUTHORS

Marcel GrE<uuml>nauer, C<< <marcel@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 by Marcel GrE<uuml>nauer

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Pod::Markdown>

L<Module::Install>

L<Module::Install::ReadmeFromPod>

=cut
