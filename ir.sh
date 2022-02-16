#!/bin/bash

mkdir -p ./IR_Results

echo 'LaunchAgents & LaunchDaemons + Signature' > IR_Results/launchd.txt
echo 'select distinct l.name,l.path,l.program,l.program_arguments,s.signed,s.authority from launchd as l join signature as s on s.path=l.path where l.path not like "/System/Library/%";' | osqueryi --csv  >> IR_Results/launchd.txt

echo 'Kernel Extensions + Signature' > IR_Results/kernext.txt
echo 'select k.name,k.path,s.signed,s.authority from kernel_extensions AS k JOIN signature AS s on s.path=k.path WHERE k.path NOT LIKE "/System/%" UNION SELECT split(f.path,"/",2),f.path,x.signed,x.authority FROM file AS f JOIN signature AS x on x.path=f.path WHERE f.path LIKE "/Library/Extensions/%";' | osqueryi --csv  >> IR_Results/kernext.txt

echo 'System Extensions + Signature' > IR_Results/sysext.txt
echo 'select DISTINCT e.path,e.state,e.identifier,e.category,e.version,e.team,s.signed,s.authority from system_extensions AS e join signature AS s on s.path=e.path;' | osqueryi --csv  >> IR_Results/sysext.txt

echo 'Package Installs' > IR_Results/pkginstalls.txt
echo 'select name, package_id, source, datetime(time, "unixepoch") AS install_time from package_install_history WHERE source NOT LIKE "softwareupdated" ORDER by install_time desc;' | osqueryi --csv  >> IR_Results/pkginstalls.txt

echo 'Package Receipts' > IR_Results/pkgrec.txt
echo 'select package_id, location, installer_name, datetime(install_time, "unixepoch") AS install_time from package_receipts WHERE installer_name NOT LIKE "softwareupdated" ORDER by install_time desc;' | osqueryi --csv  >> IR_Results/pkgrec.txt

echo 'Apps' > IR_Results/apps.txt
echo 'select name,path from apps WHERE path not LIKE "/System/%";' | osqueryi --csv  >> IR_Results/apps.txt


dir='IR_Results/'

# Print 1st Half of HTML
echo '<html>' > RESULTS.html
echo '<body style="background-color:#000000;color:white">' >> RESULTS.html
echo '<style>' >> RESULTS.html
echo 'table {' >> RESULTS.html
echo 'border-collapse: collapse;' >> RESULTS.html
echo '}' >> RESULTS.html
echo 'th, td {' >> RESULTS.html
echo 'border: 1px solid white;' >> RESULTS.html
echo 'padding: 10px;' >> RESULTS.html
echo 'text-align: left;' >> RESULTS.html
echo '}' >> RESULTS.html
echo '</style>' >> RESULTS.html
echo '</style>' >> RESULTS.html
echo '<div style="text-align:center">' >> RESULTS.html
echo '<h1><b>Incident Response Results</b></h1>' >> RESULTS.html
echo '</div>' >> RESULTS.html
echo '<hr />' >> RESULTS.html

ls -1 IR_Results | grep -v items.tmp | while read file
do
	# Print Query Name
	name=$(head -n 1 $dir$file)
	echo "<h1>$name</h1>"
	echo '<table>'

	# Get Column Names
	sed -n '2p' $dir$file | while read line
	do
		echo '<tr>'
		headers=$(echo $line | sed -e "s/\|/\n/g")
		for i in $headers
		do
			td="<th>$i</th>"
			echo $td
		done
		echo '</tr>'

	done

	# Get Table Items
	sed 1,2d $dir$file | while read line
	do
		echo '<tr>'
		echo $line | sed -e "s/\|/\n/g" > $diritems.tmp
		cat $diritems.tmp | while read line
		do
			td="<th>$line</th>"
			echo $td
		done
		echo '</tr>'
	done
	echo '</table>'
	echo '</body>'
	echo '</html>'
done | sed -e "s/\"\"//g" >> RESULTS.html
