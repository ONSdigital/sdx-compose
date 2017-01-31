#!/perl
use strict;

use Getopt::Long;
use LWP::UserAgent;
use HTTP::Request;


my $count = 0;
my $json  = '';
my $ftp   = 'pure-ftp-structure/EDC_QData';
my $host  = 'localhost';
my $port  = '80';
my $pollingResolution = '1'; # seconds

my $result = GetOptions(
  "count=i" => \$count,
  "json=s"  => \$json,
  "ftp=s"   => \$ftp,
  "port=i"  => \$port,
  "host=s"  => \$host,
  "poll=s"  => \$pollingResolution,
);
if (!$result or $count==0 or $json eq "") {
  print usage();
  exit 0;
}

my $counterCmd = 'find ' . $ftp . ' -type f | wc -l';

# Read in the json from the supplied file
if ( ! -e $json ) {
  die "Json file '$json' not found\n\n";
}

my $jsonData = slurpJson();
if (length $jsonData == 0) {
  die "Json file '$json' is empty\n\n";
}

my $startingCount = getCount();
my $expectedCount = $count + $startingCount;

my $pat="%-20s : %s\n";
printf $pat, "Data from", $json;
printf $pat, "No. of surveys", $count;
printf $pat, "Current ftp count", $startingCount;
printf $pat, "Expected count", $expectedCount;

print "Submitting (to http://$host:$port/) ... \n";
my $submission = buildSubmission();

# exec qq|curl http://$host:$port/ -X POST -d "$submission" -H "Content-Type: application/json"|;

my $ua = LWP::UserAgent->new();
$ua->agent("SDX-PerfTest/1.0");
$ua->timeout(1800);

my $req = HTTP::Request->new(POST => qq|http://$host:$port/|);
$req->content_type('application/json');
$req->content($submission);

my $start = time();
my $res = $ua->request($req);
if (!$res->is_success) {
  print "Failed to send to console: " . $res->status_line . "\n";
  exit 1;
}
print "Waiting for surveys in ftp ... \n";

my $percent=0;
my $pstr="=========================================================================";
while(1) {
  my $currentCount = getCount();

  my $duration = parseTime(time() - $start);
  chomp($duration);
  $percent = 100 * (($currentCount-$startingCount) / ($expectedCount-$startingCount));
  printf "\r%3d% : %-40s", ($currentCount*100/$expectedCount), $duration;#, $pstr;

  if ( $currentCount >= $expectedCount ) {
    last;
  }
  sleep $pollingResolution;
}

print "\nAll surveys found\n";
printf $pat, "Final count", getCount();
my $lastPat = $pat;
chomp $lastPat;
printf $lastPat . " seconds (+/- %d s)\n", "Complete in", parseTime(time() - $start), $pollingResolution;


exit 0;

sub usage {
    print "Usage: perl perf.pl --count 10 --json 023.203.json\n"
}

sub parseTime {
  return sprintf "%d hours, %d minutes, %d seconds\n",(gmtime $_[0])[2,1,0];
}

sub getCount  { int(`$counterCmd`) }

sub slurpJson {
  local $/ = undef;
  open (my $fh, "<$json") || die "Unable to open json file: $!\n\n";
  $jsonData = <$fh>;
  close $fh;
  # Remove newlines and compress
  $jsonData =~ s/\n//g;
  $jsonData =~ s/\",\s+(\S)/\",$1/g;
  $jsonData =~ s/\":\s+\"/\":\"/g;
  $jsonData =~ s/{\s+\"/{\"/g;
  $jsonData =~ s/\"\s+}/\"}/g;
  return $jsonData;
}

sub buildSubmission {
  return qq|{"quantity":"$count","survey":$jsonData}|;
}