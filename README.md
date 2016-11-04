# naplan-results-reporting


## NAPLAN Results and Reporting draft dataset. 
This is the first draft of objects to be used to  encode results from NAPLAN, for communicating results between the National Assessment Platform and Test Administration Authorities.

## Important Notes
The NAPLAN Online Assessment Platform is still under development, and as a result this specification is likely to change.

This version of the results reporting dataset is provided as an early access release intended to help systems integrators who need to understand the high-level concepts of the results reporting data structure.

NSIP strongly recommends that users of this specificaiton register as GitHub users, and click on the 'Watch' button in the top right-hand corner of the GitHub web interface - this will ensure that if and when changes are made to the specification you will be notified automatically.

NSIP has included sample data in XML format as part of this release, these are the files named with the convention **nap _object name_ .xml**

Please note, these files contain valid data in all elements, but do not constitute a realistc results dataset. NSIP will be working with ACARA to produce sample data that contains realistic values, but for now the data is there only for guidance in constructing integrations.

It is also important to know that in the final results reporting data file the NAPLAN Platform will produce, all objects will be in a single file. We have provided individual object files in order to make working with and understanding each object easier.


## What you can find here

* Technical Specification Document
  * _Results and Reporting Dataset - Tech Spec 0.5.pdf_
  * This document describes the specification of the results reporting objects
* Dataset Dictionary
  * _Online NAPLAN Reporting Dataset 1.99.xslx_
  * This is an excel version of the object schema giving details of all field types 
* XSD for Object Validation
  * _SIF_Message.xsd_
  * This is an xsd containing all of the object definitions and linkages, for use in validating results-reporting files or for constructing schemas/code to handle the data
* Sample Data Files
  * **nap _object name_ .xml**
  * A series of files each containing sample data sets for the objects

## Specification Overview
The proposed results reporting objects are organised as follows:

![E-R diagram](https://raw.githubusercontent.com/nsip/naplan-results-reporting/master/NAPResponses.png "E-R diagram")

This repository includes a cut-down SIF-AU XSD specific to the reporting objects, and a definition of the dataset. It also includes sample data based on the XSD schema generated with the following criteria:  

* 100 students all enrolled in the same school, distributed among years 3, 5, 7, 9
* test objects for all domains of NAPLAN
* a selection of adaptive testlets for all tests, following  the node structure (A-F)
* 10 possible testlets per node
* 5 items per test, with randomised item types
* student response sets for all students that have participated in all tests (90%)
* test score summaries for all test

The data is randomised, and is not intended to represent real test constructs.

We will be including codeframe information in the results reporting dataset, and will update this specification as soon as the final structure of this data has been agreed.

## Release Notes

The objects described here are proposed for inclusion in the Australian Schools Data Model - SIF-AU 3.4.x (see [SIF spec](http://specification.sifassociation.org/Implementation/AU/1.4/html/); we expect that the definition of the dataset will be refined in the next few months, through discussion with both the National Assessment Platform developers, ACARA and the Test Administration Authorities.

NSIP will be working with all jurisdictions and system stakeholders to refine the dataset to final status as quickly as possible.

If you have any questions about the schemas, the datasets or how to effectively use SIF Frameworks or other tools NSIP provides please contact us directly at info@nsip.edu.au

