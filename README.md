# naplan-results-reporting
NAPLAN Results and Reporting draft dataset. First draft of objects to be used to  encode results from NAPLAN, for communicating results between the National Assessment Platform and Test Administration Authorities.

The objects described here will be proposed for inclusion in SIF-AU 3.4.x (see [SIF spec](http://specification.sifassociation.org/Implementation/AU/1.4/html/); we expect that the definition of the dataset will be refined in the next few months, through discussion with both the   National Assessment Platform developers and the Test Administration Authorities.

This repository includes a cut-down XSD specific to the reporting objects, and a definition of the dataset. It also includes sample data based on the XSD schema:  

* 100 students all enrolled in the same school, distributed among years 3, 5, 7, 9
* test objects for all domains of NAPLAN
* a selection of adaptive testlets for all tests, following  the node structure (A-F)
* 10 possible testlets per node
* 5 items per test, with randomised item types
* student response sets for all students that have participated in all tests (90%)
* test score summaries for all test

The data is randomised, and is not intended to represent real test constructs.
