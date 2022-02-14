echo '' > ir-results.txt
echo '------------------------------------------------------------------------------------------------' >> ir-results.txt
echo '                             LaunchAgents & LaunchDaemons + Signature                             ' >> ir-results.txt
echo '------------------------------------------------------------------------------------------------' >> ir-results.txt


echo 'select distinct l.name,l.path,l.program,l.program_arguments,s.signed,s.authority from launchd as l join signature as s on s.path=l.path where l.path not like "/System/Library/%";' | osqueryi --csv | column -t -s "|" >> ir-results.txt

echo >> ir-results.txt
echo '------------------------------------------------------------------------------------------------' >> ir-results.txt
echo '                                  Kernel Extensions + Signature                                 ' >> ir-results.txt
echo '------------------------------------------------------------------------------------------------' >> ir-results.txt

echo 'select k.name,k.path,s.signed,s.authority from kernel_extensions AS k JOIN signature AS s on s.path=k.path WHERE k.path NOT LIKE "/System/%" UNION SELECT split(f.path,"/",2),f.path,x.signed,x.authority FROM file AS f JOIN signature AS x on x.path=f.path WHERE f.path LIKE "/Library/Extensions/%";' | osqueryi --csv | column -t -s "|" >> ir-results.txt

echo >> ir-results.txt
echo '------------------------------------------------------------------------------------------------' >> ir-results.txt
echo '                                  System Extensions + Signature                                 ' >> ir-results.txt
echo '------------------------------------------------------------------------------------------------' >> ir-results.txt


echo 'select DISTINCT e.path,e.state,e.identifier,e.category,e.version,e.team,s.signed,s.authority from system_extensions AS e join signature AS s on s.path=e.path;' | osqueryi --csv | column -t -s "|" >> ir-results.txt

echo >> ir-results.txt
echo '------------------------------------------------------------------------------------------------' >> ir-results.txt
echo '                                        Package Installs                                        ' >> ir-results.txt
echo '------------------------------------------------------------------------------------------------' >> ir-results.txt

echo 'select name, package_id, source, datetime(time, "unixepoch") AS install_time from package_install_history WHERE source NOT LIKE "softwareupdated" ORDER by install_time desc;' | osqueryi --csv | column -t -s "|" >> ir-results.txt

echo >> ir-results.txt
echo '------------------------------------------------------------------------------------------------' >> ir-results.txt
echo '                                        Package Receipts                                        ' >> ir-results.txt
echo '------------------------------------------------------------------------------------------------' >> ir-results.txt

echo 'select package_id, location, installer_name, datetime(install_time, "unixepoch") AS install_time from package_receipts WHERE installer_name NOT LIKE "softwareupdated" ORDER by install_time desc;' | osqueryi --csv | column -t -s "|" >> ir-results.txt

echo >> ir-results.txt
echo '------------------------------------------------------------------------------------------------' >> ir-results.txt
echo '                                              Apps                                              ' >> ir-results.txt
echo '------------------------------------------------------------------------------------------------' >> ir-results.txt


echo 'select name,path from apps WHERE path not LIKE "/System/%";' | osqueryi --csv | column -t -s "|" >> ir-results.txt
