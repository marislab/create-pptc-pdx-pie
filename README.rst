.. |date| date::

*******************************
PPTC PDX Pie Generation
*******************************

:authors: Jo Lynne Rokita
:contact: Jo Lynne Rokita (rokita@email.chop.edu)
:organization: CHOP
:status: In-process
:date: |date|

.. meta::
   :keywords: pdx, mouse, WES, RNA-Seq, Fusions, SNP array, 2019
   :description: code to recreate Figure 1, PDX pie chart by histology and assay performed

Introduction
============

Here, we provide scripts to enable reproducible generation of Manuscript Figure 1: pie chart by PDX histology and assay.


Details
=======

- install-packages.R
- create-pie.R
- pie-colors.txt
- pptc-pdx-clinical-web.txt


Software Requirements
=====================

R 3.4.3

Pipeline
========

.. code-block:: bash

         # How to run:
         # Download github repository in your home directory (~/)
         git clone https://github.com/marislab/create-pptc-pdx-pie.git

         # Run script to create pie chart
         Rscript ~/create-pptc-pdx-pie/R/create-pie.R

