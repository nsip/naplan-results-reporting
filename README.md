# naplan-results-reporting


## NAPLAN Results and Reporting draft dataset. 
This is a draft of objects to be used to  encode results from NAPLAN, for communicating results between the National Assessment Platform and Test Administration Authorities.

## Important Notes
The NAPLAN Online Assessment Platform is still under development, and as a result this specification is likely to change.

This version of the results reporting dataset is provided as an early access release intended to help systems integrators who need to understand the high-level concepts of the results reporting data structure.

NSIP strongly recommends that users of this specification register as GitHub users, and click on the 'Watch' button in the top right-hand corner of the GitHub web interface - this will ensure that if and when changes are made to the specification you will be notified automatically.

NSIP has included sample data in XML format as part of this release: these are the files named with the convention **nap _object name_ .xml**

Please note, these files contain valid data in all elements, but do not constitute a realistic results dataset. NSIP has been working with ACARA to produce sample data that contains realistic values, and many of the fields are now realistic, but the data is primarily there for guidance in constructing integrations.

Note also that in the final results reporting data file the NAPLAN Platform will produce, all objects will be in a single file. We have provided both a single output file and separate individual object files, in order to make working with and understanding each object easier.


## What you can find here

* Technical Specification Document
  * _Results and Reporting Dataset - Tech Spec 0.6.docx_
  * This document describes the specification of the results reporting objects
* Dataset Dictionary
  * _Online NAPLAN Reporting Dataset 2 02 - For release.xslx_
  * This is an excel version of the object schema giving details of all field types 
* XSD for Object Validation
  * _SIF_Message.xsd_
  * This is an xsd containing all of the object definitions and linkages, for use in validating results-reporting files or for constructing schemas/code to handle the data
* Sample Data Files
  * **nap _object name_ .xml**
  * A series of files containing sample data sets for each object
  * **master_nap.xml**
  * A single file containing all the sample data files
  * **nap-samplefile.xml**
  * A single file containing one instance for each object, to illustrate the inclusion of all object types in the one file

## Specification Overview
The proposed results reporting objects are organised as follows:

![E-R diagram](https://raw.githubusercontent.com/nsip/naplan-results-reporting/master/NAPResponses.png "E-R diagram")

The codeframe object packages the same content as the test, testlet, and test item objects, and is highlighted in blue.

This repository includes a cut-down SIF-AU XSD specific to the reporting objects, and a definition of the dataset. It also includes sample data based on the XSD schema generated with the following criteria:  

* 800 students enrolled in four different schools, distributed among years 3, 5, 7, 9
* test objects for all domains of NAPLAN
* student response sets for all students that have participated in all tests (90%)
* a selection of adaptive testlets and corresponding items for all tests, following  the NAPLAN node structure (A-F), and the allocation of testlets per node that ACARA has established. The items include adjustment substitutes.
  * The testlets and items are made available both as a single codeframe object per test, which we assume jurisdictions will consume in advance, and as separate testlet and test item objects, which are referenced from the student response sets
* test score summaries for all tests

The data is randomised, and is not intended to represent real test constructs. However the values included in the dataset are intended to be as realistic as possible.

We will be including codeframe information in the results reporting dataset, and will update this specification as soon as the final structure of this data has been agreed.

As guidance for any database design intended to ingest this data, the following diagram presents all lists included within the objects, which a relational database would need to represent as separate tables. Again, the codeframe object replicates the content of the test, testlet and test item objects, and it is highlighted in blue:

![E-R diagram](https://raw.githubusercontent.com/nsip/naplan-results-reporting/master/NAPResponses1.png "Expanded E-R diagram")

## Release Notes

The objects described here are proposed for inclusion in the Australian Schools Data Model - SIF-AU 3.4.x (see [SIF spec](http://specification.sifassociation.org/Implementation/AU/1.4/html/); we expect that the definition of the dataset will be refined in the next few months, through discussion with both the National Assessment Platform developers, ACARA and the Test Administration Authorities.

NSIP will be working with all jurisdictions and system stakeholders to refine the dataset to final status as quickly as possible.

If you have any questions about the schemas, the datasets or how to effectively use SIF Frameworks or other tools NSIP provides please contact us directly at info@nsip.edu.au

