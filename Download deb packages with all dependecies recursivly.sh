libs=()

function downDep {
	IFS=$'\r\n' GLOBIGNORE='*' command eval 'input=($(cat dep.txt))'
	mkdir dep

	for dependecy in "${input[@]}"
	do
		apt-get download $dependecy
		cd dep
		
		newDependecies=$(apt-cache depends -i $dependecy | awk '/Depends:/ {print $2}')
		for i in $newDependecies
		do
			alreadyDownloaded=0;
			for j in "${libs[@]}"
			do
				lib=${j%,*}
				if [[ $lib == $i ]] ; then
					alreadyDownloaded=1
				fi
			done
			
			echo "libs: ${libs[@]}"
			
			if !((alreadyDownloaded))
			then
			  : 
				libs=("${libs[@]}", $i)
				echo $i>>dep.txt
				downDep
			fi
		done
		
		cd ..
	done
}

downDep
