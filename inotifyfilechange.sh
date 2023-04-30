#!/bin/sh

inotifywait -r /home/vhp/OpenPLC_v3/webserver/st_files -e create -e moved_to |
        while read dir action file; do
                echo "$file added"
                cd /home/vhp/OpenPLC_v3/webserver/
                bash /home/vhp/OpenPLC_v3/webserver/scripts/compile_program.sh $file
                SQL_AUTOST="UPDATE Settings SET Value = 'true' WHERE Key = 'Start_run_mode';"
                SQL_SCRIPT="INSERT INTO Programs (Name, Description, File, Date_upload) VALUES ('Test', 'Desc', '$file', strftime('%s', 'now'));"
                sqlite3 /home/vhp/OpenPLC_v3/webserver/openplc.db "$SQL_SCRIPT"
                sqlite3 /home/vhp/OpenPLC_v3/webserver/openplc.db "$SQL_AUTOST"
                reboot
        done
