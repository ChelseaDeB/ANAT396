#!/bin/bash


#if you have conda installed and sed not working than might have to type 
#conda install -c conda-forge sed' in your terminal to update sed

#This is to selecte a line and replace it from the python program 
#sed 's/ START OF THE LINE \(.*\)END OF THE LINE/WHAT THE NEW LINE WILL BE/' FILE_WE_ARE_EDITING

#Function that prints out the options that the user can do 
Options (){
	echo "type 1 if you want to process a list of Uniprot IDs"
	echo "Type 2 if you want to merge two pre-existing file"
	echo "Type 3 if you want to convert a pre-existing csv file to html"
	echo "Type 0 if you want to exit"
}

ExitOrContinue () {
	echo "You have completed your task. Type 0 1 2 or 3 with regards to what you would like to do next."
	Options
}

Options
read RESPONSE

while [ $RESPONSE != "0" ]
	do

	if [ $RESPONSE == "1" ]
		then
		echo "This program takes a csv or excel file that contains a list of UniProt IDs. The program will read the IDs from the file \"Proteins.csv\". Is this the file you intend to read from? YES/NO"

		read RESPONSE 	
		while [ $RESPONSE != "YES" ] && [ $RESPONSE != "NO" ]
			do
			echo "Invalid input. Must be YES or NO"
			echo " The program will read the IDs from the file Proteins.csv. Is this the file you intend to read from?"
			read RESPONSE
		done	

		if [[ $RESPONSE == "YES" ]]
			then
			echo "Processing file Proteins.CSV. May take a minute."
			chmod u+x ProcessingProteins.py #changes security to make sure that the file is executable by the user 
			./ProcessingProteins.py
		else 
			echo "whats the name of the file that has the Uniprot IDs of interest?"
			read RESPONSE

			#checking if file is valid
			while ! [ -f $RESPONSE ]
				do 
				echo "File not in folder. Check if there is a spelling mistake or no such file exists. Example of input: Proteins.csv"
				echo "whats the name of the file that has the Uniprot IDs of interest?"
				read RESPONSE
			done
	
			NEWLINE="with open('${RESPONSE}') as file:#Reading proteins from this file "
			sed "s/with open\(.*\)as file:#Reading proteins from this file /$NEWLINE/" ProcessingProteins.py > EditedProcessing.py
			echo "Processing file ${RESPONSE}. May take a minute"
			chmod u+x EditedProcessing.py #changes security to make sure that the file is executable by the user
			./EditedProcessing.py
			rm EditedProcessing.py
	
		fi

		cat Report.txt
		echo "CompiledData.csv was created. Do you want to merge this file with another csv file? YES/NO"
		read RESPONSE
		while [ $RESPONSE != "YES" ] && [ $RESPONSE != "NO" ]	
			do
			echo "Invalid input. Must be YES or NO"
			echo " Do you want to merge the data with another file?"
			read RESPONSE
		done

		if [[ $RESPONSE == "YES" ]]	
			then
			echo "What is the name of the file you want to merge CompiledData.csv. Note: The file must have the Uniprot IDs as a column and that columns must be called Uniprot_ID"
			read RESPONSE

			#checking if file is valid
			while ! [ -f $RESPONSE ]
				do 
				echo "File not in folder. Check if there is a spelling mistake or no such file exists. Example of input: Proteins.csv"
				echo "whats the name of the file that you wish to merge?"
				read RESPONSE
			done
	
			NEWLINE="Data2, Fields2 = DictConvert('${RESPONSE}', 'UniProt_ID') #Reading from file 2"
			sed "s/Data2, Fields2 = DictConvert\(.*\)UniProt_ID') #Reading from file 2/$NEWLINE/" MergingCSVFiles.py > EditedMerge.py
			chmod u+x EditedMerge.py #changes security to make sure that the file is executable by the user
			./EditedMerge.py
			rm EditedMerge.py
			echo "File MergedCSVFile.csv was produced which contains the merged data."

			NEWLINE="with open('DisplayData.html', 'w') as htmlFile, open(\"MergedCSVFile.csv\", \"r\") as dataFile:#creating file for html and opening csv file to convert "
			sed "s/with open('DisplayData.html', 'w') as htmlFile\(.*\)dataFile:#creating file for html and opening csv file to convert/$NEWLINE/" CSVtoHtml.py > EditedCSVtoHTML.py
			chmod u+x EditedCSVtoHTML.py
			./EditedCSVtoHTML.py
			echo "MergedCSVFile.csv was converted to html. You can open DisplayData.html in a web browser to view the file"
			rm EditedCSVtoHTML.py
		else
			echo "CompiledData.csv was created that holds the information for the specified proteins."
			chmod u+x CSVtoHTML.py
			./CSVtoHTML.py 
			echo "CompiledData.csv was converted to html. You can open DisplayData.html in a web browser to view the file"
		fi

		ExitOrContinue
		read RESPONSE
		continue 

	fi

	if [ $RESPONSE == "2" ]
		then
		echo "What is the name of the first file you would like to merge? Note both files must have a column called UniProt_ID that holds the IDs"
		read RESPONSE
		#checking if file is valid
		while ! [ -f $RESPONSE ]
			do 
			echo "File not in folder. Check if there is a spelling mistake or no such file exists. Example of input: Proteins.csv"			
			echo "whats the name of the file that you wish to merge?"
			read RESPONSE	
		done

		NEWLINE="Data1, Fields1 = DictConvert('${RESPONSE}', 'UniProt_ID') #Reading from file 1"
		sed "s/Data1, Fields1 = DictConvert\(.*\)UniProt_ID') #Reading from file 1/$NEWLINE/" MergingCSVFiles.py > EditedMerge.py

		echo "What is the name of the second file you would like to merge? Note both files must have a column called UniProt_ID that holds the IDs"
		read RESPONSE
		
		#checking if file is valid
		while ! [ -f $RESPONSE ]
			do 
			echo "File not in folder. Check if there is a spelling mistake or no such file exists. Example of input: Proteins.csv"		
			echo "whats the name of the file that you wish to merge?"
			read RESPONSE	
		done

		NEWLINE="Data2, Fields2 = DictConvert('${RESPONSE}', 'UniProt_ID') #Reading from file 2"
		sed "s/Data2, Fields2 = DictConvert\(.*\)UniProt_ID') #Reading from file 2/$NEWLINE/" MergingCSVFiles.py > EditedMerge.py
		chmod u+x EditedMerge.py #changes security to make sure that the file is executable by the user
		./EditedMerge.py
		echo "Files merged"
		rm EditedMerge.py

		NEWLINE="with open('DisplayData.html', 'w') as htmlFile, open(\"MergedCSVFile.csv\", \"r\") as dataFile:#creating file for html and opening csv file to convert "
		sed "s/with open('DisplayData.html', 'w') as htmlFile\(.*\)dataFile:#creating file for html and opening csv file to convert/$NEWLINE/" CSVtoHtml.py > EditedCSVtoHTML.py
		chmod u+x EditedCSVtoHTML.py
		./EditedCSVtoHTML.py
		echo "Merged file was converted to html. You can open DisplayData.html in a web browser to view the file"
		rm EditedCSVtoHTML.py

		ExitOrContinue
		read RESPONSE
		continue 
	fi

	if [ $RESPONSE == "3" ]
		then 
		echo "What is the name of the file you want to change?"
		read RESPONSE

		while ! [ -f $RESPONSE ]
			do 
			echo "File not in folder. Check if there is a spelling mistake or no such file exists. Example of input: Proteins.csv"		
			echo "whats the name of the file that you wish to convert?"
			read RESPONSE	
		done

		NEWLINE="with open('DisplayData.html', 'w') as htmlFile, open(\"${RESPONSE}\", \"r\") as dataFile:#creating file for html and opening csv file to convert "
		sed "s/with open('DisplayData.html', 'w') as htmlFile\(.*\)dataFile:#creating file for html and opening csv file to convert/$NEWLINE/" CSVtoHtml.py > EditedCSVtoHTML.py
		chmod u+x EditedCSVtoHTML.py
		./EditedCSVtoHTML.py
		echo "Merged file was converted to html. You can open DisplayData.html in a web browser to view the file"
		rm EditedCSVtoHTML.py

		ExitOrContinue
		read RESPONSE
		continue 

	else
		echo "Invalid input. Must be 0, 1, 2, or 3"
		Options
		read RESPONSE
		continue 
		

	fi
done

echo "You have exited the program."





	







	
