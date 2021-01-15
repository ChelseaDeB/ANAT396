#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Oct  6 14:15:50 2020

@author: chelsea
"""

import csv
import requests
import xml.etree.ElementTree as ET



with open('CompiledData.csv', 'w', newline='') as csvfile, open("Report.txt", 'w') as reportFile:
    
    fieldnames = ['Protein_Name', 'UniProt_ID', 'Gene_Name', 'InterPro', 'OrthoDB', 'Amino_Acids_Number']
    writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
    writer.writeheader()

           
    with open('Proteins.csv') as file:#Reading proteins from this file 
        Proteins = csv.reader(file, delimiter=',')
        line = 0
        for Protein in Proteins:
           
                        
            
            #try block to catch any invalid IDs. If ID is invali then the report file will detail which ID is in valid and how that 
            #specific ID was skipped and the remaining valid IDs were processed
            try:
                #Get retreive XML from Uniprot
                url = 'https://www.uniprot.org/uniprot/' + Protein[0] +'.xml'
                r = requests.get(url)
                
                
           
                #writting the Uniprot page to a file
                open('result.xml', 'wb').write(r.content)
                
                
                proteinDataTree= ET.parse('result.xml') #parses the xml file
                proteinData=proteinDataTree.getroot() #gets root
                index = 0
        
                InterPro = []
                OrthoDB = ""
        
                #finding the protein name
                description = proteinData[0].find('{http://uniprot.org/uniprot}protein')
                if (description.find('{http://uniprot.org/uniprot}submittedName')):
                        ProteinName = description.find('{http://uniprot.org/uniprot}submittedName').find('{http://uniprot.org/uniprot}fullName').text
                    
                elif (description.find('{http://uniprot.org/uniprot}recommendedName')):
                        ProteinName = description.find('{http://uniprot.org/uniprot}recommendedName').find('{http://uniprot.org/uniprot}fullName').text
                    
        
                #finding the uniprot ID
                accession = proteinData[0].find('{http://uniprot.org/uniprot}accession').text
        
        
                #Finding references to this protein or homologs of it in different databases/sites
                for x in proteinData[0].findall('{http://uniprot.org/uniprot}dbReference'):
                    dbRef = x.attrib
                
                    #checking InTerPro
                    if (dbRef['type'] == 'InterPro'):
                        InterPro.append(dbRef['id'])
                
                    #checking OrthoDB
                    elif (dbRef['type'] == 'OrthoDB'):
                        OrthoDB = dbRef['id']
        
                #Finding the gene name 
                if proteinData[0].find('{http://uniprot.org/uniprot}gene'):
                    GeneName=proteinData[0].find('{http://uniprot.org/uniprot}gene').find('{http://uniprot.org/uniprot}name').text
                else:
                    GeneName = "N/A"
        
        
            
                #Finding the Number of amino acids
                seq = proteinData[0].find('{http://uniprot.org/uniprot}sequence')
                NumAAs = seq.attrib['length']  #hold the number of amino acids 
                
                
                ''' Writing to CSV file'''
                InterProString = X = " ".join(InterPro)
                writer.writerow({'Protein_Name': ProteinName, 'UniProt_ID': accession, 'Gene_Name' : GeneName, 'InterPro' : InterProString, 'OrthoDB' : OrthoDB, 'Amino_Acids_Number' : NumAAs })
                      
            except ET.ParseError :
                
                reportFile.write( "Invalid UniProt ID: " + Protein[0] + "\nUnable to process, therefore skipped and moved to the next protein ID. Ensure spelling is correct\n")
                
            
    file.close()
    reportFile.write("Protein IDs finished Processing\n")
csvfile.close()
reportFile.close()


