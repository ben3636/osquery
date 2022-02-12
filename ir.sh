echo '' > ir-results.txt

echo '------ Launchd + Sigs ------' >> ir-results.txt

echo 'select distinct l.name,l.path,l.program,s.signed,s.authority from launchd as l join signature as s on s.path=l.path where l.path not like "/System/Library/%";' | osqueryi --json >> ir-results.txt

echo '------ Kern Ext + Sigs ------' >> ir-results.txt

echo 'select k.name,k.path,s.signed,s.authority from kernel_extensions AS k JOIN signature AS s on s.path=k.path WHERE k.path NOT LIKE "/System/%" UNION SELECT split(f.path,"/",2),f.path,x.signed,x.authority FROM file AS f JOIN signature AS x on x.path=f.path WHERE f.path LIKE "/Library/Extensions/%";' | osqueryi --json >> ir-results.txt

echo '------ Sys Ext + Sigs ------' >> ir-results.txt

echo 'select * from system_extensions AS e join signature AS s on s.path=e.path;' | osqueryi --json >> ir-results.txt

echo '------ PKG Installs ------' >> ir-results.txt

echo 'select name, package_id, source, datetime(time, "unixepoch") AS install_time from package_install_history WHERE source NOT LIKE "softwareupdated" ORDER by install_time desc;' | osqueryi --json >> ir-results.txt

echo '------ PKG Reciepts ------' >> ir-results.txt

echo 'select package_id, location, installer_name, datetime(install_time, "unixepoch") AS install_time from package_receipts WHERE installer_name NOT LIKE "softwareupdated" ORDER by install_time desc;' | osqueryi --json >> ir-results.txt

echo '------ Apps ------' >> ir-results.txt

echo 'select name,path from apps WHERE path not LIKE "/System/%";' | osqueryi --json >> ir-results.txt
