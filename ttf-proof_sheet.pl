#!/usr/bin/perl

################################################################################
# Simple script to generate printable font proof sheets
# To Do: add font coverage printig
# https://github.com/abelcheung/font-coverage

use strict;
use warnings;
# use Data::Dump qw( dump );
use PDF::API2;

use constant mm => 25.4 / 72;
use constant in => 1 / 72;
use constant pt => 1;

use POSIX qw( strftime );
my $date = strftime("%Y-%m-%d %H:%M:%S", localtime(time));
my $dt = $date;
$dt =~ s/\D//g;

my ( $font_path, $pdf_output_path ) = @ARGV;

if (not defined $font_path) {
  print "'$0' needs some TTF file.\n";
  exit;
}
if (not defined $pdf_output_path) {
  print "You should indicate a PDF output path.\n";
  exit;
}

my $basic_alphabet = [ "0".."9", "A".."Z", "a".."z" ];
my $pangram1 = "The quick brown fox jumps over the lazy dog.",
my $pangram2 = "El veloz murciélago hindú comía feliz cardillo y kiwi. La cigüeña tocaba el saxofón detrás del palenque de paja. (Éste es usado para mostrar los estilos de letra en el sistema operativo.";
my $lorem = "Enim eugiamc ommodolor sendre feum zzrit at. Ut prat. Ut lum quisi.";
my $large_lorem = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus venenatis venenatis nisi, in lobortis velit auctor sed. Donec non sagittis ante. Nunc quis leo eu nisi cursus volutpat non vel libero. Pellentesque vel erat nibh. Praesent id orci tincidunt, consequat odio eget, cursus est. Vestibulum imperdiet gravida dolor, condimentum semper nunc lacinia varius. Nunc ac convallis augue.";
my $abc = join(" ", @{$basic_alphabet});

my $pdf = PDF::API2->new(
    -file => $pdf_output_path,
);

my $page = $pdf->page;
$page->mediabox( 105 / mm, 148 / mm );
# $page->bleedbox(  5/mm,   5/mm,  100/mm,  143/mm);
$page->cropbox( 7.5 / mm, 7.5 / mm, 97.5 / mm, 140.5 / mm );
# $page->artbox  ( 10/mm,  10/mm,   95/mm,  138/mm);

$pdf->preferences(
  -fitwindow => 1,
  -firstpage => [
    $page,
    -fit => 1,
  ]
);

my $font = $pdf->ttfont($font_path);
# To do: look for better formed name property in font objet
my $font_name = $font->{'BaseFont'}{'val'};
$font_name =~ s/  +/ /g;

my $black_box = $page->gfx;
$black_box->fillcolor('black');
$black_box->rect( 5 / mm, 125 / mm, 95 / mm, 18 / mm );
$black_box->fill;

my $gray_line = $page->gfx;
$gray_line->strokecolor('gray');
$gray_line->move( 5 / mm, 125 / mm );
$gray_line->line( 100 / mm, 125 / mm );
$gray_line->stroke;



my $headline_text = $page->text;
$headline_text->font( $font, 18 / pt );
$headline_text->fillcolor('white');
$headline_text->translate( 10 / mm, 131 / mm );
$headline_text->text($font_name);

my $subheadline_text = $page->text;
$subheadline_text->font( $font, 6 / pt );
$subheadline_text->fillcolor('darkgrey');
$subheadline_text->translate( 10 / mm, 127 / mm );
$subheadline_text->text($date);

# my $background = $page->text;
# $background->fillcolor('#E2E2E2');
# $background->font( $font, 180 / pt );
# $background->translate(20 / mm, 31 / mm );
# $background->rotate(45);
# $background->text($font_name);

my $lead = $page->text;
$lead ->font( $font, 20 / pt );
$lead ->fillcolor('black');
my ( $endw, $ypos, $paragraph ) = text_block(
    $lead ,
    $abc,
    -x        => 10 / mm,
    -y        => 116 / mm,
    -w        => 85 / mm,
    -h        => 120 / mm - 7 / pt,
    -lead     => 22 / pt,
    -parspace => 0 / pt,
    -align    => 'left',
);

my $gray_line2 = $page->gfx;
$gray_line2->strokecolor('gray');
$gray_line2->move( 10 / mm, 82 / mm );
$gray_line2->line( 95 / mm, 82 / mm );
$gray_line2->stroke;

# Left Column
my $left_column_text = $page->text;
$left_column_text->font( $font, 16 / pt );
$left_column_text->fillcolor('#2F2F2F');
( $endw, $ypos, $paragraph ) = text_block(
    $left_column_text,
    $lorem,
    -x => 10 / mm,
    -y => $ypos - 4 / pt,
    -w => 55 / mm,
    -h => 110 / mm - ( 119 / mm - $ypos ),
    -lead     => 14 / pt,
    -parspace => 0 / pt,
    -align    => 'left',
);

$left_column_text->font( $font, 12 / pt );
$left_column_text->fillcolor('black');
( $endw, $ypos, $paragraph ) = text_block(
    $left_column_text,
    $pangram1,
    -x => 10 / mm,
    -y => $ypos - 6 / pt,
    -w =>55 / mm,
    -h => 110 / mm - ( 119 / mm - $ypos ),
    -lead     => 12 / pt,
    -parspace => 0 / pt,
    -align    => 'center',
);

$left_column_text->font( $font, 10 / pt );
$left_column_text->fillcolor('black');
( $endw, $ypos, $paragraph ) = text_block(
    $left_column_text,
    $lorem,
    -x => 10 / mm,
    -y => $ypos - 6 / pt,
    -w => 55 / mm,
    -h => 110 / mm - ( 119 / mm - $ypos ),
    -lead     => 12 / pt,
    -parspace => 0 / pt,
    -align    => 'left',
);

$left_column_text->font( $font, 8 / pt );
$left_column_text->fillcolor('black');
( $endw, $ypos, $paragraph ) = text_block(
    $left_column_text,
    $large_lorem,
    -x => 10 / mm,
    -y => $ypos - 4 / pt,
    -w => 55 / mm,
    -h => 110 / mm - ( 119 / mm - $ypos ),
    -lead     => 9 / pt,
    -parspace => 0 / pt,
    -align    => 'left',
);

# Right Column
my $right_column_text = $page->text;
$right_column_text->font( $font, 6 / pt );
$right_column_text->fillcolor('black');
( $endw, $ypos, $paragraph ) = text_block(
    $right_column_text,
    $large_lorem,
    -x        => 68 / mm,
    -y        => 78 / mm,
    -w        => 27 / mm,
    -h        => 54 / mm,
    -lead     => 7 / pt,
    -parspace => 0 / pt,
    -align    => 'justify',
);

$right_column_text = $page->text;
$right_column_text->font( $font, 4 / pt );
$right_column_text->fillcolor('black');
( $endw, $ypos, $paragraph ) = text_block(
    $right_column_text,
    $large_lorem,
    -x        => 68 / mm,
    -y        => $ypos - 2 / pt,
    -w        => 27 / mm,
    -h        => 54 / mm,
    -lead     => 5 / pt,
    -parspace => 0 / pt,
    -align    => 'right',
);
$right_column_text = $page->text;
$right_column_text->font( $font, 3 / pt );
$right_column_text->fillcolor('black');
( $endw, $ypos, $paragraph ) = text_block(
    $right_column_text,
    $large_lorem,
    -x        => 68 / mm,
    -y        => $ypos - 2 / pt,
    -w        => 27 / mm,
    -h        => 54 / mm,
    -lead     => 4 / pt,
    -parspace => 0 / pt,
    -align    => 'justify',
);
$right_column_text = $page->text;
$right_column_text->font( $font, 2 / pt );
$right_column_text->fillcolor('black');
( $endw, $ypos, $paragraph ) = text_block(
    $right_column_text,
    $large_lorem,
    -x        => 68 / mm,
    -y        => $ypos - 2 / pt,
    -w        => 27 / mm,
    -h        => 54 / mm,
    -lead     => 3 / pt,
    -parspace => 0 / pt,
    -align    => 'left',
);

$pdf->save;
$pdf->end();

# Auto lines brakes function
# http://rick.measham.id.au/pdf-api2/
sub text_block {

    my $text_object = shift;
    my $text        = shift;

    my %arg = @_;
    #print $text;

    # Get the text in paragraphs
    my @paragraphs = split( /\n/, $text );
    # calculate width of all words
    my $space_width = $text_object->advancewidth(' ');

    my @words = split( /\s+/, $text );
    # cambio espacio por nonchar
    #my @words = split( /^\w/, $text );

    my %width = ();
    foreach (@words) {
        next if exists $width{$_};
        $width{$_} = $text_object->advancewidth($_);
    }

    $ypos = $arg{'-y'};
    my @paragraph = split( /\s+/, shift(@paragraphs) );

    my $first_line      = 1;
    my $first_paragraph = 1;

    # while we can add another line

    while ( $ypos >= $arg{'-y'} - $arg{'-h'} + $arg{'-lead'} ) {

        unless (@paragraph) {
            last unless scalar @paragraphs;

            @paragraph = split( /\s+/, shift(@paragraphs) );

            $ypos -= $arg{'-parspace'} if $arg{'-parspace'};
            last unless $ypos >= $arg{'-y'} - $arg{'-h'};

            $first_line      = 1;
            $first_paragraph = 0;
        }

        my $xpos = $arg{'-x'};

        # while there's room on the line, add another word
        my @line = ();

        my $line_width = 0;
        if ( $first_line && exists $arg{'-hang'} ) {

            my $hang_width = $text_object->advancewidth( $arg{'-hang'} );

            $text_object->translate( $xpos, $ypos );
            $text_object->text( $arg{'-hang'} );

            $xpos       += $hang_width;
            $line_width += $hang_width;
            $arg{'-indent'} += $hang_width if $first_paragraph;

        }
        elsif ( $first_line && exists $arg{'-flindent'} ) {

            $xpos       += $arg{'-flindent'};
            $line_width += $arg{'-flindent'};

        }
        elsif ( $first_paragraph && exists $arg{'-fpindent'} ) {

            $xpos       += $arg{'-fpindent'};
            $line_width += $arg{'-fpindent'};

        }
        elsif ( exists $arg{'-indent'} ) {

            $xpos       += $arg{'-indent'};
            $line_width += $arg{'-indent'};

        }

        while ( @paragraph
            and $line_width + ( scalar(@line) * $space_width ) +
            $width{ $paragraph[0] } < $arg{'-w'} )
        {

            $line_width += $width{ $paragraph[0] };
            push( @line, shift(@paragraph) );

        }

        # calculate the space width
        my ( $wordspace, $align );
        if ( $arg{'-align'} eq 'fulljustify'
            or ( $arg{'-align'} eq 'justify' and @paragraph ) )
        {

            if ( scalar(@line) == 1 ) {
                @line = split( //, $line[0] );

            }
            $wordspace = ( $arg{'-w'} - $line_width ) / ( scalar(@line) - 1 );

            $align = 'justify';
        }
        else {
            $align = ( $arg{'-align'} eq 'justify' ) ? 'left' : $arg{'-align'};

            $wordspace = $space_width;
        }
        $line_width += $wordspace * ( scalar(@line) - 1 );

        if ( $align eq 'justify' ) {
            foreach my $word (@line) {

                $text_object->translate( $xpos, $ypos );
                $text_object->text($word);

                $xpos += ( $width{$word} + $wordspace ) if (@line);

            }
            $endw = $arg{'-w'};
        }
        else {

            # calculate the left hand position of the line
            if ( $align eq 'right' ) {
                $xpos += $arg{'-w'} - $line_width;

            }
            elsif ( $align eq 'center' ) {
                $xpos += ( $arg{'-w'} / 2 ) - ( $line_width / 2 );

            }

            # render the line
            $text_object->translate( $xpos, $ypos );

            $endw = $text_object->text( join( ' ', @line ) );

        }
        $ypos -= $arg{'-lead'};
        $first_line = 0;

    }
    unshift( @paragraphs, join( ' ', @paragraph ) ) if scalar(@paragraph);

    return ( $endw, $ypos, join( "\n", @paragraphs ) )

}


# my %font = (
#     Helvetica => {
#         Bold   => $pdf->corefont( 'Helvetica-Bold',    -encoding => 'latin1' ),
#         Roman  => $pdf->corefont( 'Helvetica',         -encoding => 'latin1' ),
#         Italic => $pdf->corefont( 'Helvetica-Oblique', -encoding => 'latin1' ),
#     },
#     Times => {
#         Bold   => $pdf->corefont( 'Times-Bold',   -encoding => 'latin1' ),
#         Roman  => $pdf->corefont( 'Times',        -encoding => 'latin1' ),
#         Italic => $pdf->corefont( 'Times-Italic', -encoding => 'latin1' ),
#     },
# );
