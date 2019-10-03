a=
b="-b"
mark=
enrol=
check=
for f in "$@" ; do
	if [ "$f" = "-s" ] || [ "$f" = "-u" ]; then
		if [ -z "$check" ]; then
			a="$f"
		fi
	elif [ "$f" = "-b" ] || [ "$f" = "-q" ] || [ "$f" = "-0" ]; then
		b="$f"
	fi

	if [ -f "$f" ] && [ -z "$enrol" ]; then
		enrol="$f"
		check="a"
	elif [ -f "$f" ] && [ -n "$enrol" ]; then
		mark="$f"
	fi
done

if [ -z "$a" ]; then
	exit 1
fi
if [ -z "$mark" ] || [ -z "$enrol" ]; then
	exit 1
fi

if [ "$a" = "-s" ]; then
	if [ "$b" = "-b" ]; then
		sort -t, -k 2,2 "$enrol" | join -t, -a 1 -1 2 -2 1 -o 1.1,2.2 - "$mark" | sort -t, -k 1,1
	elif [ "$b" = "-q" ]; then
		sort -t, -k 2,2 "$enrol" | join -t, -1 2 -2 1 -o 1.1,2.2 - "$mark" | sort -t, -k 1,1
	elif [ "$b" = "-0" ]; then
		sort -t, -k 2,2 "$enrol" | join -t, -a 1 -e 0 -1 2 -2 1 -o 1.1,2.2 - "$mark" | sort -t, -k 1,1
	fi

elif [ "$a" = "-u" ]; then
	if [ "$b" = "-b" ]; then
		sort -t, -k 1,1 "$enrol" | join -t, -a 1 -1 1 -2 1 -o 1.2,2.2 - "$mark" | sort -t, -k 1,1
        elif [ "$b" = "-q" ]; then
		sort -t, -k 1,1 "$enrol" | join -t, -1 1 -2 1 -o 1.2,2.2 - "$mark" | sort -t, -k 1,1
        elif [ "$b" = "-0" ]; then
		sort -t, -k 1,1 "$enrol" | join -t, -a 1 -e 0 -1 1 -2 1 -o 1.2,2.2 - "$mark" | sort -t, -k 1,1
        fi
fi
