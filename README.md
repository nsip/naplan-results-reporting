# naplan-results-reporting


## NAPLAN Results and Reporting draft dataset. 
This is a draft of objects to be used to  encode results from NAPLAN, for communicating results between the National Assessment Platform and Test Administration Authorities.

## Important Notes

_Please note the version of the Results and Reporting Dataset for NAPLAN Online published here is a work in progress and is published as an indication of the likely data produced by the platform._
 
_An Excel version was approved by OAWG at their November 2016 meeting. This format applies to the 2017 NAPLAN cycle only, and is expected to be revised for future cycles._ 


This version of the results reporting dataset is provided as an early access release intended to help systems integrators who need to understand the high-level concepts of the results reporting data structure.

NSIP strongly recommends that users of this specification register as GitHub users, and click on the 'Watch' button in the top right-hand corner of the GitHub web interface - this will ensure that if and when changes are made to the specification you will be notified automatically.

NSIP has included three sample data file sets in XML format as part of this release: 

* `nap-samplefile.xml` has a single record for each object type, and is meant to illustrate the full range of object content.
* `sample.platform.xml.zip` is a sample data file with randomised data, reflecting the data as it has been exported from the National Assessment Platform for the 2018 test. This file seeks to give a realistic representation of NAPLAN Results & Reporting data, including two writing tests per year level, no branching information for writing, no Yr 3 Writing tests, and opaque test and test item names. It also follows the Platform's practice of using `xsl:nil` or empty elements for missing elements, rather than omitting them. On the other hand, the sample file also includes substitute items in the codeframe; that will not be the case from the platform at least for 2019.
* `NAPLANAPITestData.zip` presents sample data file in the three chunks it is expected to be distributed as through the NAPLAN Results & Reporting API: Test Data (for the codeframes, tests, testlets and test items), SchoolList (for the SchoolInfo objects describing the schools whose data the client has access to) and SchoolData (the students, test events, test results and score summaries for a specific school).

Please note, these files contain valid data in all elements, but do not constitute a realistic results dataset. The data is primarily there for guidance in constructing integrations.


## What you can find here

* Technical Specification Document
  * _Results and Reporting Dataset - Specifications 2.00.pdf_: This document describes the specification of the results reporting objects
  * _NAP response Object Draft 18.pdf_: SIF XML specification, with mappings to the Dataset Dictionary (infra)
  * For specifics of the SIF specification about these objects, refer to http://specification.sifassociation.org/Implementation/AU/3.4.3/ under each object name
* Dataset Dictionary
  * _Online NAPLAN Reporting Dataset 2 07.xslx_: This is an Excel version of the object schema giving details of all field types 
* XSD for Object Validation
  * _SIF_MessageWithNAPWrapper Oct 2018.xsd_: This is an xsd containing all of the object definitions and linkages, for use in validating results-reporting files or for constructing schemas/code to handle the data updated for use in readiness for NAPLAN 2019 testing. The xsd has been updated to include the proposed `NAPLANResultsReporting` wrapper for API responses and RRD data sets, which consist of different SIF objects relevant to NAP.
* Sample Data Files (see discussion above)
  * **sample.platform.xml.zip**
  * **nap-samplefile.xml**
  * **NAPLANAPITestData.zip**
* Data file generation scripts:
  * _nap_platformdata_generator.pl_ generates data in as close a format to the current (PRT 2017) platform output format as possible, though it does not preserve indentation. The two command line variables set the number of students per school, and the number of schools in the sample. So _perl nap_platformdata_generator.pl 200 5_ creates a sample file with 5 schools, and 200 students per school. The script generates output both in a single file (`rrd.xml`), and in the file chunks expected through the NAPLAN Results & Reporting API (as described above)
* NAPLAN Results & Reporting API
  * _naplan_api.zip_: Node package which generates timestamped SIF_HMACSHA256 authentication tokens, and inserts them into the headers of HTTP requests originating from the [Insomnia](https://insomnia.rest) REST client. Used to enable Insomnia to generate correctly authorised NAPLAN Results & Reporting API requests; users will need to edit the script to insert their own credentials.

## Specification Overview
The results reporting objects are organised as follows:

![E-R diagram](https://raw.githubusercontent.com/nsip/naplan-results-reporting/master/NAPResponses.png "E-R diagram")

The codeframe object packages the same content as the test, testlet, and test item objects, and is highlighted in blue.

This repository includes a cut-down SIF-AU XSD specific to the reporting objects, and a definition of the dataset. It also includes sample data based on the XSD schema generated with the following criteria:  

* 800 students enrolled in four different schools, distributed among years 3, 5, 7, 9
* test objects for all domains of NAPLAN
* Students with all possible participation statuses for tests (2%  for each of; C, X, A, E, W, S, R).
* student response sets for all students that have participated in all tests (86%)
* a selection of adaptive testlets and corresponding items for all tests, following the NAPLAN node structure (A-F), and the allocation of testlets per node that ACARA has established. The items include adjustment substitutes.
  * The testlets and items are made available both as a single codeframe object per test, which we assume jurisdictions will consume in advance, and as separate testlet and test item objects, which are referenced from the student response sets
* test score summaries for all tests

The data is randomised, and is not intended to represent real test constructs. However the values included in the dataset are intended to be as realistic as possible.

We are including codeframe information in the results reporting dataset, and will update this specification as soon as the final structure of this data has been agreed.

As guidance for any database design intended to ingest this data, the following diagram presents all lists included within the objects, which a relational database would need to represent as separate tables. Again, the codeframe object replicates the content of the test, testlet and test item objects, and it is highlighted in blue:

![E-R diagram](https://raw.githubusercontent.com/nsip/naplan-results-reporting/master/NAPResponses1.png "Expanded E-R diagram")

## Release Notes

The objects described here have been included in the Australian Schools Data Model - SIF-AU 3.4.4 (see [SIF spec](http://specification.sifassociation.org/Implementation/AU/3.4.4/ )).

If you have any questions about the schemas, the datasets or how to effectively use SIF Frameworks or other tools NSIP provides please contact us directly at info@nsip.edu.au

## Scott notes library Install (to be cleaned up)

cpan install Data::GUID::Any
cpan install Data::Random::Contact
cpan install String::Random
cpan install Algorithm::LUHN
cpan install List::Compare
cpan install Text::Lorem
cpan install List::Compare
apt-get install wbritish
