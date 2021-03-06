# jarsigner(1) completion -*- shell-script -*-
_jarsigner()
{
	local cur prev words cword
	_init_completion || return
	case $prev in
		-keystore)
			COMPREPLY=( $( compgen -W 'NONE' -- "$cur" ) )
			_filedir '@(jks|ks|p12|pfx)'
			return 0
			;;
			-storepass|-keypass|-sigfile|-digestalg|-sigalg|-tsacert|-altsigner|\
				-altsignerpath|-providerName|-providerClass|-providerArg)
			return 0
			;;
		-storetype)
			COMPREPLY=( $( compgen -W 'JKS PKCS11 PKCS12' -- "$cur" ) )
			return 0
			;;
		-signedjar)
			_filedir apk
			return 0
			;;
		-tsa)
			_filedir
			return 0
			;;
	esac
	# Check if a apk was already given.
	local i apk=false
	for (( i=0; i < ${#words[@]}-1; i++ )) ; do
		if [[ "${words[i]}" == *.apk && \
			"${words[i-1]}" != -signedjar ]] ; then
		apk=true
		break
	fi
done
if ! $apk ; then
	if [[ "$cur" == -* ]] ; then
		# Documented as "should not be used": -internalsf, -sectionsonly
		COMPREPLY=( $( compgen -W '-keystore -storepass -storetype
		-keypass -sigfile -signedjar -digestalg -sigalg -verify
		-verbose -certs -tsa -tsacert -altsigner -altsignerpath
		-protected -providerName -providerClass -providerArg' \
			-- "$cur" ) )
	fi
	_filedir apk
fi
} &&
	complete -F _jarsigner jarsigner
# ex: ts=4 sw=4 et filetype=sh
