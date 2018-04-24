# call with ARGV[0] and ARGV[1] as student per school count and school count

use Data::GUID::Any 'guid_as_string';
use Data::Random::Contact;
use Data::Random::WordList;
use String::Random;
use POSIX;
use Algorithm::LUHN qw(check_digit);
use MIME::Base64;
use Storable qw(dclone);
use List::Compare;
use Text::Lorem;

my $lorem = Text::Lorem->new();
my $randomizer = Data::Random::Contact->new();
my $string_gen = String::Random->new;
my $random_word = new Data::Random::WordList( wordlist => '/usr/share/dict/words' );
my @emojis = ("&#x1f638;", "&#x1f63e;", "&#x1f63f;");

my $previtemrefid = $previtemlocalid = '';

my @domainsLC = (
"Reading", "Writing", "Numeracy", "Grammar and Punctuation", "Spelling"
);

my @domainsLC_tests = (
"Reading", "Writing", "Writing_alt", "Numeracy", "Grammar and Punctuation", "Spelling"
);

my @testlevels = (3, 5, 7, 9);
my @nodesRWN = qw(A B C D E F);
my @nodesLC = qw(C E F S1 S2 S3 P1 P2);
my @nodesLCS = qw(S1 S2 S3);
my @nodesLCGP = qw(C E F P1 P2);
my @nodesW = qw(Blank);
my @valid_node_pathways = ( 
	['A', 'B', 'C'],
	['A', 'B', 'E'],
	['A', 'B', 'F'],
	['A', 'D', 'C'],
	['A', 'D', 'E'],
	['A', 'D', 'F'],
	['A', 'C', 'B'],
);
my @pnp_codes = qw(AIA AIM AIV AST AAM AVM ALL COL BRA OSS RBK SCR SUP);
my @pnp_extratime = qw(ETA ETB ETC);
my @pnp_unlockedbrowser = qw(AST COL);
my @pnp_nosystemaction = qw(SUP OSS SCR BRK BRA);
my @item_types = qw(ET HS HT IA IC IGA IGGM IGM IGO IM IO MC MCS PO SL SP TE CO);
my @item_types_remainder = qw(ET HS HT IA IC IGA IGGM IGM IGO IM IO MCS PO SL SP CO);
my @writing_rubrics = (
"Text Structure", "Ideas", "Persuasive Devices", "Character and Setting", "Vocabulary", "Cohesion", "Paragraphing", "Sentence Structure", "Punctuation", "Spelling");

my %testletcountpernode = (A => 2, B => 2, D => 2, E => 2, C => 1, F => 1, Blank => 1,
Clc => 2, Elc => 2, Flc => 2, S1 => 2, S2 => 2, S3 => 2, P1 => 2, P2 => 2);
my $studentsperschool = $ARGV[0];
my $schoolcount = $ARGV[1];
my %yearlevel_averages = (3 => 390, 5 => 500, 7 => 550, 9 => 580);

=pod=
$studentsperschool = 2;
$schoolcount = 2;
@testlevels = (3);
%testletcountpernode = (A => 1, B => 1, D => 1, E => 1, C => 1, F => 1, Clc => 1, Elc => 1, Flc => 1, S1 => 1, S2 => 1, S3 => 1, P1 => 1, P2 => 1);
=cut=

my $randomizer = Data::Random::Contact->new();

	# we will base our students and schools off existing csv file
	open F, "<$ARGV[0]";
	<F>;
	while(<F>) {
		@a = split m/,/;

	}

@schoolnames = $random_word->get_words($schoolcount);
for ($i=0; $i < $schoolcount; $i++) {
$school[$i] = {LOCALID => 'x7286' . $i , ACARAID =>  21212 + $i, GUID => lc guid_as_string(), NAME => ucfirst $schoolnames[$i]};
}

open F, ">sif.xml";
print F "<sif>";
foreach $s (@school) {
printf F qq{
  <SchoolInfo xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" RefId="%s" xmlns="http://www.sifassociation.org/datamodel/au/3.4">
  <LocalId>%s</LocalId>
  <StateProvinceId xsi:nil="true" />
  <CommonwealthId xsi:nil="true" />
  <ACARAId>%s</ACARAId>
  <OtherIdList xsi:nil="true" />
  <SchoolName>%s Secondary College</SchoolName>
  <LEAInfoRefId xsi:nil="true" />
  <OtherLEA xsi:nil="true" />
  <SchoolDistrict xsi:nil="true" />
  <SchoolDistrictLocalId xsi:nil="true" />
  <SchoolFocusList xsi:nil="true" />
  <SchoolURL xsi:nil="true" />
  <SchoolEmailList xsi:nil="true" />
  <PrincipalInfo xsi:nil="true" />
  <SchoolContactList xsi:nil="true" />
  <AddressList>
    <Address Type="0123" Role="012A">
      <StateProvince />
      <GridLocation xsi:nil="true" />
      <MapReference xsi:nil="true" />
      <RadioContact xsi:nil="true" />
      <Community xsi:nil="true" />
      <LocalId xsi:nil="true" />
      <AddressGlobalUID xsi:nil="true" />
      <StatisticalAreas xsi:nil="true" />
    </Address>
  </AddressList>
  <PhoneNumberList xsi:nil="true" />
  <YearLevels xsi:nil="true" />
  <Campus xsi:nil="true" />
  <SchoolSector>NG</SchoolSector>
  <LocalGovernmentArea xsi:nil="true" />
  <JurisdictionLowerHouse xsi:nil="true" />
  <YearLevelEnrollmentList xsi:nil="true" />
  <TotalEnrollments xsi:nil="true" />
  <SchoolGroupList xsi:nil="true" />
  <SIF_Metadata xsi:nil="true" />
  <SIF_ExtendedElements xsi:nil="true" />
</SchoolInfo>
}, 
$$s{GUID},
$$s{LOCALID},
$$s{ACARAID},
$$s{NAME},
;
}


for ($j=0;$j<$schoolcount;$j++){
for ($i=0;$i<$studentsperschool;$i++){

$refid = lc guid_as_string();
$psi = psi('R', '1', $studentsperschool*$j+$i);
my $person = $randomizer->person();
$$person{'address'}{'home'}{'street_1'} =~ s/\&/\&amp;/g;

my $yearlevel = ceil(rand(4))*2+1;
my $localid =  ceil(rand(1000000000));

printf F qq{<StudentPersonal xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" RefId="%s" xmlns="http://www.sifassociation.org/datamodel/au/3.4">
  <AlertMessages xsi:nil="true" />
  <MedicalAlertMessages xsi:nil="true" />
  <LocalId>%s</LocalId>
  <StateProvinceId />
  <ElectronicIdList xsi:nil="true" />
  <OtherIdList>
    <OtherId Type="JurisdictionId">9</OtherId>
    <OtherId Type="SectorStudentId">%s</OtherId>
    <OtherId Type="DiocesanStudentId"></OtherId>
    <OtherId Type="TAAStudentId">%s</OtherId>
    <OtherId Type="OtherStudentId">%s</OtherId>
    <OtherId Type="NationalStudentId"></OtherId>
    <OtherId Type="PreviousLocalStudentId"></OtherId>
    <OtherId Type="PreviousSectorStudentId"></OtherId>
    <OtherId Type="PreviousDiocesanStudentId"></OtherId>
    <OtherId Type="PreviousOtherStudentId"></OtherId>
    <OtherId Type="PreviousTAAStudentId"></OtherId>
    <OtherId Type="PreviousNationalStudentId"></OtherId>
    <OtherId Type="PreviousNAPPlatformStudentId"></OtherId>
    <OtherId Type="NAPPlatformStudentId">%s</OtherId>
    <OtherId Type="PreviousJurisdictionStudentId"></OtherId>
    <OtherId Type="OtherSchoolId"></OtherId>
    <OtherId Type="Locality"></OtherId>
    <OtherId Type="DOBRange">true</OtherId>
    <OtherId Type="PersonalDetailsChanged">false</OtherId>
    <OtherId Type="PossibleDuplicate">false</OtherId>
    <OtherId Type="PsiOtherIdMismatch">false</OtherId>
  </OtherIdList>
  <PersonInfo>
    <Name Type="LGL">
      <Title xsi:nil="true" />
      <FamilyName>%s</FamilyName>
      <GivenName>%s</GivenName>
      <MiddleName xsi:nil="true" />
      <PreferredFamilyName xsi:nil="true" />
      <PreferredGivenName xsi:nil="true" />
      <Suffix xsi:nil="true" />
      <FullName xsi:nil="true" />
    </Name>
    <OtherNames xsi:nil="true" />
    <Demographics>
      <IndigenousStatus>%d</IndigenousStatus>
      <Sex>%d</Sex>
      <BirthDate>%s</BirthDate>
      <PlaceOfBirth xsi:nil="true" />
      <StateOfBirth xsi:nil="true" />
      <CountryOfBirth>%04d</CountryOfBirth>
      <CountriesOfCitizenship xsi:nil="true" />
      <CountriesOfResidency xsi:nil="true" />
      <EnglishProficiency xsi:nil="true" />
      <LanguageList>
        <Language>
          <Code>%04d</Code>
          <OtherCodeList xsi:nil="true" />
          <Dialect xsi:nil="true" />
        </Language>
      </LanguageList>
      <DwellingArrangement xsi:nil="true" />
      <Religion xsi:nil="true" />
      <ReligiousEventList xsi:nil="true" />
      <ReligiousRegion xsi:nil="true" />
      <VisaSubClass />
      <VisaStatisticalCode xsi:nil="true" />
      <VisaSubClassList xsi:nil="true" />
    </Demographics>
    <AddressList>
      <Address Type="0123" Role="012A">
        <Street>
          <Line1 />
          <Line2 />
          <Line3 xsi:nil="true" />
          <Complex xsi:nil="true" />
          <StreetNumber xsi:nil="true" />
          <StreetPrefix xsi:nil="true" />
          <StreetName xsi:nil="true" />
          <StreetType xsi:nil="true" />
          <StreetSuffix xsi:nil="true" />
          <ApartmentType xsi:nil="true" />
          <ApartmentNumberPrefix xsi:nil="true" />
          <ApartmentNumber xsi:nil="true" />
          <ApartmentNumberSuffix xsi:nil="true" />
        </Street>
        <City />
        <StateProvince />
        <PostalCode />
        <GridLocation xsi:nil="true" />
        <MapReference xsi:nil="true" />
        <RadioContact xsi:nil="true" />
        <Community xsi:nil="true" />
        <LocalId xsi:nil="true" />
        <AddressGlobalUID xsi:nil="true" />
        <StatisticalAreas xsi:nil="true" />
      </Address>
    </AddressList>
    <PhoneNumberList xsi:nil="true" />
    <EmailList xsi:nil="true" />
    <HouseholdContactInfoList xsi:nil="true" />
  </PersonInfo>
  <MostRecent>
    <SchoolLocalId />
    <HomeroomLocalId xsi:nil="true" />
    <YearLevel>
      <Code>%s</Code>
    </YearLevel>
    <Parent1Language>%04d</Parent1Language>
    <Parent2Language>%04d</Parent2Language>
    <Parent1EmploymentType>%d</Parent1EmploymentType>
    <Parent2EmploymentType>%d</Parent2EmploymentType>
    <Parent1SchoolEducationLevel>%d</Parent1SchoolEducationLevel>
    <Parent2SchoolEducationLevel>%d</Parent2SchoolEducationLevel>
    <Parent1NonSchoolEducation>%d</Parent1NonSchoolEducation>
    <Parent2NonSchoolEducation>%d</Parent2NonSchoolEducation>
    <LocalCampusId />
    <SchoolACARAId>%s</SchoolACARAId>
    <TestLevel>
      <Code>%d</Code>
    </TestLevel>
    <Homegroup xsi:nil="true" />
    <ClassCode>%s</ClassCode>
    <FFPOS>%s</FFPOS>
    <ReportingSchoolId />
    <OtherEnrollmentSchoolACARAId />
  </MostRecent>
  <PrePrimaryEducation xsi:nil="true" />
  <SIF_Metadata xsi:nil="true" />
  <SIF_ExtendedElements xsi:nil="true" />
</StudentPersonal>
}, 
$refid, 
$localid,
ceil(rand(100000)),
$localid,
ceil(rand(100000)),
$psi,
$$person{'surname'} ,
$$person{'given'},
ceil(rand(4)),
$$person{'gender'} eq 'male' ? 1 : 2,
dateofbirth($yearlevel),
country(),
language(),
$yearlevel,
language(),
language(),
rand(4)+1,
rand(4)+1,
rand(4)+1,
rand(4)+1,
rand(4)+5,
rand(4)+5,
$school[$j]{'ACARAID'},
$yearlevel,
$yearlevel . chr(ord('A') + rand(6)),
ceil(rand(2)),
;

push @{$students{$j}{$yearlevel}}, {GUID => $refid, PSI => $psi};


}}




$j = 0;
foreach $testlevel (@testlevels) {
foreach $domain (@domainsLC_tests) {

    $refid = lc guid_as_string();
    $localid = sprintf "x0010680%d_%s", ++$j, $domain;
    $domain_out = $domain;
    $domain_out =~ s/_alt//;
    next if $domain_out eq 'Writing' and $testlevel == 3;
    
    printf F qq{<NAPTest xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" RefId="%s" xmlns="http://www.sifassociation.org/datamodel/au/3.4">
  <TestContent>
    <NAPTestLocalId>%s</NAPTestLocalId>
    <TestName>%s Year %s</TestName>
    <TestLevel>
      <Code>%s</Code>
    </TestLevel>
    <TestType>Normal</TestType>
    <Domain>%s</Domain>
    <TestYear>2017</TestYear>
    <StagesCount>%d</StagesCount>
    <DomainBands>
      <Band1Lower>0</Band1Lower>
      <Band1Upper>258</Band1Upper>
      <Band2Lower>259</Band2Lower>
      <Band2Upper>318</Band2Upper>
      <Band3Lower>319</Band3Lower>
      <Band3Upper>368</Band3Upper>
      <Band4Lower>369</Band4Lower>
      <Band4Upper>417</Band4Upper>
      <Band5Lower>418</Band5Lower>
      <Band5Upper>466</Band5Upper>
      <Band6Lower>467</Band6Lower>
      <Band6Upper>526</Band6Upper>
      <Band7Lower>527</Band7Lower>
      <Band7Upper>574</Band7Upper>
      <Band8Lower>575</Band8Lower>
      <Band8Upper>633</Band8Upper>
      <Band9Lower>634</Band9Lower>
      <Band9Upper>681</Band9Upper>
      <Band10Lower>682</Band10Lower>
      <Band10Upper>999</Band10Upper>
    </DomainBands>
    <DomainProficiency>
       <Level1Lower>10</Level1Lower>
       <Level1Upper>500</Level1Upper>
       <Level2Lower>500</Level2Lower>
       <Level2Upper>700</Level2Upper>
       <Level3Lower>700</Level3Lower>
       <Level3Upper>900</Level3Upper>
       <Level4Lower>0</Level4Lower>
       <Level4Upper>0</Level4Upper>
    </DomainProficiency>
  </TestContent>
  <SIF_Metadata xsi:nil="true" />
  <SIF_ExtendedElements xsi:nil="true" />
</NAPTest>
},
    $refid,
    $localid,
    $domain_out,
    $testlevel, 
    $testlevel,
    $domain_out,
    $domain eq 'Spelling' ? 2 : 3;
    
    $naptests{$domain}{$testlevel} = {GUID => $refid, LOCALID => $localid};

}}

$asset = 0;

print F qq{<NAPTestlets xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://www.sifassociation.org/datamodel/au/3.4">};

foreach $domain (sort keys %naptests) {
foreach $testlevel (sort keys %{$naptests{$domain}}) {
  $domain_out = $domain;
  if($domain_out eq 'Writing_alt'){
$domain_out;
  }
  $domain_out =~ s/_alt//;
my @localnodes = @nodesRWN;
@localnodes = @nodesLCS if $domain_out eq 'Spelling';
@localnodes = @nodesLCGP if $domain_out eq 'Grammar and Punctuation';
@localnodes = @nodesW if $domain_out eq 'Writing';

foreach $node (@localnodes) {
for($i = 0; $i < $testletcountpernode{$node}; $i++) {

    $refid = lc guid_as_string();
    $naptestlet_refids{$domain}{$testlevel}{$node}[$i] = $refid;
    # $localid = sprintf "%s-%s-%02d", $naptests{$domain}{$testlevel}{LOCALID}, $node, $i;
    $localid = sprintf "x001%05d", ++$asset;
    $items = '';
	for($j = 0; $j < itempertestlet($testlevel, $node); $j++) {
    	$itemrefid = lc guid_as_string();
		$itemlocalid = sprintf "x001%05d", ++$asset;
		# cross linkages
		my $replaceitem = 0;
		if($domain_out eq 'Reading') {
			if($testlevel > 3 && $j >= itempertestlet($testlevel, $node)/2 && ($node eq 'A' or $node eq 'B')) {
				$link_testlet =  $naptestlet_refids{$domain}{$testlevel-2}{$node eq 'A' ? 'D' : 'E'}[$i];
				my $x = $naptestitem{$link_testlet}[$j-itempertestlet($testlevel, $node)/2];
				$itemrefid = $$x{GUID};
				if (!$itemrefid) {
				print STDERR "ALERT!\n" ;
				}
				$itemlocalid = $$x{LOCALID};
				$replaceitem = 1;
			}
		}
		if($domain_out eq 'Numeracy') {
			if($testlevel > 3 && $j < itempertestlet($testlevel-2, $node)/2 && ($node eq 'A' )) {
				$link_testlet =  $naptestlet_refids{$domain}{$testlevel-2}{'A'}[$i];
				my $x = $naptestitem{$link_testlet}[$j+itempertestlet($testlevel-2, $node)/2];
				$itemrefid = $$x{GUID};
				if (!$itemrefid) {
				print STDERR "ALERT2!\n" ;
				}
				$itemlocalid = $$x{LOCALID};
				$replaceitem = 1;
			}
            if($testlevel > 3 && $j >= itempertestlet($testlevel, $node)/2 && ($node eq 'B')) {
				$link_testlet =  $naptestlet_refids{$domain}{$testlevel-2}{'E'}[$i];
				my $x = $naptestitem{$link_testlet}[$j-itempertestlet($testlevel, $node)/2];
				$itemrefid = $$x{GUID};
				if (!$itemrefid) {
				print STDERR "ALERT3!\n" ;
				}
				$itemlocalid = $$x{LOCALID};
				$replaceitem = 1;
			}		
		}


		push @{$naptestitem{$refid}}, {GUID => $itemrefid, LOCALID => $itemlocalid, SEQ => $j, TOTAL => itempertestlet($testlevel, $node)};
	    $itemlist{$itemrefid}{LOCALID} = $itemlocalid;
	    $itemlist{$itemrefid}{DOMAIN} = $domain;
	    $itemlist{$itemrefid}{TESTLEVEL} = $testlevel;
	    $itemlist{$itemrefid}{TYPE} =  item_type($node);
	    $itemlist{$itemrefid}{NODE} =  $node;
	    $itemlist{$itemrefid}{RELEASED} = ($node =~ m#^(A|B|E)$# && $i == 0);
            $itemlist{$itemrefid}{ANSWER} = response("", $itemlist{$itemrefid}{TYPE}, "", $domain);


	      push @{$itemlist{$itemrefid}{TESTLET}}, {REFID => $refid, LOCALID => $localid, SEQ => $j, NODE =>  $node, TESTLETNO => $i};
		
		
		
		$items .= sprintf qq{    <TestItem>
      <TestItemRefId>%s</TestItemRefId>
      <TestItemLocalId>%s</TestItemLocalId>
      <SequenceNumber>%d</SequenceNumber>
    </TestItem>
}, $itemrefid, $itemlocalid, $j+1;


		# add substitute items
		if($domain_out eq 'Numeracy' && $j == itempertestlet($testlevel, $node) - 1) {
			foreach $p (qw(AIM AVM ALL)) {
    		$itemrefid2 = lc guid_as_string();
                $itemlocalid2 = sprintf "x001%05d", ++$asset;
            $itemlist{$itemrefid2}{LOCALID} = $itemlocalid2;
            $itemlist{$itemrefid2}{DOMAIN} = $domain;
	        $itemlist{$itemrefid2}{TYPE} =  item_type($node);
            $itemlist{$itemrefid2}{TESTLEVEL} = $testlevel;
            $itemlist{$itemrefid2}{ANSWER} = response("", $itemlist{$itemrefid2}{TYPE}, "", $domain);
		push @{$naptestitem{$refid}}, {GUID => $itemrefid2, LOCALID => $itemlocalid2, SEQ => $j, TOTAL => itempertestlet($testlevel, $node)};
              push @{$itemlist{$itemrefid2}{TESTLET}}, {REFID => $refid, LOCALID => $localid, SEQ => $j, NODE =>  $node, TESTLETNO => $i};
		    push @{$itemlist{$itemrefid}{SUBSTITUTED}} , {REFID => $itemrefid2, LOCALID => $itemlocalid2, PNP => [$p]};
		    push @{$itemlist{$itemrefid2}{SUBSTITUTES}} , {REFID => $itemrefid, LOCALID => $itemlocalid, PNP => [$p]};
		    }	   
	    }
		if($domain_out eq 'Spelling' && $node eq 'S1') {
		    if($j==0){
    		    $previtemrefid = $itemrefid;
		        $previtemlocalid = $itemlocalid;
		    }
		    # store the first item, and have it be the substitute for the next item as well
    		$itemrefid2 = lc guid_as_string();
		    $itemlocalid2 = sprintf ("%s-%02d-AIA", $localid, $j);
		    
            $itemlist{$itemrefid2}{LOCALID} = $itemlocalid2;
            $itemlist{$itemrefid2}{DOMAIN} = $domain;
	        $itemlist{$itemrefid2}{TYPE} =  item_type($node);
            $itemlist{$itemrefid2}{TESTLEVEL} = $testlevel;
              push @{$itemlist{$itemrefid2}{TESTLET}}, {REFID => $refid, LOCALID => $localid, SEQ => $j, NODE =>  $node, TESTLETNO => $i};
		    push @{$itemlist{$itemrefid}{SUBSTITUTED}} , {REFID => $itemrefid2, LOCALID => $itemlocalid2, PNP => ["AIA"]};
		    push @{$itemlist{$itemrefid2}{SUBSTITUTES}} , {REFID => $itemrefid, LOCALID => $itemlocalid, PNP => ["AIA"]};
		    if($j==1) {
		        push @{$itemlist{$itemrefid2}{SUBSTITUTES}} , {REFID => $previtemrefid, LOCALID => $previtemlocalid, PNP => ["AIA"]} ;
		        push @{$itemlist{$previtemrefid}{SUBSTITUTED}} , {REFID => $itemrefid2, LOCALID => $itemlocalid2, PNP => ["AIA"]} ;
		    } else {
		push @{$naptestitem{$refid}}, {GUID => $itemrefid2, LOCALID => $itemlocalid2, SEQ => $j, TOTAL => itempertestlet($testlevel, $node)};
	}
		    
		}

	}

$testletsubscore = itempertestlet($testlevel, $node);
my $testletname = sprintf "%s%d", $node, $i+1;

my $testletrulelist = testletrulelist($node);

printf F qq{
<NAPTestlet RefId="%s">
  <NAPTestRefId>%s</NAPTestRefId>
  <NAPTestLocalId>%s</NAPTestLocalId>
  <TestletContent>
    <NAPTestletLocalId>%s</NAPTestletLocalId>
    <TestletName>%s</TestletName>
    %s
    %s
    <TestletMaximumScore>%d</TestletMaximumScore>
  </TestletContent>
  <TestItemList>
%s  </TestItemList>
  <SIF_Metadata xsi:nil="true" />
  <SIF_ExtendedElements xsi:nil="true" />
</NAPTestlet>},
$refid,
$naptests{$domain}{$testlevel}{GUID},
$naptests{$domain}{$testlevel}{LOCALID},
$localid,
$testletname,
#node2domain($node, $domain),
print_node($node), 
($node == 'Blank' ? '<LocationInStage xsi:nil="true" />' : sprintf("<LocationInStage>%d</LocationInStage>", $i+1)),
$testletsubscore,
#0.8 * $testletsubscore,
#0.5 * $testletsubscore,
#0.7 * $testletsubscore,
#0.6 * $testletsubscore,
#0.8 * $testletsubscore,
#0.5 * $testletsubscore,
#0.7 * $testletsubscore,
#0.6 * $testletsubscore,
#$testletrulelist,
$items,
;

push @{$naptestlet{$domain}{$testlevel}{$node}}, {GUID => $refid, LOCALID => $localid, NAME => $testletname, SUBSCORE => $testletsubscore, RULES => $testletrulelist};

}}}}
print F "\n</NAPTestlets>\n";


printf F qq{<NAPTestItems xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://www.sifassociation.org/datamodel/au/3.4">};


foreach $refid (keys  %itemlist) {

    #$refid = $$i{GUID};
    #$localid = $$i{LOCALID};
    $localid = $itemlist{$refid}{LOCALID};
    $domain = $itemlist{$refid}{DOMAIN};
    $domain_out = $domain;
    $domain_out =~ s/_alt//;
    $main_item_type = $itemlist{$refid}{TYPE};
    my $stimulus1id = $string_gen->randregex('[a-z]{5}\d{3}');
    $stimulus1 = stimulus( $stimulus1id, 
        rand() < .7 ? 'Text' : 'Image', $domain_out, $itemlist{$refid}{TESTLET}[0]{NODE});
    $stimulus2 = $stimulus2id = "";
    if($itemlist{$refid}{SEQ} > $itemlist{$refid}{TOTAL}/2 and 
    $itemlist{$refid}{TESTLET}[0]{NODE} ne 'S1') {
        $stimulus2id = $string_gen->randregex('[a-z]{5}\d{3}');
        $stimulus2 = stimulus( $stimulus2id, 
            rand() < .7 ? 'Text' : 'Image', $domain_out, $itemlist{$refid}{TESTLET}[0]{NODE})
   	}
    $stimulus = sprintf qq{<StimulusList>    %s%s
    </StimulusList>}, $stimulus1, $stimulus2;
    if($stimulus) {
        if($stimulus2id) {
            $itemlist{$refid}{STIMULI} = $stimulus1id . ',' . $stimulus2id;
        } else {
            $itemlist{$refid}{STIMULI} = $stimulus1id ;
        }
    }
    $stimulus = '<StimulusList xsi:nil="true" />' unless ($domain_out eq 'Reading' or $domain_out eq 'Writing' or
        ($domain_out eq 'Spelling' and $itemlist{$refid}{TESTLET}[0]{NODE} eq 'S1'));
    $rubrics = qq{\n    <NAPWritingRubricList xsi:nil="true" />};
    if($domain_out eq 'Writing') {
      $rubrics = qq{
            <NAPWritingRubricList>
              <NAPWritingRubric>
                <RubricType>Audience</RubricType>
                <ScoreList>
                  <Score>
                    <MaxScoreValue>6</MaxScoreValue>
                    <ScoreDescriptionList>
                      <ScoreDescription>
                        <ScoreValue>0</ScoreValue>
                        <Descriptor>Text cannot be read meaningfully.</Descriptor>
                      </ScoreDescription>
                      <ScoreDescription>
                        <ScoreValue>1</ScoreValue>
                        <Descriptor>Text contains some simple readable content with limited response to audience needs.</Descriptor>
                      </ScoreDescription>
                      <ScoreDescription>
                        <ScoreValue>2</ScoreValue>
                        <Descriptor>Text can be read and provides some information to support reader understanding.</Descriptor>
                      </ScoreDescription>
                      <ScoreDescription>
                        <ScoreValue>3</ScoreValue>
                        <Descriptor>Persuasive text is internally consistent and contains sufficient information for the reader to follow it fairly easily.</Descriptor>
                      </ScoreDescription>
                      <ScoreDescription>
                        <ScoreValue>4</ScoreValue>
                        <Descriptor>Persuasive text supports reader understanding and begins to engage the reader.</Descriptor>
                      </ScoreDescription>
                      <ScoreDescription>
                        <ScoreValue>5</ScoreValue>
                        <Descriptor>Persuasive text supports, engages and persuades the reader through deliberate choice of language and use of persuasive techniques.</Descriptor>
                      </ScoreDescription>
                      <ScoreDescription>
                        <ScoreValue>6</ScoreValue>
                        <Descriptor>Persuasive text persuades the reader through precise and sustained choice of language and use of persuasive devices.</Descriptor>
                      </ScoreDescription>
                    </ScoreDescriptionList>
                  </Score>
                </ScoreList>
                <Descriptor>The writer’s capacity to orient, engage and affect the reader</Descriptor>
              </NAPWritingRubric>
              <NAPWritingRubric>
                <RubricType>Text Structure</RubricType>
                <ScoreList>
                  <Score>
                    <MaxScoreValue>4</MaxScoreValue>
                    <ScoreDescriptionList>
                      <ScoreDescription>
                        <ScoreValue>0</ScoreValue>
                        <Descriptor>No evidence of any structural components of a persuasive text.</Descriptor>
                      </ScoreDescription>
                      <ScoreDescription>
                        <ScoreValue>1</ScoreValue>
                        <Descriptor>Minimal evidence of persuasive structure; for example, structural components not clearly identifiable or one component only.</Descriptor>
                      </ScoreDescription>
                      <ScoreDescription>
                        <ScoreValue>2</ScoreValue>
                        <Descriptor>All three structural features (introduction, body and conclusion) exist but are not fully developed, or one feature is missing.</Descriptor>
                      </ScoreDescription>
                      <ScoreDescription>
                        <ScoreValue>3</ScoreValue>
                        <Descriptor>All structural features exist (introduction, body and conclusion) and are developed, or a longer, sophisticated text is presented with one weaker component.</Descriptor>
                      </ScoreDescription>
                      <ScoreDescription>
                        <ScoreValue>4</ScoreValue>
                        <Descriptor>Coherent, controlled and complete argument, including an introduction with clear position statement, body with reasons and detailed supporting evidence, and a conclusion that reinforces the writer's position.</Descriptor>
                      </ScoreDescription>
                    </ScoreDescriptionList>
                  </Score>
                </ScoreList>
                <Descriptor>The organisation of text features including introduction, body and conclusion into an appropriate and effective text structure.</Descriptor>
              </NAPWritingRubric>
              <NAPWritingRubric>
                <RubricType>Ideas</RubricType>
                <ScoreList>
                  <Score>
                    <MaxScoreValue>5</MaxScoreValue>
                    <ScoreDescriptionList>
                      <ScoreDescription>
                        <ScoreValue>0</ScoreValue>
                        <Descriptor>Text has insufficient evidence of ideas.</Descriptor>
                      </ScoreDescription>
                      <ScoreDescription>
                        <ScoreValue>1</ScoreValue>
                        <Descriptor>Ideas are very few and very simple; or appear unrelated to each other or unrelated to the prompt.</Descriptor>
                      </ScoreDescription>
                      <ScoreDescription>
                        <ScoreValue>2</ScoreValue>
                        <Descriptor>One idea with simple elaboration; or ideas are few and related but not elaborated; or ideas are many, simple and related but not elaborated.</Descriptor>
                      </ScoreDescription>
                      <ScoreDescription>
                        <ScoreValue>3</ScoreValue>
                        <Descriptor>Ideas are supported with some elaboration or unelaborated ideas relate plausibly to argument.</Descriptor>
                      </ScoreDescription>
                      <ScoreDescription>
                        <ScoreValue>4</ScoreValue>
                        <Descriptor>Ideas are elaborated and contribute effectively to the writer's position.</Descriptor>
                      </ScoreDescription>
                      <ScoreDescription>
                        <ScoreValue>5</ScoreValue>
                        <Descriptor>Ideas are generated, selected and crafted to be highly persuasive.</Descriptor>
                      </ScoreDescription>
                    </ScoreDescriptionList>
                  </Score>
                </ScoreList>
                <Descriptor>The creation, selection and crafting of ideas for a Persuasive text.</Descriptor>
              </NAPWritingRubric>
              <NAPWritingRubric>
                <RubricType>Persuasive Devices</RubricType>
                <ScoreList>
                  <Score>
                    <MaxScoreValue>4</MaxScoreValue>
                    <ScoreDescriptionList>
                      <ScoreDescription>
                        <ScoreValue>0</ScoreValue>
                        <Descriptor>Text has insufficient evidence of persuasive devices.</Descriptor>
                      </ScoreDescription>
                      <ScoreDescription>
                        <ScoreValue>1</ScoreValue>
                        <Descriptor>Uses a statement or statements of personal opinion or uses one or two instances of persuasive devices.</Descriptor>
                      </ScoreDescription>
                      <ScoreDescription>
                        <ScoreValue>2</ScoreValue>
                        <Descriptor>Uses three or more instances of persuasive devices that support the writer’s position (at least two types).</Descriptor>
                      </ScoreDescription>
                      <ScoreDescription>
                        <ScoreValue>3</ScoreValue>
                        <Descriptor>Uses some devices that persuade. Use is effective but not sustained, meaning approximately one page (may also include some ineffective use).</Descriptor>
                      </ScoreDescription>
                      <ScoreDescription>
                        <ScoreValue>4</ScoreValue>
                        <Descriptor>Sustained and effective use of persuasive devices.</Descriptor>
                      </ScoreDescription>
                    </ScoreDescriptionList>
                  </Score>
                </ScoreList>
                <Descriptor>The use of a range of persuasive devices to enhance a writer's position and persuade the reader.</Descriptor>
              </NAPWritingRubric>
              <NAPWritingRubric>
                <RubricType>Vocabulary</RubricType>
                <ScoreList>
                  <Score>
                    <MaxScoreValue>5</MaxScoreValue>
                    <ScoreDescriptionList>
                      <ScoreDescription>
                        <ScoreValue>0</ScoreValue>
                        <Descriptor>Text has insufficient evidence of vocabulary.</Descriptor>
                      </ScoreDescription>
                      <ScoreDescription>
                        <ScoreValue>1</ScoreValue>
                        <Descriptor>Very short script with few content words.</Descriptor>
                      </ScoreDescription>
                      <ScoreDescription>
                        <ScoreValue>2</ScoreValue>
                        <Descriptor>Words in the text are mostly simple verbs, adverbs, adjectives and/or nouns, but may include two or three precise words or word groups.</Descriptor>
                      </ScoreDescription>
                      <ScoreDescription>
                        <ScoreValue>3</ScoreValue>
                        <Descriptor>Four or more precise words or word groups.</Descriptor>
                      </ScoreDescription>
                      <ScoreDescription>
                        <ScoreValue>4</ScoreValue>
                        <Descriptor>Sustained &amp; consistent use of words &amp; word groups that enhance the meaning (may be some inappropriate or inaccurate word choices).</Descriptor>
                      </ScoreDescription>
                      <ScoreDescription>
                        <ScoreValue>5</ScoreValue>
                        <Descriptor>Text contains sustained and consistent use of precise, effective words and word groups used in a natural and articulate manner.</Descriptor>
                      </ScoreDescription>
                    </ScoreDescriptionList>
                  </Score>
                </ScoreList>
                <Descriptor>The range and precision of language choices.</Descriptor>
              </NAPWritingRubric>
              <NAPWritingRubric>
                <RubricType>Cohesion</RubricType>
                <ScoreList>
                  <Score>
                    <MaxScoreValue>4</MaxScoreValue>
                    <ScoreDescriptionList>
                      <ScoreDescription>
                        <ScoreValue>0</ScoreValue>
                        <Descriptor>Text has insufficient evidence of cohesion.</Descriptor>
                      </ScoreDescription>
                      <ScoreDescription>
                        <ScoreValue>1</ScoreValue>
                        <Descriptor>Cohesive links are missing or incorrect, making the text very confusing to a reader, or text is very short with limited evidence.</Descriptor>
                      </ScoreDescription>
                      <ScoreDescription>
                        <ScoreValue>2</ScoreValue>
                        <Descriptor>Text has some correct cohesive links between sentences. Most reference words are accurate. A reader may occasionally need to re-read the text and provide their own links to clarify meaning.</Descriptor>
                      </ScoreDescription>
                      <ScoreDescription>
                        <ScoreValue>3</ScoreValue>
                        <Descriptor>Text has cohesive devices used correctly to support reader understanding, and accurate use of referring words such that meaning is clear and the text flows well in a sustained piece of writing.</Descriptor>
                      </ScoreDescription>
                      <ScoreDescription>
                        <ScoreValue>4</ScoreValue>
                        <Descriptor>A range of cohesive devices is used correctly and deliberately to enhance reading an extended, highly cohesive piece of writing, showing continuity of ideas and tightly linked sections of text.</Descriptor>
                      </ScoreDescription>
                    </ScoreDescriptionList>
                  </Score>
                </ScoreList>
                <Descriptor>The control of multiple threads and relationships over the whole text, achieved through the use of referring words, substitutions, word associations and text connectives.</Descriptor>
              </NAPWritingRubric>
              <NAPWritingRubric>
                <RubricType>Paragraphs</RubricType>
                <ScoreList>
                  <Score>
                    <MaxScoreValue>3</MaxScoreValue>
                    <ScoreDescriptionList>
                      <ScoreDescription>
                        <ScoreValue>0</ScoreValue>
                        <Descriptor>Text has no correct use of paragraphs or attempted use is random.</Descriptor>
                      </ScoreDescription>
                      <ScoreDescription>
                        <ScoreValue>1</ScoreValue>
                        <Descriptor>Text has at least one correct paragraph break and is organised into paragraphs that are mainly
focused on a single idea or set of like ideas that assist the reader to digest chunks of text.</Descriptor>
                      </ScoreDescription>
                      <ScoreDescription>
                        <ScoreValue>2</ScoreValue>
                        <Descriptor>Text has all paragraphs focused on one idea or set of like ideas. At least one paragraph is logically constructed and contains a topic sentence and supporting detail. Paragraphs are mostly correct.</Descriptor>
                      </ScoreDescription>
                      <ScoreDescription>
                        <ScoreValue>3</ScoreValue>
                        <Descriptor>Paragraphing supports argument. Paragraphs are ordered and cumulatively build argument across text.</Descriptor>
                      </ScoreDescription>
                    </ScoreDescriptionList>
                  </Score>
                </ScoreList>
                <Descriptor>The segmenting of text into paragraphs that assists the reader to negotiate the text.</Descriptor>
              </NAPWritingRubric>
              <NAPWritingRubric>
                <RubricType>Sentence structure</RubricType>
                <ScoreList>
                  <Score>
                    <MaxScoreValue>6</MaxScoreValue>
                    <ScoreDescriptionList>
                      <ScoreDescription>
                        <ScoreValue>0</ScoreValue>
                        <Descriptor>Text has no evidence of sentences.</Descriptor>
                      </ScoreDescription>
                      <ScoreDescription>
                        <ScoreValue>1</ScoreValue>
                        <Descriptor>Very limited control of sentence formation, with some correct formation of sentences, such that some meaning can be construed.</Descriptor>
                      </ScoreDescription>
                      <ScoreDescription>
                        <ScoreValue>2</ScoreValue>
                        <Descriptor>Correct sentences are mostly simple and/or compound, and meaning is predominantly clear.</Descriptor>
                      </ScoreDescription>
                      <ScoreDescription>
                        <ScoreValue>3</ScoreValue>
                        <Descriptor>Most simple and compound sentences are correct, with some correct use of complex sentences. Meaning is predominantly clear.</Descriptor>
                      </ScoreDescription>
                      <ScoreDescription>
                        <ScoreValue>4</ScoreValue>
                        <Descriptor>Most simple, compound and complex sentences are correct or all simple, compound and complex sentences are correct but sentences do not demonstrate variety. Meaning is clear.</Descriptor>
                      </ScoreDescription>
                      <ScoreDescription>
                        <ScoreValue>5</ScoreValue>
                        <Descriptor>Sentences are correct, allowing for an occasional slip in more sophisticated structures, and demonstrate variety. Text contains controlled and well-developed sentences that express precise meaning and are consistently effective.</Descriptor>
                      </ScoreDescription>
                      <ScoreDescription>
                        <ScoreValue>6</ScoreValue>
                        <Descriptor>Text contains correct, well controlled and well developed sentences that express precise meaning and are consistently effective.</Descriptor>
                      </ScoreDescription>
                    </ScoreDescriptionList>
                  </Score>
                </ScoreList>
                <Descriptor>The production of grammatically correct, structurally sound and meaningful sentences.</Descriptor>
              </NAPWritingRubric>
              <NAPWritingRubric>
                <RubricType>Punctuation</RubricType>
                <ScoreList>
                  <Score>
                    <MaxScoreValue>5</MaxScoreValue>
                    <ScoreDescriptionList>
                      <ScoreDescription>
                        <ScoreValue>0</ScoreValue>
                        <Descriptor>Text has no evidence of correct sentence punctuation.</Descriptor>
                      </ScoreDescription>
                      <ScoreDescription>
                        <ScoreValue>1</ScoreValue>
                        <Descriptor>Text has minimal punctuation that is of little assistance to a reader.</Descriptor>
                      </ScoreDescription>
                      <ScoreDescription>
                        <ScoreValue>2</ScoreValue>
                        <Descriptor>Text has some correct punctuation that assists a reader.</Descriptor>
                      </ScoreDescription>
                      <ScoreDescription>
                        <ScoreValue>3</ScoreValue>
                        <Descriptor>Text has punctuation that is adequate to assist the reader. Most sentences are correctly punctuated with capital letters and full stops. The text shows some correct use of other punctuation such as commas or apostrophes.</Descriptor>
                      </ScoreDescription>
                      <ScoreDescription>
                        <ScoreValue>4</ScoreValue>
                        <Descriptor>Text has accurate punctuation that enables smooth and efficient reading. All sentences are correctly punctuated with capital letters and full stops, and text shows correct use of most other necessary punctuation.</Descriptor>
                      </ScoreDescription>
                      <ScoreDescription>
                        <ScoreValue>5</ScoreValue>
                        <Descriptor>Text has punctuation that provides precise markers to pace and control reading. Text contains accurate use of all applicable punctuation.</Descriptor>
                      </ScoreDescription>
                    </ScoreDescriptionList>
                  </Score>
                </ScoreList>
                <Descriptor>The use of correct and appropriate punctuation to aid reading of the text.</Descriptor>
              </NAPWritingRubric>
              <NAPWritingRubric>
                <RubricType>Spelling</RubricType>
                <ScoreList>
                  <Score>
                    <MaxScoreValue>6</MaxScoreValue>
                    <ScoreDescriptionList>
                      <ScoreDescription>
                        <ScoreValue>0</ScoreValue>
                        <Descriptor>Text has no conventional spelling or consists of text that is copied from the stimulus material.</Descriptor>
                      </ScoreDescription>
                      <ScoreDescription>
                        <ScoreValue>1</ScoreValue>
                        <Descriptor>Text has few examples of conventional spelling, or is very short with limited evidence.</Descriptor>
                      </ScoreDescription>
                      <ScoreDescription>
                        <ScoreValue>2</ScoreValue>
                        <Descriptor>Text has correct spelling of most simple words, and some common words. There may also be errors evident in common words.</Descriptor>
                      </ScoreDescription>
                      <ScoreDescription>
                        <ScoreValue>3</ScoreValue>
                        <Descriptor>Text has correct spelling of most simple words and most common words.</Descriptor>
                      </ScoreDescription>
                      <ScoreDescription>
                        <ScoreValue>4</ScoreValue>
                        <Descriptor>Text has correct spelling of most simple words, most common words and some difficult words.</Descriptor>
                      </ScoreDescription>
                      <ScoreDescription>
                        <ScoreValue>5</ScoreValue>
                        <Descriptor>Text has correct spelling of simple words, most common words, and at least 10 difficult words.</Descriptor>
                      </ScoreDescription>
                      <ScoreDescription>
                        <ScoreValue>6</ScoreValue>
                        <Descriptor>Text has correct spelling of all words, and at least 10 difficult words and some challenging words, or at least 15 difficult words if no challenging words.</Descriptor>
                      </ScoreDescription>
                    </ScoreDescriptionList>
                  </Score>
                </ScoreList>
                <Descriptor>The accuracy of spelling and the difficulty of the words used.</Descriptor>
              </NAPWritingRubric>
            </NAPWritingRubricList>};
    }
    
    $testlet = '';
    foreach $t (@{$itemlist{$refid}{TESTLET}}) {
        $testlet .= sprintf qq{   <NAPTestlet>
         <NAPTestletRefId>%s</NAPTestletRefId>
         <NAPTestletLocalId>%s</NAPTestletLocalId>
         <SequenceNumber>%d</SequenceNumber>
      </NAPTestlet>},
    $$t{REFID}, $$t{LOCALID}, $$t{SEQ}+1;
    }
    
    
    $substitute = "";
    if(exists $itemlist{$refid}{SUBSTITUTES}) { 
    foreach $s (@{$itemlist{$refid}{SUBSTITUTES}}) {
        $substitute .= sprintf (qq{          <SubstituteItem>
            <SubstituteItemRefId>%s</SubstituteItemRefId>
            <SubstituteItemLocalId>%s</SubstituteItemLocalId>
            <PNPCodeList>
              <PNPCode>%s</PNPCode>
            </PNPCodeList>
          </SubstituteItem>
}, $$s{REFID}, $$s{LOCALID}, join("</PNPCode>\n        <PNPCode>", @{$$s{PNP}})) ;}
    if ($substitute == "") {
    $substitute = sprintf qq{<ItemSubstitutedForList>
%s    </ItemSubstitutedForList>}, $substitute;
    } else {
      $substitute = '<ItemSubstitutedForList xsi:nil="true" />';
    }
  } else {
      $substitute = '<ItemSubstitutedForList xsi:nil="true" />';
    }
    
    
$itemlist{$refid}{XML} = sprintf qq{    <ItemName>%s</ItemName>
    <ItemType>%s</ItemType>%s
    <Subdomain>%s</Subdomain>%s
    <ItemDescriptor>Descriptor #%d</ItemDescriptor>
    <ReleasedStatus>%s</ReleasedStatus>
    <MarkingType>%s</MarkingType>%s
    %s
    <MaximumScore>1</MaximumScore>
    <ItemDifficulty>3</ItemDifficulty>
    <ItemDifficultyLogit5>.8</ItemDifficultyLogit5>
    <ItemDifficultyLogit62>.9</ItemDifficultyLogit62>
    <ItemDifficultyLogit5SE>.8</ItemDifficultyLogit5SE>
    <ItemDifficultyLogit62SE>.9</ItemDifficultyLogit62SE>
    <ItemProficiencyBand>3</ItemProficiencyBand>
    <ItemProficiencyLevel>Proficient</ItemProficiencyLevel>
    <ExemplarURL>https://www.assessform.edu.au/Exemplar/1</ExemplarURL>
    %s
    <ContentDescriptionList>
      <ContentDescription>http://www.australiancurriculum.edu.au/curriculum/contentdescription/ACMNA072</ContentDescription>
      <ContentDescription>http://www.australiancurriculum.edu.au/curriculum/contentdescription/ACMNA037</ContentDescription>
    </ContentDescriptionList>
    %s%s},
    $localid,
    $main_item_type,
    # rand() > .7 ? sprintf ("\n      <ItemType>%s</ItemType>", $item_types[int(rand(scalar @item_types))]) : "",
    "",
    #node2domain($itemlist{$refid}{NODE}, $domain),
    subdomain($domain_out, $itemlist{$refid}{NODE}),
    #($domain eq 'Writing' ? (rand() < .5 ? qq{\n    <WritingGenre>Persuasive</WritingGenre>} : qq{\n    <WritingGenre>Narrative</WritingGenre>}) : ''),
    ($domain_out eq 'Writing' ? (qq{\n    <WritingGenre>Persuasive</WritingGenre>} ) : ''),
    $i,
    $itemlist{$refid}{RELEASED} ? "true" : "false",
    marking_type($main_item_type),
        ($main_item_type eq 'MC' or $main_item_type eq 'MCS' ) ? qq{
    <MultipleChoiceOptionCount>4</MultipleChoiceOptionCount>} : '',
    #$testlet,
    $domain_out eq 'Writing' ? "<CorrectAnswer />" : sprintf("<CorrectAnswer>%s</CorrectAnswer>", $itemlist{$refid}{ANSWER}),
    $substitute,
    $stimulus,
    $rubrics,
    ;
printf F qq{
<NAPTestItem RefId="%s">
  <TestItemContent>
    <NAPTestItemLocalId>%s</NAPTestItemLocalId>
%s
  </TestItemContent>
  <SIF_Metadata xsi:nil="true" />
  <SIF_ExtendedElements xsi:nil="true" />
</NAPTestItem>}, 
$refid, 
$localid, 
$itemlist{$refid}{XML};
    
    
}

print F "\n</NAPTestItems>\n";

foreach $school (sort keys %students) {
foreach $yearlevel (sort keys %{$students{$school}}) {
foreach $student (@{$students{$school}{$yearlevel}}) {
$alt_writing_test = rand() > .5;

foreach $domain (sort keys %naptests) {
    next if $domain eq 'Writing' and $alt_writing_test;
    next if $domain eq 'Writing_alt' and !$alt_writing_test;
    next unless exists $naptests{$domain}{$yearlevel};
    $domain_out = $domain;
    $domain_out =~ s/_alt//;
    $refid = lc guid_as_string();
    $participation = participation();
    my @adjustments = adjustments($domain_out);
    $adjustment_link{$$student{GUID}}{$domain_out} = dclone(\@adjustments);

printf F qq{<NAPEventStudentLink xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" RefId="%s" xmlns="http://www.sifassociation.org/datamodel/au/3.4">
  <StudentPersonalRefId>%s</StudentPersonalRefId>
  <PlatformStudentIdentifier>%s</PlatformStudentIdentifier>
  <SchoolInfoRefId>%s</SchoolInfoRefId>
  <SchoolACARAId>%s</SchoolACARAId>
  <NAPTestRefId>%s</NAPTestRefId>
  <NAPTestLocalId>%s</NAPTestLocalId>
  <SchoolSector>NG</SchoolSector>
  <ReportingSchoolName />
  <ParticipationCode>%s</ParticipationCode>
  <ParticipationText>%s</ParticipationText>
  <Device xsi:nil="true" />
  <LapsedTimeTest xsi:nil="true" />
  %s
  %s
  %s
  <SIF_Metadata xsi:nil="true" />
  <SIF_ExtendedElements xsi:nil="true" />
</NAPEventStudentLink>
},
$refid,
$$student{GUID},
$$student{PSI},
$school[$school]{GUID},
$school[$school]{ACARAID},
$naptests{$domain}{$yearlevel}{GUID},
$naptests{$domain}{$yearlevel}{LOCALID},
$participation,
participation_encoding($participation),
exemption_reason($participation),
test_disruption($participation),
adjustment_print($domain_out, @adjustments)
;

push @{$events{$domain}}, {
    STUDENTGUID => $$student{GUID},
    PSI => $$student{PSI},
    NAPTESTGUID => $naptests{$domain}{$yearlevel}{GUID},
    NAPTESTLOCALID => $naptests{$domain}{$yearlevel}{LOCALID},
    DOMAIN => $domain_out,
    PARTICIPATION => $participation,
    YEARLEVEL => $yearlevel,
} ;

}}}}

foreach $school (sort keys %students) {
	if($school[$school]{GUID}) {
foreach $yearlevel (sort keys %{$students{$school}}) {
foreach $domain (sort keys %naptests) {

  next unless $naptests{$domain}{$yearlevel}{GUID};

    $refid = lc guid_as_string();
#printf STDERR "%s\t%s\t%s\n", $school, $domain, $yearlevel;

printf F qq{<NAPTestScoreSummary xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" RefId="%s" xmlns="http://www.sifassociation.org/datamodel/au/3.4">
  <SchoolInfoRefId>%s</SchoolInfoRefId>
  <SchoolACARAId>%s</SchoolACARAId>
  <NAPTestRefId>%s</NAPTestRefId>
  <NAPTestLocalId>%s</NAPTestLocalId>
  <DomainNationalAverage>%.2d</DomainNationalAverage>
  <DomainSchoolAverage>%.2d</DomainSchoolAverage>
  <DomainJurisdictionAverage>%.2d</DomainJurisdictionAverage>
  <DomainTopNational60Percent>%.2d</DomainTopNational60Percent>
  <DomainBottomNational60Percent>%.2d</DomainBottomNational60Percent>
  <SIF_Metadata xsi:nil="true" />
  <SIF_ExtendedElements xsi:nil="true" />
</NAPTestScoreSummary>
},
$refid,
$school[$school]{GUID},
$school[$school]{ACARAID},
$naptests{$domain}{$yearlevel}{GUID},
$naptests{$domain}{$yearlevel}{LOCALID},
rand(200)+$yearlevel_averages{$yearlevel}, 
rand(200)+$yearlevel_averages{$yearlevel}, 
rand(200)+$yearlevel_averages{$yearlevel}, 
rand(200)+$yearlevel_averages{$yearlevel}+20, 
rand(200)+$yearlevel_averages{$yearlevel}-20,
;


}}}}

%x = ();

printf F qq{<NAPStudentResponseSets xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://www.sifassociation.org/datamodel/au/3.4">};
foreach $d (@domainsLC_tests) {
foreach $e (@{$events{$d}}) {
    next if $$e{PARTICIPATION} eq 'A';
    next if $$e{PARTICIPATION} eq 'C';
    next if $$e{PARTICIPATION} eq 'E';
    next if $$e{PARTICIPATION} eq 'W';
    next if $$e{PARTICIPATION} eq 'X';


    $refid = lc guid_as_string();
    @path = ();
    $testlets = '';
    @pathway = @{$valid_node_pathways[int(rand(@valid_node_pathways))]};
    if($$e{DOMAIN} eq 'Reading') {
        $reading_end{$$e{STUDENTGUID}} = $pathway[-1];
    }
    if($$e{DOMAIN} eq "Grammar and Punctuation") {
        @pathway = lang_conv_pathway($reading_end{$$e{STUDENTGUID}});
    }
    if($$e{DOMAIN} eq "Spelling") {
        @pathway = spelling_pathway();
    }
    if($$e{DOMAIN} eq "Writing") {
        @pathway = writing_pathway();
    }
    $test_score = 0;
    $max_score = 0;

    if($d eq 'Writing_alt'){
      $d = $d;
    }

    foreach $node (@pathway) {
	$hasresponse = 0; # random for S, 0 for R
	$hasresponse = 1 if $$e{PARTICIPATION} eq 'P';
	$hasresponse = 1 if $$e{PARTICIPATION} eq 'S' and rand() < .2;

        $testletid = int(rand($testletcountpernode{$node}));
        push @path, $node . $testletid;
        $current_testlet = $naptestlet{$$e{DOMAIN}}{$$e{YEARLEVEL}}{$node}[$testletid];
        $items = '';
        $j = 0;
        $testlet_score = 0;
        foreach $item (@{$naptestitem{$$current_testlet{GUID}}}){
        $subscores = '';
        if($$e{DOMAIN} eq 'Writing' && ($$e{PARTICIPATION} eq 'P' || $$e{PARTICIPATION} eq 'R' )) {
            foreach $w (@writing_rubrics) {
                $subscores .= sprintf qq{  <Subscore>
                            <SubscoreType>%s</SubscoreType>
                            <SubscoreValue>%d</SubscoreValue>
                      </Subscore>
                    }, $w, $hasresponse ? ceil(rand(6)) : 0;
            }
            $subscores = "\n                    <SubscoreList>\n                    " . $subscores . "</SubscoreList>";
        }
        $subscores = qq{\n                    <SubscoreList xsi:nil="true" />} unless $subscores;
	next unless ($item and exists $$item{GUID});
        my $itemrefid = $$item{GUID};
        my $itemlocalid = $$item{LOCALID};
	next unless $itemrefid ;
        next if (exists $itemlist{$$item{GUID}}{SUBSTITUTES});
	if(exists $itemlist{$$item{GUID}}{SUBSTITUTED}) {
	foreach $p (@{$itemlist{$$item{GUID}}{SUBSTITUTED}}) {
        $lc = List::Compare->new($adjustment_link{$$e{STUDENTGUID}}{$$e{DOMAIN}}, $$p{PNP});
        if($lc->get_intersection and index($items, $$p{REFID}) == -1 ) {
          # don't substitute item if the student has already sat it
            $itemrefid = $$p{REFID};
            $itemlocald = $$p{LOCALID};
            printf STDERR "SUB! %s %s:\tStudent %s\tItem %s\tSubItem %s\n", $$e{DOMAIN}, join(':', $lc->get_intersection),
            $$e{STUDENTGUID}, $$item{GUID}, $$p{REFID};
        }
	}}
      if ($x{$$e{STUDENTGUID}}{$itemrefid}++) {
      printf STDERR "!!!!! %s %s\n", $$e{STUDENTGUID}, $itemrefid ;
    }


    #printf STDERR


        $correctness =                 $hasresponse ? response_correctness($itemlist{$itemrefid}{TYPE}) : 'NotAttempted';
        $response = response($correctness, $itemlist{$itemrefid}{TYPE}, $itemlist{$itemrefid}{ANSWER}, $$e{DOMAIN});
        $is_correct = ($correctness eq 'Correct'); 
        $itemscore = ($is_correct ? 1 : 0);
        $items .= sprintf qq{
                <ItemResponse>
                    <NAPTestItemRefId>%s</NAPTestItemRefId>
                    <NAPTestItemLocalId>%s</NAPTestItemLocalId>%s
                    <ResponseCorrectness>%s</ResponseCorrectness>%s%s
                    <SequenceNumber>%d</SequenceNumber>
                    <ItemWeight>1</ItemWeight>%s
                </ItemResponse>        }, 
                $itemrefid, $itemlocalid,
                $hasresponse ? sprintf("\n                    <Response>%s</Response>",$response) :
                        qq{\n                    <Response />},
                $correctness,
		$$e{PARTICIPATION} eq 'P' ? sprintf("\n                    <Score>%d</Score>", $itemscore) : '',
                $hasresponse ? sprintf("\n                    <LapsedTimeItem>PT50S</LapsedTimeItem>"):'',
                ++$j,
                $subscores,
                ;
            $testlet_score += $itemscore;
	    $max_score += 1;
        }
	next unless $$current_testlet{GUID};
        $testlets .= sprintf qq{
        <Testlet>
            <NAPTestletRefId>%s</NAPTestletRefId>
            <NAPTestletLocalId>%s</NAPTestletLocalId>%s
            <ItemResponseList>%s
            </ItemResponseList>
        </Testlet>}, 
$$current_testlet{GUID},
$$current_testlet{LOCALID},
$hasreponse ? sprintf("\n            <TestletSubScore>%d</TestletSubScore>",$testlet_score) : '',
$items,
;

#if($$e{PARTICIPATION} eq 'P' and $$e{DOMAIN} eq "Writing" and $hasresponse == 0) {
#$hasresponse = $hasresponse;
#}


    $test_score += $testlet_score;
    }
    
    $testletpath = print_node_path(join(':', @path));
    $nodepath= print_node_path(join(':', map { substr($_, 0, -1)} @path));
    
    printf F qq{
<NAPStudentResponseSet RefId="%s">
    <ReportExclusionFlag>%s</ReportExclusionFlag>
    <CalibrationSampleFlag>%s</CalibrationSampleFlag>
    <EquatingSampleFlag>%s</EquatingSampleFlag>
    %s
    <StudentPersonalRefId>%s</StudentPersonalRefId>
    <PlatformStudentIdentifier>%s</PlatformStudentIdentifier>
    <NAPTestRefId>%s</NAPTestRefId>
    <NAPTestLocalId>%s</NAPTestLocalId> },
    $refid,
    rand() > .95 ? 'true' : 'false' ,
    rand() > .95 ? 'true' : 'false' ,
    rand() > .95 ? 'true' : 'false' ,
    ($$e{DOMAIN} eq 'Writing' ? 
      qq{<PathTakenForDomain xsi:nil="true" />\n    <ParallelTest xsi:nil="true" />} : 
      sprintf("<PathTakenForDomain>%s</PathTakenForDomain>\n    <ParallelTest>%s</ParallelTest>",check_path_sep($nodepath), check_path_sep($testletpath))),
    $$e{STUDENTGUID},
    $$e{PSI},
    $$e{NAPTESTGUID},
    $$e{NAPTESTLOCALID},
    ;
    printf F qq{
    <DomainScore>
        <RawScore>0.0</RawScore>
        <ScaledScoreValue>0.0</ScaledScoreValue>
        <ScaledScoreLogitValue>0.0</ScaledScoreLogitValue>
        <ScaledScoreStandardError>0.0</ScaledScoreStandardError>
        <ScaledScoreLogitStandardError>0.0</ScaledScoreLogitStandardError>
        <StudentDomainBand>0</StudentDomainBand>
        <StudentProficiency>None</StudentProficiency>
        <PlausibleScaledValueList>
          <PlausibleScaledValue>14</PlausibleScaledValue>
          <PlausibleScaledValue>15</PlausibleScaledValue>
          <PlausibleScaledValue>16</PlausibleScaledValue>
          <PlausibleScaledValue>17</PlausibleScaledValue>
          <PlausibleScaledValue>18</PlausibleScaledValue>
        </PlausibleScaledValueList>
    </DomainScore> }
    if ($$e{PARTICIPATION} eq 'R' );
    printf F qq{
    <DomainScore>
        <RawScore>%.2f</RawScore>
        <ScaledScoreValue>%.2f</ScaledScoreValue>
        <ScaledScoreLogitValue>%.2f</ScaledScoreLogitValue>
        <ScaledScoreStandardError>%.2f</ScaledScoreStandardError>
        <ScaledScoreLogitStandardError>%.2f</ScaledScoreLogitStandardError>
        <StudentDomainBand>%d</StudentDomainBand>
        <StudentProficiency>Proficient</StudentProficiency>
        <PlausibleScaledValueList>
          <PlausibleScaledValue>14</PlausibleScaledValue>
          <PlausibleScaledValue>15</PlausibleScaledValue>
          <PlausibleScaledValue>16</PlausibleScaledValue>
          <PlausibleScaledValue>17</PlausibleScaledValue>
          <PlausibleScaledValue>18</PlausibleScaledValue>
        </PlausibleScaledValueList>
    </DomainScore> },
    $test_score,
    scaled_score($test_score, $max_score, $$e{YEARLEVEL}),
    rand(5)+18,
    rand(5)+18,
    rand(5)+18,
    domain_band($test_score, $max_score, $$e{YEARLEVEL}),
    if ($$e{PARTICIPATION} eq 'P' );
    printf F qq{
    <TestletList>%s
    </TestletList> },
    $testlets if ($$e{PARTICIPATION} eq 'P' || $$e{PARTICIPATION} eq 'S') ;
    print F qq{
  <SIF_Metadata xsi:nil="true" />
  <SIF_ExtendedElements xsi:nil="true" />
</NAPStudentResponseSet>}

}}
print F "</NAPStudentResponseSets>\n";

foreach $domain (@domainsLC_test) {
foreach $testlevel (@testlevels) {
  $domain_out = $domain;
  $domain_out =~ s/_alt//;

    printf F qq{
<NAPCodeFrame RefId="%s">
  <NAPTestRefId>%s</NAPTestRefId>
  <TestContent>
    <NAPTestLocalId>%s</NAPTestLocalId>
    <TestName>NAPLAN %s Yr %s, 2017</TestName>
    <TestLevel><Code>%s</Code></TestLevel>
    <TestType>Normal</TestType>
    <Domain>%s</Domain>
    <TestYear>2017</TestYear>
    <StagesCount>%d</StagesCount>
    <DomainBands>
      <Band1Lower>0</Band1Lower>
      <Band1Upper>258</Band1Upper>
      <Band2Lower>258</Band2Lower>
      <Band2Upper>318</Band2Upper>
      <Band3Lower>318</Band3Lower>
      <Band3Upper>368</Band3Upper>
      <Band4Lower>368</Band4Lower>
      <Band4Upper>417</Band4Upper>
      <Band5Lower>417</Band5Lower>
      <Band5Upper>466</Band5Upper>
      <Band6Lower>466</Band6Lower>
      <Band6Upper>526</Band6Upper>
      <Band7Lower>526</Band7Lower>
      <Band7Upper>574</Band7Upper>
      <Band8Lower>574</Band8Lower>
      <Band8Upper>633</Band8Upper>
      <Band9Lower>633</Band9Lower>
      <Band9Upper>681</Band9Upper>
      <Band10Lower>681</Band10Lower>
      <Band10Upper>999</Band10Upper>
    </DomainBands>
    <DomainProficiency>
       <Level1Lower>10</Level1Lower>
       <Level1Upper>20</Level1Upper>
       <Level2Lower>30</Level2Lower>
       <Level2Upper>40</Level2Upper>
       <Level3Lower>50</Level3Lower>
       <Level3Upper>60</Level3Upper>
       <Level4Lower>70</Level4Lower>
       <Level4Upper>80</Level4Upper>
    </DomainProficiency>
  </TestContent>
  <TestletList>  },
    lc guid_as_string(),
    $naptests{$domain}{$testlevel}{GUID},
    $naptests{$domain}{$testlevel}{LOCALID},
    $domain_out, $testlevel,
    $testlevel,
    $domain_out,
    $domain_out eq 'Spelling' ? 2 : 3,
    ;
foreach $node (sort keys %{$naptestlet{$domain}{$testlevel}}) {
my $i=0;
foreach $testlet (@{$naptestlet{$domain}{$testlevel}{$node}}) {



printf F qq{<Testlet>
      <NAPTestletRefId>%s</NAPTestletRefId>
      <TestletContent>
        <NAPTestletLocalId>%s</NAPTestletLocalId>
        <TestletName>%s</TestletName>
        <Node>%s</Node>
        <LocationInStage>%d</LocationInStage>
        <TestletMaximumScore>%d</TestletMaximumScore>
      </TestletContent>
      <TestItemList>      },
    $$testlet{GUID},
    $$testlet{LOCALID},
    $$testlet{NAME},
    $node,
    ++$i,
    $$testlet{SUBSCORE},
    ;
    
foreach $item ( @{$naptestitem{$$testlet{GUID}}})  {
$refid = $$item{GUID};
=pod=
$stimulus = '';
if($itemlist{$refid}{STIMULI}) {
@stimuli = split m/,/, $itemlist{$refid}{STIMULI};
foreach $s (@stimuli) {
    $stimulus .= sprintf qq{            <StimulusLocalId>%s</StimulusLocalId>}, $s;
}
$stimulus = '
          <StimulusLocalIdList>
' . $stimulus . ' 
          </StimulusLocalIdList>';
}
$substitutes = '';
if(@{$itemlist{$refid}{SUBSTITUTED}}) {
foreach $p (@{$itemlist{$refid}{SUBSTITUTED}}){
$pnp = '';
foreach $pp (@$p{PNP}) {
$pnp .= sprintf qq{                <PNPCode>%s</PNPCode>
}, $$pp[0];
}


$substitutes .= sprintf qq{
    <SubstituteItem>
      <SubstitueItemRefId>%s</SubstitueItemRefId>
      <SubstituteItemLocalId>%s</SubstituteItemLocalId>
      <PNPCodeList>
%s      </PNPCodeList>
     </SubstituteItem>},
  $$p{REFID}, $$p{LOCALID},
$pnp;
}
$substitutes = sprintf qq{
          <SubstituteItemList>%s
          </SubstituteItemList>}, $substitutes;
}

printf F qq{
        <TestItem>
          <TestItemRefId>%s</TestItemRefId>
          <TestItemLocalId>%s</TestItemLocalId>
          <SequenceNumber>%s</SequenceNumber>
	  <TestItemContent>
            <ItemName>%s</ItemName>
            <ItemType>%s</ItemType>
            <MaximumScore>%s</MaximumScore>%s
            <CorrectAnswer>%s</CorrectAnswer>%s%s
	  </TestItemContent>
        </TestItem>   },
    $refid ,
    $$item{LOCALID},
    $$item{SEQ},
    $$item{LOCALID},
    $itemlist{$refid}{TYPE},
    1,
    ($itemlist{$refid}{TYPE} eq 'MC' or $itemlist{$refid}{TYPE} eq 'MCS' ) ? qq{
    <MultipleChoiceOptionCount>4</MultipleChoiceOptionCount>} : '',
    $domain_out eq "Writing ? "" : $itemlist{$refid}{ANSWER},
    $stimulus,
    $substitutes,
    ;


    
    
=cut  
printf F qq{
        <TestItem>
          <TestItemRefId>%s</TestItemRefId>
          <SequenceNumber>%s</SequenceNumber>
	  <TestItemContent>
            <NAPTestItemLocalId>%s</NAPTestItemLocalId>
        %s
	  </TestItemContent>
        </TestItem>},
        $refid, $$item{SEQ}, $$item{LOCALID}, $itemlist{$refid}{XML};
  }  
printf F qq{
      </TestItemList>
    </Testlet>
};
    
    

}}  
  
  
    printf F qq{  </TestletList>
  <SIF_Metadata xsi:nil="true" />
  <SIF_ExtendedElements xsi:nil="true" />
</NAPCodeFrame>
};



}
}
print F "</sif>\n";
close F;


sub scaled_score($$$){
	my ($rawscore, $maxscore, $yr) = @_;
	return 0 unless $maxscore;
	return ($rawscore/$maxscore)*150 + $yearlevel_averages{$yr} - 75;
}

sub domain_band($$$){
	my ($rawscore, $maxscore, $yr) = @_;
	return 0 unless $maxscore;
	return int (($rawscore/$maxscore)*4 + ($yr-1)/2 + 2);
}

sub yesno() {
	my $r = rand();
	return  $r < .45 ? 'Y' :
		$r < .9 ? 'N' :
		$r < .95 ? 'X' : 'U' ;
}

sub language(){
	my $r = rand();
	return $r < .8 ? 1201 :
		$r < .85 ? 7100 :
		$r < .9 ? 2201 :
		$r < .95 ? 5203 : 9601;
}

sub country(){
  my $r = rand();
  return $r < .8 ? 1101 :
  $r < .85 ? 6101 :
  $r < .9 ? 2100 :
  $r < .95 ? 4111 : 3307;
}

sub dateofbirth($){
	my $yearlevel = @_;
	my $year = 2010-$yearlevel;
	return sprintf "%s-%02d-%02d", $year, rand(12)+1, rand(28)+1;
}


sub psi($){
        my ($source, $state, $i) = @_;
        my $digits = $state * 100000000 + $i;
        my $c = check_digit($i);
        return sprintf "%s%09d%s", $source, $digits, encode($c);
}

sub encode($){
        my ($d) = @_;
        return "K" if $d == 0;
        return "M" if $d == 1;
        return "R" if $d == 2;
        return "A" if $d == 3;
        return "S" if $d == 4;
        return "P" if $d == 5;
        return "D" if $d == 6;
        return "H" if $d == 7;
        return "E" if $d == 8;
        return "G" if $d == 9;

        return "XXXXXXX";
}

sub participation() {
    my $r = rand();
    return 
    	$r < .86 ? 'P' :
    	$r < .88 ? 'C' :
        $r < .9 ? 'X' :
        $r < .92 ? 'A' :
        $r < .94 ? 'E' :
        $r < .96 ? 'W' :
        $r < .98 ? 'S' : 'R';
}

sub participation_encoding($){
    my ($p) = @_;
    return "Present" if $p eq 'P';
    return "Absent" if $p eq 'A';
    return "Exempt" if $p eq 'E';
    return "Withdrawn" if $p eq 'W';
    return "Sanctioned Abandonment" if $p eq 'S';
    return "Refused" if $p eq 'R';
    return "No Longer Enrolled" if $p eq 'X';
    return "Cancelled" if $p eq 'C';
    return "XXX" ;
}

sub exemption_reason($){
    my($e) = @_;
    return '<ExemptionReason xsi:nil="true" />' if $e ne 'E';
    my $r = rand();
    return qq{<ExemptionReason>0: Student has a significant intellectual disability and / or a significant co-existing condition</ExemptionReason>} if $r < .5;
    return qq{<ExemptionReason>1: Student has been learning English for less than one year</ExemptionReason>}
}

sub test_disruption($) {
    my($e) = @_;
    return '<TestDisruptionList xsi:nil="true" />' if $e ne 'S';
    return sprintf qq{<TestDisruptionList>
    <TestDisruption>
      <Event>%s</Event>
    </TestDisruption>
  </TestDisruptionList>}, disruption_event();
}

sub disruption_event() {
	my $e = rand(3);
	return "Student had vomiting fit" if $e < 1;
	return "Network failure during test" if $e < 2;
	return "Test room flooded";
}

# 1 or 2 codes; 20% possibility of each, collisions don't count
sub adjustments($) {
    my ($d) = @_;
    my $r = rand();
    return () if $r < .8;
    my %pnp = ();
    for($i=0; $i<2; $i++, $r = rand()) {
    if ($r > .95) {
    	$pnp{$pnp_extratime[int(rand(@pnp_extratime))]}++;
    } elsif ($r > .9) {
    	$pnp{$pnp_unlockedbrowser[int(rand(@pnp_unlockedbrowser))]}++;
    } elsif ($r > .89) {
	$pnp{'AIM'}++;
    } elsif ($r > .88) {
	$pnp{'AIV'}++;
    } elsif ($r < .87) {
	$pnp{'AIA'}++;
    } elsif ($r < .86) {
	$pnp{'AVM'}++;
    } elsif ($r > .85) {
	$pnp{'ALL'}++;
    } elsif ($r > .8)  {
    	$pnp{$pnp_nosystemaction[int(rand(@pnp_nosystemaction))]}++;
    }
}
    return keys %pnp;   
}

sub adjustment_print($$) {
    my ($d, @pnp) = @_;
    $d = "Language Conventions - Spelling" if $d eq "Language Conventions";
    return '<Adjustment xsi:nil="true" />' unless @pnp;
    $pnpout = "";
    foreach $p (@pnp) {
    $pnpout .= sprintf qq{        <PNPCode>%s</PNPCode>
}, $p;
    }
    
return sprintf qq{<Adjustment>
    <PNPCodeList>
%s    </PNPCodeList>%s
  </Adjustment>},
  $pnpout, ($pnp[0] eq 'BRA') ? qq{\n      <BookletType>Braille</BookletType>} : '';
}

sub marking_type($){
    my ($itemtype) = @_;
    return 'AS' unless $itemtype eq 'TE';
    #return rand() > .5 ? 'MM' : 'AES';
    return 'AES';
}

sub item_type($){
    my ($node) = @_;
    return 'TE' if $node eq 'S1';
    return 'ET' if $node eq 'Blank';
	my $r = rand();
	return 'MC' if $r < .5;
	return 'TE' if $r < .75;
	return $item_types_remainder[int(rand(@item_types_remainder))];
}
sub stimulus(@) {
    my ($id, $type, $domain, $node) = @_;
    $type = 'Audio' if $node eq 'S1';
    return sprintf qq{
      <Stimulus>
        <StimulusLocalId>%s</StimulusLocalId>
        <TextGenre xsi:nil="true" />
        <TextType xsi:nil="true" />
        <WordCount xsi:nil="true" />
        <Content />
      </Stimulus>},
    $id,
    ;
}

sub lang_conv_pathway($) {
    my ($first_node) = @_;
    my @ret = ($first_node . 'lc');
    push @ret, (rand() < .5 ? 'P1' : 'P2');
    return @ret;
}

sub spelling_pathway($) {
    my @ret = ();
    push @ret, 'S1';
    push @ret, (rand() < .5 ? 'S2' : 'S3');
    return @ret;
}

sub writing_pathway() {
  return ( "Blank" );
}

sub print_node($) {
    my ($ret) = @_;
    return qq{<Node xsi:nil="true" />} if $ret eq 'Blank';
    $ret =~ s/lc//g;
    return "<Node>$ret</Node>";
}

sub print_node_path($) {
    my ($ret) = @_;
    # return qq{<Node xsi:nil="true" />} if $ret eq 'Blank';
    $ret =~ s/lc//g;
    return $ret;
}

sub check_path_sep() {
       my ($ret) = @_;
       if (length($ret) == 3) {
               return substr($ret,1,2);
       } elsif (substr($ret,0,1) eq '0') {
               return substr($ret,2);
       }
       else {
               return @_;
       }
}

sub itempertestlet($$) {
    my ($yrlevel, $node) = @_;
    return 25 if $node eq 'Clc';
    return 25 if $node eq 'Elc';
    return 25 if $node eq 'Flc';
    return 10 if $node eq 'S1';
    return 5 if $node eq 'S2';
    return 5 if $node eq 'S3';
    return 10 if $node eq 'P1';
    return 10 if $node eq 'P2';
    return 1 if $node eq 'Blank';
    return 12 if $yrlevel == 3;
    return 14 if $yrlevel == 5;
    return 16 if $yrlevel == 7;
    return 16 if $yrlevel == 9;
    print "ITEM COUNT ERROR\n";
    return -1;
}

sub response_correctness($) {
=pod=
    my ($type) = @_;
    my $r = rand();
    return 9 if $r > .9;
    if($type eq 'MC') {
        return 1 if $r < .7;
        return int(($r-.7)*25)+1;
    }
    if ($type eq 'MCS'){
        return 1 if $r < .7;
        return int(($r-.7)*25)+1;
    }
    return $r < .7 ? 1 : 0;
=cut
	my $r = rand();
	return 'Correct' if $r < .7;
	return 'Incorrect' if $r < .9;
	return 'NotInPath' if $r < .95;
	return 'NotAttempted';
}

sub writing() {
  $size = rand() > .7 ? 875 : rand() > .4 ? 575 : 275;
  $preface = sprintf("This is a sample of %d words&lt;/p&gt;\n\n&lt;p&gt;", $size+25);
  my $text = $lorem->words($size);
  my @response = split / /, $text;
  for(my $i = 0; $i < 10; $i++) {
    $j = int(rand(scalar @response));
    $response[$j] .= ",";
  }
  for(my $i = 0; $i < 10; $i++) {
    $j = int(rand(scalar @response));
    $response[$j] .= "." unless $response[$j] =~ /,$/;
  }
=pod=
  for(my $i = 0; $i < 3; $i++) {
    $j = int(rand(scalar @response));
    next if $response[$j] =~ /^\&/;
    $response[$j] = $emojis[$i];
  }
=cut=
  for(my $i = 0; $i < 3; $i++) {
    $j = int(rand(scalar @response));
    next if $response[$j] =~ /^\&/;
    $response[$j] = '&lt;strong&gt;' . $response[$j] . '&lt;/strong&gt;';
  }
  for(my $i = 0; $i < 3; $i++) {
    $j = int(rand(scalar @response));
    next if $response[$j] =~ /^\&/;
    $response[$j] = '&lt;em&gt;' . $response[$j] . '&lt;/em&gt;';
  }
  for(my $i = 0; $i < 3; $i++) {
    $j = int(rand(scalar @response));
    next if $response[$j] =~ /^\&/;
    $response[$j] = '&lt;span style="text-decoration:underline"&gt;' . $response[$j] . '&lt;/span&gt;';
  }
  for(my $i = 0; $i < 3; $i++) {
    $j = int(rand(scalar @response));
    next if $response[$j] =~ /^\&/;
    $response[$j] = '&lt;span style="font-size:16px"&gt;' . $response[$j] . '&lt;/span&gt;';
  }
  for(my $i = 0; $i < 3; $i++) {
    $j = int(rand(scalar @response));
    next if $response[$j] =~ /^\&/;
    $style = "";
    $style = ' style="text-align:left"' if $i==0;
    $style = ' style="text-align:center"' if $i==1;
    $response[$j] = "&lt;/p&gt;\n&lt;p$style&gt;" . $response[$j];
  }
  $i = int(rand((scalar @response)-1));
  $response[$i] .= "&lt;/p&gt;\n&lt;ul&gt;\n&lt;li&gt;Rationarium Incompositum I&lt;/li&gt;\n&lt;li&gt;Rationarium Incompositum II&lt;/li&gt;\n&lt;li&gt;Rationarium Incompositum III&lt;/li&gt;&lt;/p&gt;\n";
  $response[$i+1] = "&lt;p&gt;" . $response[$i+1];
  $i = int(rand((scalar @response)-1));
  $response[$i] .= "&lt;/p&gt;\n&lt;ol&gt;\n&lt;li&gt;Rationarium Compositum I&lt;/li&gt;\n&lt;li&gt;Rationarium Compositum II&lt;/li&gt;\n&lt;li&gt;Rationarium Compositum III&lt;/li&gt;&lt;/p&gt;\n";
  $response[$i+1] = "&lt;p&gt;" . $response[$i+1];
  $response[0] = $preface . $response[0];
  return sprintf "&lt;p&gt;%s&lt;/p&gt;", join(" ", @response);
}

sub response($$$$) {
  my ($correctness, $type, $answer, $domain) = @_;
  return "" if $correctness eq 'NotAttempted';
  return $answer if $correctness eq 'Correct';
  if ($domain eq 'Writing') {
    return writing();
  } elsif ($type eq 'MC' || $type eq "MCS") {
    while (1) {
      my $ret = chr(ord('A') + int(rand(4)) );
      return $ret unless $ret eq $answer;
    }
  } else {
    return $string_gen->randregex('[a-zA-Z]{10}');
  }

}

sub node2domain($$) {
  my ($node, $domain) = @_;
  return $domain unless $domain eq 'Language Conventions';
  my $ret = 'Language Conventions - Grammar and Punctuation';
  $ret = 'Language Conventions - Spelling' if $node eq 'S1' or $node eq 'S2' or $node eq 'S3';
  return $ret;
}

# going to put forward only one sample node
sub sample_next_sequence($$) {
  my ($node, $n) = @_;
  return 'B' if $node eq 'A';
  return 'C' if $node eq 'B';
  return 'E' if $node eq 'D';
  return 'B' if $node eq 'C' and $n eq '1';
  return 'E' if $node eq 'C' and $n eq '2';
  return 'S2' if $node eq 'S2';
}

sub testletrulelist($){
  my ($node) = @_;
  return "" if $node eq 'E';
  return "" if $node eq 'F';
  return "" if $node eq 'S2';
  return "" if $node eq 'S3';
  return "" if $node eq 'P1';
  return "" if $node eq 'P2';
  return "" if $node eq 'Blank';
  my @stage = (qw(1));
  @stage = (qw(2)) if $node eq 'B';
  @stage = (qw(2)) if $node eq 'D';
  @stage = (qw(1 2)) if $node eq 'C';
  my $ret = '';
  my $n;
  foreach $n (@stage) {
    my $seq = sample_next_sequence($node, $n);
    $ret .= sprintf qq{
    <TestletRule>
    <Stage>%s</Stage>
    <Difficulty>Harder</Difficulty>
    <DestinationNode>%s1</DestinationNode>
    <LowerBoundInc>25</LowerBoundInc>
    <UpperBoundMax>30</UpperBoundMax>
    </TestletRule>
    <TestletRule>
    <Stage>%s</Stage>
    <Difficulty>Easier</Difficulty>
    <DestinationNode>%s3</DestinationNode>
    <LowerBoundMin>0</LowerBoundMin>
    <UpperBoundExc>15</UpperBoundExc>
    </TestletRule>
    <TestletRule>
    <Stage>%s</Stage>
    <Difficulty>Same</Difficulty>
    <DestinationNode>%s2</DestinationNode>
    <LowerBoundInc>15</LowerBoundInc>
    <UpperBoundMax>25</UpperBoundMax>
    </TestletRule> }, 
    $n, $seq,
    $n, $seq,
    $n, $seq,
    ;
  }
  return sprintf qq{
  <TestletRuleList>	%s
  </TestletRuleList>}, $ret;
}

sub subdomain($$){
  my ($domain, $node) = @_;
  return 'Numbers' if $domain eq 'Numeracy';
  return 'Letters' if $domain eq 'Reading';
  return 'Expressive Writing' if $domain eq 'Writing';
  return 'Punctuation' if $domain eq 'Grammar and Punctuation' and $node =~ m/^P/;
  return 'Grammar' if $domain eq 'Grammar and Punctuation' and $node !~ m/^P/;
  return 'Spelling' if $domain eq 'Spelling';
  return '??';
}


