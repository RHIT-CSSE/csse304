# E&C Homework

For this diagram topic we will be using a "flipped" approach.

## Before Day 1 

Prior to E&C Day 1 class session you will watch a 3 part video and do 3 small practice problems.  

Problems are in EandC_Homework.docx

1. Watch Day 1 pt 1: https://rose-hulman.hosted.panopto.com/Panopto/Pages/Viewer.aspx?id=b6c4c444-034d-4bb2-9124-b19d00e5ebf5
2. Do Day 1A problem
3. Watch Day 1 pt 2: https://rose-hulman.hosted.panopto.com/Panopto/Pages/Viewer.aspx?id=5b8895cc-c5ce-4a92-b7f6-b19d00e6dba9
4. Do Day 1B problem
5. Watch Day 1 pt 3: https://rose-hulman.hosted.panopto.com/Panopto/Pages/Viewer.aspx?id=c41a706d-5550-4bca-b3b7-b19d00e6db76
6. Do Day 1C problem

## Day 1 In-Class

You will do and turn in Day 1 Inclass for homework credit.

## Before Day 2

Prior to E&C Day 1 class session you will watch a 2 part video and do 2 small practice problems.  

1. Watch Day 2 pt 1: https://rose-hulman.hosted.panopto.com/Panopto/Pages/Viewer.aspx?id=1f3cd750-698f-4aad-8b1f-b19d0100f50e
2. Do Day 2A problem
3. Watch Day 2 pt 2: https://rose-hulman.hosted.panopto.com/Panopto/Pages/Viewer.aspx?id=cfb65f99-ee63-4d79-a55e-b19d0100f4a9
4. Do Day 2B problem

## Day 1 In-Class

You will do and turn in Day 2 Inclass for homework credit.

## General advice

Your diagram must follow the style used in the class examples:
1.	A closure has three parts (argument list, code, environment pointer).  
2.	A local environment has two parts (a table of variables and their values, and a pointer to an environment produced by enclosing code (if any). 
3.	Environment pointers always point to environments, never to closures or code.
4.	The value associated with a variable in an environment is never an environment, and it is never code.
5.	You can’t have two arrows coming from the same “pointer location”.  
6.	Arrows never point to something “inside the box” of an environment or closure.
7.	Place sequence numbers (start with 1) near each environment or closure that you draw and near each new entry in the global environment, to indicate the order in which these references are created during the execution of the code.
8.	For simplicity in the case of let, you should pretend that let is executed directly (without translation into an application of lambda), so that all you need to show is the environment extension, rather than creating a closure followed by the environment extension created by the application of that closure.  
9.	Show the changes this code makes to the global environment, and also include those in your sequence numbering.